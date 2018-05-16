//
//  EANetworkmanager.h
//  FunApp
//
//  Created by chunhui on 16/6/1.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppHost  [TWNetworkManager appHost]

@interface TWNetworkManager : NSObject

DEF_SINGLETON;

/**
 *  应用主的host
 *
 *  @return host
 */
+(NSString *)appHost;


+(NSString *)loginAppHost;

/**
 *  设备cuid
 *
 *  @return cuid
 */
-(NSString *)cuid;

-(void)resetToken;

-(void)setRequestSerializer:(BOOL)isJson resetAuthorization:(BOOL)resetAuth;

@end
