//
//  UIViewController+BroadcastTransaction.h
//  TronWallet
//
//  Created by chunhui on 2018/5/29.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BroadcastTransaction)

-(void)broadcastTransaction:(Transaction *)transaction hud:(MBProgressHUD *)hud completion:(void(^)(Return * _Nullable response, NSError * _Nullable error))completion;

@end
