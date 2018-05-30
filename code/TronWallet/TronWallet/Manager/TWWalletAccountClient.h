//
//  TWWalletAccountClient.h
//  TronWallet
//
//  Created by chunhui on 2018/5/24.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWEllipticCurveCrypto.h"

typedef NS_ENUM( NSInteger,TWWalletType) {
    TWWalletDefault = 0, //正常钱包
    TWWalletCold   = 1,//冷钱包
    TWWalletAddressOnly  = 2,//只有地址
};

@interface TWWalletAccountClient : NSObject

@property(nonatomic , strong) Account *account;

@property(nonatomic , strong , readonly) TWEllipticCurveCrypto *crypto;

@property(nonatomic , assign) TWWalletType type;

+(instancetype)loadWallet;

+(NSString *)loadPwdKey;

+(NSString *)loadPriKey;

+(BOOL)isCold;

/*
 * load with current encoded password
 */
+(instancetype)walletWithPassword:(NSString *)password;

-(instancetype)initWithPriKey:(NSData *)priKey  type:(TWWalletType)type;

-(instancetype)initWithGenKey:(BOOL)genKey type:(TWWalletType)type;

-(instancetype)initWithPriKeyStr:(NSString *)priKey  type:(TWWalletType)type;

-(instancetype)initWithAddress:(NSString *)address;

-(void)clear;

-(void)store:(NSString *)password;

-(NSData *)address;

-(NSString *)base58PriKey;

-(NSString *)base58OwnerAddress;

-(void)refreshAccount:(void(^)(Account *account, NSError *error))completion;

+(NSString *)hexEncPassword:(NSString *)password;

-(Transaction *)signTransaction:(Transaction *)transaction;

+(NSData *)convertPassword:(NSString *)password;
+(NSData *)getEncKey:(NSString *)password;


@end
