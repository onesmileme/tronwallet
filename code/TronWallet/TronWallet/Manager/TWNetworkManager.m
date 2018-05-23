//
//  TWNetworkManager.m
//  FunApp
//
//  Created by chunhui on 16/6/1.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TWNetworkManager.h"
#import "TKRequestHandler.h"
#import "TKAppInfo.h"
#import "UIDevice+Hardware.h"
#import "Reachability.h"
#import "TKNetworkManager.h"
#import <GRPCClient/GRPCCall+ChannelArg.h>
#import <GRPCClient/GRPCCall+Tests.h>
#import "api/Api.pbrpc.h"

NSString * const KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
NSString * const KEY_PASSWORD = @"com.company.app.password";

#define kNodeIpKey @"__node_ip__"
#define kNodePortKey @"__node_port__"

#define kDefaultIp @"47.254.16.55"
#define kDefaultPort @"50051"

@interface TWNetworkManager()<TKRequestHandlerDelegate>

@property(nonatomic , strong) NSMutableDictionary *extraInfo;
@property(nonatomic , strong) NSString *cuid;

@property(nonatomic , strong) Wallet *walletClient;
@property(nonatomic , strong) WalletSolidity *walletSolidityClient;
@property(nonatomic , strong) Network *networkClient;
@property(nonatomic , strong) Database *databaseClient;

@property(nonatomic , copy)  NSString *nodeIp;
@property(nonatomic , copy)  NSString *nodePort;

@end


@implementation TWNetworkManager

IMP_SINGLETON

-(instancetype)init
{
    self = [super init];
    if (self) {
        _extraInfo = [[NSMutableDictionary alloc]init];
        
//        NSString *notificatioName = kTKNetworkChangeNotification;

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.nodeIp = [defaults objectForKey:kNodeIpKey];
        self.nodePort = [defaults objectForKey:kNodePortKey];
        
        if (self.nodeIp.length == 0) {
            self.nodeIp = kDefaultIp;
            [defaults setObject:self.nodeIp forKey:kNodeIpKey];
        }
        if (self.nodePort.length == 0) {
            self.nodePort = kDefaultPort;
            [defaults setObject:self.nodePort forKey:kNodePortKey];
        }
        
        [defaults synchronize];
        NSString *address = [NSString stringWithFormat:@"%@:%@",_nodeIp,_nodePort];
        [GRPCCall useInsecureConnectionsForHost:address];
    }
    return self;
}

-(Wallet *)walletClient
{
    if (!_walletClient) {
        _walletClient = [[Wallet alloc]initWithHost:[[self class]appHost]];
    }
    return _walletClient;
}

-(WalletSolidity *)walletSolidityClient
{
    if (!_walletSolidityClient) {
        _walletSolidityClient = [[WalletSolidity alloc]initWithHost:[[self class]appHost]];
    }
    return _walletSolidityClient;
}

-(Network *)networkClient
{
    if (!_networkClient) {
        _networkClient = [[Network alloc]initWithHost:[[self class]appHost]];
    }
    return _networkClient;
}

-(Database *)databaseClient
{
    if (!_databaseClient) {
        _databaseClient = [[Database alloc]initWithHost:[[self class]appHost]];
    }
    return _databaseClient;
}


+(NSString *)appHost
{
    return [NSString stringWithFormat:@"%@:%@",kDefaultIp,kDefaultPort];
}

-(void)resetIp:(NSString *)ip andPort:(NSString *)port
{
    self.nodeIp = ip;
    self.nodePort = port;
    
    NSString *address = [NSString stringWithFormat:@"%@:%@",ip,port];
    [GRPCCall useInsecureConnectionsForHost:address];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.nodeIp forKey:kNodeIpKey];
    [defaults setObject:self.nodePort forKey:kNodePortKey];
    [defaults synchronize];
    
}

-(void)resetToDefault
{
    [self resetIp:kDefaultIp andPort:kDefaultPort];
}

-(NSString *)ip
{
    return _nodeIp;
}

-(NSString *)port
{
    return _nodePort;
}


-(void)setRequestSerializer:(BOOL)isJson resetAuthorization:(BOOL)resetAuth
{
    AFHTTPRequestSerializer *serializer =  isJson ? [AFJSONRequestSerializer serializer]:[AFHTTPRequestSerializer serializer];
    [[TKNetworkManager sharedInstance] setRequestSerializer: serializer];
    if (resetAuth) {
        [serializer setAuthorizationHeaderFieldWithUsername:@"ecclient" password:@"ecclientsecret"];
    }else{
    }
}


-(NSDictionary *)baseParam
{
    NSString *mb = [[UIDevice currentDevice]hwMachineName];
    NSString *osv = [[UIDevice currentDevice]systemVersion];
    NSString *appVersion = [TKAppInfo appVersion];

    return @{@"mb" : mb, @"ov":osv, @"os":@"ios" ,
            @"sv":appVersion ,
             };    
}



#pragma mark - login
-(void)loginDoneNotification:(NSNotification *)notification
{
   // TKUserInfo *userinfo = [[TKAccountManager sharedInstance]userInfo];
   // TKRequestHandler *handler = [TKRequestHandler sharedInstance];
   // [handler setValue:[NSString stringWithFormat:@"%@ %@",userinfo.tokenType,userinfo.accessToken] forHTTPHeaderField:@"Authorization"];
}

-(void)logoutNotification:(NSNotification *)notification
{
    TKRequestHandler *handler = [TKRequestHandler sharedInstance];
    [handler setAuthorizationHeaderFieldWithUsername:@"ecclient" password:@"ecclientsecret"];
}

#pragma mark - request handler
-(void)checkError:(NSInteger)errNo responseData:(NSDictionary *_Nullable)response forRequest:(NSURLRequest *_Nonnull)request
{
    //处理token失效等通用错误
    if (errNo  > 0) {
        switch (errNo) {
            case 10011:
            case 20002:
            case 20003:
            {
                //[[EAPushManager sharedInstance]handleOpenUrl:@"eis://show_login"];
            }
                break;
                
            default:
                break;
        }
    }
    
}

-(void)handleError:(NSError *_Nonnull)error responseDict:(NSDictionary *_Nullable)responseDict response:(NSHTTPURLResponse *_Nonnull)response forRequest:(NSURLRequest *_Nonnull)request
{
    if (responseDict) {
        
        NSString *e = responseDict[@"error"];
        if ([[e lowercaseString] isEqualToString:@"invalid_token"]) {
//            [[TKAccountManager sharedInstance] logout];
//            [self resetToken];
            //[[EAPushManager sharedInstance]handleOpenUrl:@"eis://show_login"];
        }
        
    }else{
        
    }
}

-(NSError *)convertError:(NSError *)error
{
    NSError *err = nil;
    switch (error.code) {
        case kCFURLErrorNotConnectedToInternet:
        case kCFURLErrorUnknown:
        case kCFURLErrorTimedOut:
        case kCFURLErrorCannotConnectToHost:
        case kCFURLErrorResourceUnavailable:
        case kCFURLErrorNetworkConnectionLost:
        {
            err = [NSError errorWithDomain:kRequestNetErrorTip code:error.code userInfo:nil];
        }
            break;
            
        default:
            if (error.userInfo) {
                NSString *msg = error.userInfo[NSLocalizedRecoverySuggestionErrorKey];
                if (msg.length == 0) {
                    msg = error.userInfo[NSLocalizedFailureReasonErrorKey];
                }
                if (msg) {
                    error = [NSError errorWithDomain:msg code:error.code userInfo:error.userInfo];
                }else{
                    error = [NSError errorWithDomain:kRequestFailedTip code:error.code userInfo:error.userInfo];
                }
            }
            
            err = error;
            break;
    }
    
    
    return err;
}


#pragma mark - net work status callback
/**
 *  网络状态
 *   @"0"  未连接
 *   @"1"   wifi连接
 *   @"2"   移动连接
 */
-(void)networkChangeNotification:(NSNotification *)notification
{
    
    NSDictionary *statusInfo = notification.userInfo;
    NetworkStatus status = [statusInfo[@"status"] integerValue];
    NSString *statusTag = nil;
    
    if (status == NotReachable) {
        statusTag = @"0";
    }else if (status == ReachableViaWiFi){
        statusTag = @"1";
    }else{
        statusTag = @"2";
    }
    _extraInfo[@"net"] = statusTag;
    
}


#pragma mark - uuid Keychain使用
- (void)fetchUUID
{
//    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD];
//    NSString *uuidString = [usernamepasswordKVPairs objectForKey:KEY_PASSWORD];
//    
//    if (!uuidString || uuidString.length == 0)
//    {
//        uuidString = [self creatUuid];
//        NSMutableDictionary *uuidMutableDic = [[NSMutableDictionary alloc] initWithCapacity:3];
//        [uuidMutableDic setObject:uuidString forKey:KEY_PASSWORD];
//        [CHKeychain save:KEY_USERNAME_PASSWORD data:uuidMutableDic];
//    }
//    
//    self.cuid = uuidString;
}

- (NSString*) creatUuid
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end
