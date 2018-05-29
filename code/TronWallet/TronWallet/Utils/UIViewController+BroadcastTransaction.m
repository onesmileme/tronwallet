//
//  UIViewController+BroadcastTransaction.m
//  TronWallet
//
//  Created by chunhui on 2018/5/29.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "UIViewController+BroadcastTransaction.h"

@implementation UIViewController (BroadcastTransaction)

-(void)broadcastTransaction:(Transaction *)transaction hud:(MBProgressHUD *)hud completion:(void(^)(Return * _Nullable response, NSError * _Nullable error))completion
{
    transaction = [AppWalletClient signTransaction:transaction];
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    [wallet broadcastTransactionWithRequest:transaction handler:^(Return * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            hud.label.text = [error localizedDescription];
        }else{
            if (response.code == Return_response_code_Success) {
                hud.label.text = @"Success";
            }else{
                hud.label.text = [[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding];
            }
        }
        [hud hideAnimated:YES afterDelay:1 ];
        if (completion) {
            completion(response,error);
        }        
    }];
}

@end
