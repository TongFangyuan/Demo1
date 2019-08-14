//
//  TTNotificationCenter.h
//  UserNotificaion
//
//  Created by Tong on 2019/7/22.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * TTNotificationName;
extern TTNotificationName const TTNotificationNameReceiveData;

/**
 本地通知工具类
 
 @Note 只支持iOS10以上
 */
NS_AVAILABLE_IOS(10_0)
@interface TTNotificationCenter : NSObject

+ (nonnull instancetype)shareCenter NS_AVAILABLE_IOS(10_0);

/**
 请求通知权限，包含提醒、声音和图标标记。
 */
- (void)requestAuth:(void(^)(BOOL granted))block NS_AVAILABLE_IOS(10_0);


/**
 添加本地通知

 @param title    标题
 @param subtitle 副标题
 @param body     内容
 @param timeInterval 通知的时间，单位秒。
 @param repeats 重复。如果repeats为YES，则timeInterval最少60秒。
 */
- (void)addNotificationWithTitle:(NSString *)title
                        subtitle:(NSString *)subtitle
                            body:(NSString *)body
                    timeInterval:(NSTimeInterval)timeInterval
                         repeats:(BOOL) repeats NS_AVAILABLE_IOS(10_0);

@end

NS_ASSUME_NONNULL_END
