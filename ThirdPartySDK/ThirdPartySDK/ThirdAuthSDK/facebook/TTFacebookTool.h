//
//  TTFacebookTool.h
//  ThirdPartySDK
//
//  Created by Tong on 2019/7/16.
//  Copyright © 2019 Tongfy. All rights reserved.
//
//  pod 'FBSDKLoginKit'
//
//  facebook SDK 功能集成

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TTFacebookToolErrorCodeUnknown    = 9999, //!< 未知原因
    TTFacebookToolErrorCodeUserCancel ,       //!< 用户取消
} TTFacebookToolErrorCode;

/**
 退出 block

 @param isFinish 完成
 */
typedef void(^TTFacebookToolLogoutResultBlock)(BOOL isFinish);

/**
 登录 block

 @param result 用户信息
 @param error 错误信息
 */
typedef void(^TTFacebookToolLoginResultBlock)(NSDictionary * _Nullable result, NSError * _Nullable error);

@interface TTFacebookTool : NSObject

+ (instancetype)shareTool;

/**
 如果currentAccessToken不为nil并且currentAccessToken未过期，则返回YES
 
 YES: 有效期内，可调用`getUserInfoWithHandler:`方法获取用户信息。
 
 NO: 过了有效期，需要重新获取授权。
 */
@property (nonatomic, assign, readonly, getter=isCurrentAccessTokenActive) BOOL currentAccessTokenIsActive;

#pragma mark 用户模块
/**
 facebook登录，获取用户信息，包含email，个人信息等

 @param fromViewController 来源控制器
 @param handler 回调
 */
- (void)loginFromViewController:(nullable UIViewController *)fromViewController
                        handler:(nullable TTFacebookToolLoginResultBlock)handler;

/**
 退出facebook登录
 */
- (void)logOutWithHandler:(nullable TTFacebookToolLogoutResultBlock)handler;

/**
 获取用户信息

 @param handler 回调
 */
- (void)getUserInfoWithHandler:(nullable TTFacebookToolLoginResultBlock)handler;

#pragma mark - 需要在AppDelegate中调用的方法
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;


@end

NS_ASSUME_NONNULL_END
