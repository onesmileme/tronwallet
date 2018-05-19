//
//  TKRequestHandler+MainBlock.m
//  TronWallet
//
//  Created by chunhui on 2018/5/19.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TKRequestHandler+MainBlock.h"

@implementation TKRequestHandler (MainBlock)

-(NSURLSessionDataTask *)getMainBlockChainWithCompletion:(void (^)(NSURLSessionDataTask *task , NSDictionary *model , NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:@"%@/eis/open/user/updateUser",AppHost];
    
    NSURLSessionDataTask *task =  [[TKRequestHandler sharedInstance] postRequestForPath:path param:nil  finish:^(NSURLSessionDataTask * _Nullable sessionDataTask, NSDictionary * _Nullable model, NSError * _Nullable error) {
        
        if (completion) {
            completion(sessionDataTask,model , error);
        }
        
    } ];
    
    return task;
}

-(NSURLSessionDataTask *)getMainRecentTransactionWithCompletion:(void (^)(NSURLSessionDataTask *task , NSDictionary *model , NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:@"%@/eis/open/user/updateUser",AppHost];
    
    NSURLSessionDataTask *task =  [[TKRequestHandler sharedInstance] postRequestForPath:path param:nil  finish:^(NSURLSessionDataTask * _Nullable sessionDataTask, NSDictionary * _Nullable model, NSError * _Nullable error) {
        
        if (completion) {
            completion(sessionDataTask,model , error);
        }
        
    } ];
    
    return task;
}

@end
