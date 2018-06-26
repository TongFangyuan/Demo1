//
//  UIView+LightMode.h
//  demo1
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 tongfangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const NightModeChangeNotificationKey;

@protocol NightModeProtocal <NSObject>

- (void)nm_updateUIWithNightMode:(BOOL)isOn;

@end

@interface UIView (NightMode)

@end
