//
//  TWWalletAccountClient.h
//  TronWallet
//
//  Created by chunhui on 2018/5/24.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWEllipticCurveCrypto.h"

@interface TWWalletAccountClient : NSObject

@property(nonatomic , strong) Account *account;

@property(nonatomic , strong , readonly) TWEllipticCurveCrypto *crypto;

+(instancetype)walletWithPassword:(NSString *)password;

-(instancetype)initWithPriKey:(NSData *)priKey;

-(instancetype)initWithGenKey:(BOOL)genKey;

-(instancetype)initWithPriKeyStr:(NSString *)priKey;

+(NSString *)loadPwdKey;

+(NSData *)loadPriKey;

-(void)store:(NSString *)password;

-(NSData *)address;

-(NSString *)base58PriKey;

-(NSString *)base58OwnerAddress;

-(void)refreshAccount:(void(^)(Account *account, NSError *error))completion;

+(NSString *)hexEncPassword:(NSString *)password;

@end
