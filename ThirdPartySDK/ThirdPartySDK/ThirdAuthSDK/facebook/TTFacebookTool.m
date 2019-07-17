//
//  TTFacebookTool.m
//  ThirdPartySDK
//
//  Created by Tong on 2019/7/16.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import "TTFacebookTool.h"

@interface TTFacebookTool ()
{
    FBSDKLoginManager *_loginManager;
}

@end

@implementation TTFacebookTool

+ (nonnull instancetype)shareTool {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self=[super init]) {
        _loginManager = [[FBSDKLoginManager alloc] init];
    }
    return self;
}

- (BOOL)isCurrentAccessTokenActive {
    return FBSDKAccessToken.isCurrentAccessTokenActive;
}

- (void)loginFromViewController:(nullable UIViewController *)fromViewController
                            handler:(nullable TTFacebookToolLoginResultBlock)handler {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
    });
    __weak typeof(self) weakSelf = self;
    [_loginManager logInWithPermissions:@[@"public_profile",@"email"] fromViewController:fromViewController handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
                if (handler) handler(nil, error);
            });
            
        } else if (result.isCancelled) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
                NSError *error = [NSError errorWithDomain:@"com.facebook.login" code:TTFacebookToolErrorCodeUserCancel userInfo:@{@"smg":@"user cancelled"}];
                if (handler) handler(nil, error);
            });
        } else if (result) {
            [weakSelf getUserInfoWithHandler:handler];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
                NSError *err = [NSError errorWithDomain:@"com.facebook.login" code:TTFacebookToolErrorCodeUnknown userInfo:error.userInfo];
                if (handler) handler(nil, err);
            });
        }
    }];
}

- (void)logOutWithHandler:(nullable TTFacebookToolLogoutResultBlock)handler {
    [_loginManager logOut];
    if (handler) {
        handler(YES);
    }
}

- (void)getUserInfoWithHandler:(nullable TTFacebookToolLoginResultBlock)handler {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
    });
    
    NSDictionary*params= @{@"fields":@"id,name,email,age_range,first_name,last_name,link,gender,locale,picture,timezone,updated_time,verified"};
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:params
                                  HTTPMethod:FBSDKHTTPMethodGET];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
            
            if (error) {
                if (handler) handler(nil, error);
            } else if (result) {
                NSLog(@"%@",result);
                if (handler) handler(result, error);
            } else {
                NSError *error = [NSError errorWithDomain:@"com.facebook.login" code:TTFacebookToolErrorCodeUnknown userInfo:nil];
                if (handler) handler(nil, error);
            }
        });
    }];
}

#pragma mark - 需要在AppDelegate中调用的方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions
{
   return [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
