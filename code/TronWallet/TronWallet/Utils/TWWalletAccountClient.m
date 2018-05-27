//
//  TWWalletAccountClient.m
//  TronWallet
//
//  Created by chunhui on 2018/5/24.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWWalletAccountClient.h"
#import "TWShEncoder.h"
#import "BTCData.h"
#import "NSData+HexToString.h"
#import "NSData+AES128.h"
#import "TWHexConvert.h"
#import "TWEllipticCurveCrypto.h"
#import "NSData+Hashing.h"
#import "BTCBase58.h"
#import "NS+BTCBase58.h"

#define kPriKey @"pri_key"
#define kPubKey @"pub_key"
#define kPwdKey @"pwd_key"


@interface TWWalletAccountClient()

@property(nonatomic , strong) TWEllipticCurveCrypto *crypto;

@end

@implementation TWWalletAccountClient


+(void)load
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        TWWalletAccountClient *client = [[TWWalletAccountClient alloc]initWithGenKey:YES];
//        [client store:@"1234567890"];
//
//    });
}

+(instancetype)walletWithPassword:(NSString *)password
{
    NSString *priKey = [self loadPriKey];
    if (!priKey) {
        return NULL;
    }
    NSData *priData = [TWHexConvert convertHexStrToData:priKey];
    NSData *enPwdData = [self getEncKey:password];
    
    NSString *enpwdBase64 = [enPwdData base64EncodedStringWithOptions:kNilOptions];
    NSData *prikeyEncode = [priData AES128EncryptWithKey:enpwdBase64];
    
//    NSString *hexPriKey = [TWHexConvert convertDataToHexStr:prikeyEncode];
    
    return [[self alloc] initWithPriKey:prikeyEncode];
}


+(NSString *)loadPubKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kPubKey];
}

+(NSString *)loadPriKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kPriKey];
}

+(NSString *)loadPwdKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kPwdKey];
}

+(BOOL)checkLogin:(NSString *)password
{
    NSData *pwdData = [self convertPassword:password];
    NSString* hexPwd = [pwdData convertToHexStr];
    NSString *pwd = [self loadPwdKey];
    return [hexPwd isEqualToString:pwd];
}

-(instancetype)initWithPriKey:(NSData *)priKey
{
    self = [super init];
    if (self) {
        _crypto = [TWEllipticCurveCrypto cryptoForKey:priKey];
        [self loadAccountInfo];
    }
    return self;
}

-(instancetype)initWithGenKey:(BOOL)genKey
{
    self = [super init];
    if(self){
        
        self.crypto = [TWEllipticCurveCrypto generateKeyPairForCurve:TWEllipticCurveSecp256k1];
        
    }
    return self;
}

-(instancetype)initWithPriKeyStr:(NSString *)priKey
{
    NSData *priKeyData = [TWHexConvert convertHexStrToData:priKey];
    return [self initWithPriKey:priKeyData];
}

-(void)printKey:(NSData *)key name:(NSString *)name
{
    printf("key %s ====\n",[name UTF8String]);
    const uint8_t *bytes = (const uint8_t *)[key bytes];
    for (int i = 0 ; i < [key length]; i++) {
        printf("0X%02X ",bytes[i]);
    }
    printf("\n\n");
}

-(void)store:(NSString *)password
{
    NSData *pwdData = [self.class convertPassword:password];
    NSString* hexPwd = [pwdData convertToHexStr];
    NSLog(@"hex pwd is: %@",hexPwd);
    
    
    NSData *priKey = _crypto.privateKey;
    NSData *pubKey = _crypto.publicKey;
    
    [self printKey:priKey name:@"pri key"];
    [self printKey:pubKey name:@"pub_key"];
    
    NSString *basePriKey = _crypto.privateKeyBase64;
    NSString *basePubKey = _crypto.publicKeyBase64;
    NSLog(@"base64 pubkey is: %@\n prikey is: \n%@\n\n",basePubKey,basePriKey);
    
    
    NSData *enpwd = [self.class getEncKey:password];
    
    NSString *enpwdBase64 = [enpwd base64EncodedStringWithOptions:kNilOptions];
    NSData *prikeyEncode = [priKey AES128EncryptWithKey:enpwdBase64];
    
    NSString *hexPriKey = [TWHexConvert convertDataToHexStr:prikeyEncode];
    NSString *hexPubKey = [TWHexConvert convertDataToHexStr:pubKey];
    
    NSLog(@"hex pri key is: %@\n hex pub key is: %@",hexPriKey,hexPubKey);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:hexPwd forKey:kPwdKey];//password
    [defaults setObject:hexPubKey forKey:kPubKey]; //public key
    [defaults setObject:hexPriKey forKey:kPriKey]; //private key
    
    [defaults synchronize];
    
    [self loadAccountInfo];
    
}

-(NSData *)address
{    
    return [_crypto ownerAddress];
}

-(NSString *)base58OwnerAddress
{
    return [_crypto base58OwnerAddress];
}

-(NSString *)base58PriKey
{
    NSData *data = [_crypto privateKey];
    return BTCBase58StringWithData(data);
}

-(void)loadAccountInfo
{
    [self refreshAccount:nil];
}

-(void)refreshAccount:(void(^)(Account *account, NSError *error))completion
{
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    self.account = [[Account alloc]init];
    _account.address = [_crypto ownerAddress];
    
    
    [wallet getAccountWithRequest:_account handler:^(Account * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"get account is: %@",response);
        if(response){
            self.account = response;
        }
        if (completion) {
            completion(response,error);
        }
    }];
}


+(NSData *)convertPassword:(NSString *)password
{
    NSData *pdata = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mdata = BTCSHA256(pdata);
    mdata = BTCSHA256(mdata);
    
    return [mdata subdataWithRange:NSMakeRange(0, 16)];
}

+(NSData *)getEncKey:(NSString *)password
{
    NSData *pdata = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mdata = BTCSHA256(pdata);
    
    return [mdata subdataWithRange:NSMakeRange(0, 16)];
}

+(BOOL)isValidPassword:(NSString *)password
{
    if (password.length < 6) {
        return NO;
    }
    return YES;
}

+(NSString *)encode58Check:(NSData *)data
{
    /*
     byte[] hash0 = Hash.sha256(input);
     byte[] hash1 = Hash.sha256(hash0);
     byte[] inputCheck = new byte[input.length + 4];
     System.arraycopy(input, 0, inputCheck, 0, input.length);
     System.arraycopy(hash1, 0, inputCheck, input.length, 4);
     return Base58.encode(inputCheck);
     */
    
    NSData *hash0 = [data SHA256Hash];
    NSData *hash1 = [hash0 SHA256Hash];
    
    NSMutableData *mdata = [[NSMutableData alloc]initWithCapacity:data.length+4];
    [mdata appendData:data];
    [mdata appendData:[hash1 subdataWithRange:NSMakeRange(0, 4)]];
    
    return BTCBase58StringWithData(mdata);
    
    
}

+(NSData *)decodeBase58Check:(NSString *)address
{
    NSData *addressData = BTCDataFromBase58(address);
    
    [self printData:addressData name:@"address data "];
    
    NSMutableData *baseData = [address dataFromBase58];
    if (baseData.length <= 4) {
        return NULL;
    }
    
    NSData *decodeData = [baseData subdataWithRange:NSMakeRange(0, baseData.length - 4)];
    
    NSData *hash0 = [decodeData SHA256Hash];
    NSData *hash1 = [hash0 SHA256Hash];
    
    
    NSData *compData = [hash1 subdataWithRange:NSMakeRange(0, 4)];
    NSData *addData = [addressData subdataWithRange:NSMakeRange(decodeData.length, 4)];
    
    [self printData:compData name:@"compare data"];
    [self printData:addData name:@"address sub data"];
    
    if ([compData isEqualToData:addData]) {
        return decodeData;
    }
    
    
    return NULL;
}

+(void)printData:(NSData *)data name:(NSString *)name
{
    NSLog(@"-------%@-------",name);
    const uint8_t *bytes = (const uint8_t *)[data bytes];
    printf("===================\n");
    for (int i = 0 ; i < data.length; i++) {
        printf("%02X",bytes[i]);
    }
    printf("\n===================");
}

@end