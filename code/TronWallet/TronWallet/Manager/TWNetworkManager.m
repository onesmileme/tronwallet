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
//#import "FAConfigManager.h"
#import "UIDevice+Hardware.h"
#import "Reachability.h"
//#import "TKAccountManager.h"
#import "TKNetworkManager.h"
//#import "CHKeychain.h"
//#import "EAPushManager.h"

NSString * const KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
NSString * const KEY_PASSWORD = @"com.company.app.password";

@interface TWNetworkManager()<TKRequestHandlerDelegate>

@property(nonatomic , strong) NSMutableDictionary *extraInfo;
@property(nonatomic , strong) NSString *cuid;

@end

@implementation TWNetworkManager

IMP_SINGLETON

-(instancetype)init
{
    self = [super init];
    if (self) {
        _extraInfo = [[NSMutableDictionary alloc]init];
        
//        [[TKNetworkManager sharedInstance] setRequestSerializer:[AFJSONRequestSerializer serializer]];        
        //TODO 获取网络状态
        _extraInfo[@"net"] = @"1";
        __weak typeof(self) wself = self;
        TKRequestHandler *handler = [TKRequestHandler sharedInstance];
        handler.delegate = self;
        handler.baseParam = @{};//[self baseParam];
        handler.extraInfoBlock = ^(){
            return [wself extraParam];
        };

        [self setRequestSerializer:true resetAuthorization:false];
        
        handler.codeSignBlock = ^(NSDictionary *dic){
            //no code sign
            return @"";
        };
        
        NSString *notificatioName = kTKNetworkChangeNotification;
        [NotificationCenter addObserver:self selector:@selector(networkChangeNotification:) name:notificatioName object:nil];
        [NotificationCenter addObserver:self selector:@selector(loginDoneNotification:) name:kLoginDoneNotification object:nil];
        [NotificationCenter addObserver:self selector:@selector(logoutNotification:) name:kLogoutNotification object:nil];
        
    }
    return self;
}


+(NSString *)appHost
{
#if kOnLine
    return @"http://eisapp.cn";
#else
    return @"http://218.247.171.92:8090";
//    return [[FAConfigManager sharedInstance]host];
#endif
}

+(NSString *)loginAppHost
{
#if kOnLine
    return @"http://eisapp.cn";
#else
    return @"http://218.247.171.92:8090";
#endif
//  return @"http://218.247.171.92:9002";
}

-(void)setRequestSerializer:(BOOL)isJson resetAuthorization:(BOOL)resetAuth
{
    AFHTTPRequestSerializer *serializer =  isJson ? [AFJSONRequestSerializer serializer]:[AFHTTPRequestSerializer serializer];
    [[TKNetworkManager sharedInstance] setRequestSerializer: serializer];
    if (resetAuth) {
        [serializer setAuthorizationHeaderFieldWithUsername:@"ecclient" password:@"ecclientsecret"];
    }else{
        [self updateAuthorization];
    }
}

-(void)updateAuthorization
{
    if ([[TKAccountManager sharedInstance] isLogin]) {
        
        TKUserInfo *userinfo = [TKAccountManager sharedInstance].userInfo;
        
        NSLog(@"authorization is: %@",[NSString stringWithFormat:@"%@ %@",[userinfo.tokenType capitalizedString],userinfo.accessToken]);
        
        [[TKNetworkManager sharedInstance] setValue:[NSString stringWithFormat:@"%@ %@",[userinfo.tokenType capitalizedString],userinfo.accessToken] forHTTPHeaderField:@"Authorization"];
    }else{
        [[TKNetworkManager sharedInstance] setAuthorizationHeaderFieldWithUsername:@"ecclient" password:@"ecclientsecret"];
    }
}

-(NSDictionary *)baseParam
{
    NSString *mb = [[UIDevice currentDevice]hwMachineName];
    NSString *osv = [[UIDevice currentDevice]systemVersion];
    NSString *appVersion = [TKAppInfo appVersion];
//    NSString *appKey = [[FAConfigManager sharedInstance]appKey];

    return @{@"mb" : mb, @"ov":osv, @"os":@"ios" ,
            @"sv":appVersion ,
             };    
}

-(NSDictionary *)extraParam
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
//    [param addEntriesFromDictionary:_extraInfo];
//    TKUserInfo *userinfo = [[TKAccountManager sharedInstance]userInfo];
//    NSString *uid = userinfo.uid;
//    if (uid && ![uid isKindOfClass:[NSString class]]) {
//        uid = [NSString stringWithFormat:@"%@",uid];
//    }
//    if (uid.length > 0) {
//        param[@"uid"] = uid;
//    }
//    NSString *token = userinfo.accessToken;
//    if (token.length > 0) {
//        param[@"token"] = token;
//    }
    return param;
}

-(void)resetToken
{
    AFHTTPRequestSerializer *serializer =  [AFHTTPRequestSerializer serializer];
    [[TKNetworkManager sharedInstance] setRequestSerializer: serializer];
    [serializer setAuthorizationHeaderFieldWithUsername:@"ecclient" password:@"ecclientsecret"];
}

#pragma mark - login
-(void)loginDoneNotification:(NSNotification *)notification
{
    TKUserInfo *userinfo = [[TKAccountManager sharedInstance]userInfo];
    TKRequestHandler *handler = [TKRequestHandler sharedInstance];
    [handler setValue:[NSString stringWithFormat:@"%@ %@",userinfo.tokenType,userinfo.accessToken] forHTTPHeaderField:@"Authorization"];
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
                [[EAPushManager sharedInstance]handleOpenUrl:@"eis://show_login"];
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
            [self resetToken];
            [[EAPushManager sharedInstance]handleOpenUrl:@"eis://show_login"];
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
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD];
    NSString *uuidString = [usernamepasswordKVPairs objectForKey:KEY_PASSWORD];
    
    if (!uuidString || uuidString.length == 0)
    {
        uuidString = [self creatUuid];
        NSMutableDictionary *uuidMutableDic = [[NSMutableDictionary alloc] initWithCapacity:3];
        [uuidMutableDic setObject:uuidString forKey:KEY_PASSWORD];
        [CHKeychain save:KEY_USERNAME_PASSWORD data:uuidMutableDic];
    }
    
    self.cuid = uuidString;
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
