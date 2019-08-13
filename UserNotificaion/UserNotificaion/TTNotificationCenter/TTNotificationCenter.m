//
//  TTNotificationCenter.m
//  UserNotificaion
//
//  Created by Tong on 2019/7/22.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import "TTNotificationCenter.h"
#import <UserNotifications/UserNotifications.h>

TTNotificationName const TTNotificationNameReceiveData = @"TTNotificationNamePresentedData";

@interface TTNotificationCenter ()
<
UNUserNotificationCenterDelegate
>
{
    UNUserNotificationCenter *_center;
}

@end

@implementation TTNotificationCenter

+ (nonnull instancetype)shareCenter {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self=[super init]) {
        _center = [UNUserNotificationCenter currentNotificationCenter];
        _center.delegate = self;
    }
    return self;
}

- (void)requestAuth:(void(^)(BOOL granted))block {
    [_center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionSound+UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) block(granted);
        });
    }];
}

- (void)addNotificationWithTitle:(NSString *)title
                        subtitle:(NSString *)subtitle
                            body:(NSString *)body
                    timeInterval:(NSTimeInterval)timeInterval
                         repeats:(BOOL) repeats {

    /// Configure the notification's payload.
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = title;
    content.subtitle = subtitle;
    content.body  = body;
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @(0);
    
    /// Deliver the notification in five seconds.
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:timeInterval repeats:repeats];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:title content:content trigger:trigger];
    
    // Schedule the notification.
    [_center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"添加本地通知成功");
        } else {
            NSLog(@"添加通知失败：%@", error);
        }
    }];
    
}

- (void)getPendingAllNotifications {
    [_center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        if (requests.count) {
            NSLog(@"通知队列：%@",requests);
        } else {
            NSLog(@"当前没有待推送本地通知");
        }
    }];
}

- (void)removeNotificationWithIdentifier:(NSString *)identifier {
    [_center removeDeliveredNotificationsWithIdentifiers:@[identifier]];
    [_center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
}

#pragma mark - UNUserNotificationCenterDelegate
/// 仅当应用程序位于前台时，才会调用该方法。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"%@",notification);
        [[NSNotificationCenter defaultCenter] postNotificationName:TTNotificationNameReceiveData object:notification];
//    UNNotificationRequest *request = notification.request;
//    UNNotificationContent *content = request.content;
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:content.title message:content.body preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:TTNotificationNameReceiveData object:notification];
//        [self removeNotificationWithIdentifier:request.identifier];
//    }];
//
//    [alert addAction:action1];
//    [alert addAction:action2];
//    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

/// 当用户通过打开应用程序，解除通知或选择UNNotificationAction来响应通知时，将在代理上调用该方法。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler  {
    NSLog(@"%@",response);
    completionHandler();
    [[NSNotificationCenter defaultCenter] postNotificationName:TTNotificationNameReceiveData object:response.notification];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification {
    NSLog(@"%@",notification);
}

@end
