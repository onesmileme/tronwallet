//
//  TWAccountManager.m
//  TronWallet
//
//  Created by chunhui on 2018/5/23.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWAccountManager.h"

@interface TWAccountManager()

@property(nonatomic , strong) Account *sAccount;

@end

@implementation TWAccountManager

IMP_SINGLETON

-(instancetype)init
{
    if (self) {
        NSData *data = [NSData dataWithContentsOfFile:[self path]];
        if (data) {
            _sAccount = [Account parseFromData:data error:nil];
        }else{
            _sAccount = [[Account alloc] init];
        }
    }
    return self;
}

-(void)saveAccount:(Account *)account
{
    if (account == nil) {
        return;
    }
    NSData *d = [account data];
    [d writeToFile:[self path] atomically:YES];
}

-(Account *)account
{
    return _sAccount;
}

-(void)createAccount:(void(^)(Account *account , NSError *error))completion
{
//    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
//    [wallet ]
}

-(NSString *)path
{
    NSString *p = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [p stringByAppendingPathComponent:@"aaa.data"];
}

@end
