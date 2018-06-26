//
//  UIView+NightMode.m
//  demo1
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 tongfangyuan. All rights reserved.
//

#import "UIView+NightMode.h"
#import <objc/runtime.h>

NSString *const NightModeChangeNotificationKey =  @"NightModeChangeNotification";

@implementation UIView (NightMode)

+ (void)load {
    [super load];
    [self exchangeMethods];
}

#pragma mark - ExchangeMethod
+ (void)exchangeMethods {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeInitWithCoderMethod];
        [self exchangeInitWithFrameMethod];
    });
}

+ (void)exchangeInitWithCoderMethod {
    Class class = [self class];
    
    SEL originalSelector = @selector(initWithCoder:);
    SEL swizzledSelector = @selector(nm_initWithCoder:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)exchangeInitWithFrameMethod {
    Class class = [self class];
    
    SEL originalSelector = @selector(initWithFrame:);
    SEL swizzledSelector = @selector(nm_initWithFrame:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (instancetype)nm_initWithCoder:(NSCoder *)coder{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NightModeChangeNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nm_updateNightModeStatusNotification:) name:NightModeChangeNotificationKey object:nil];
    
    return [self nm_initWithCoder:coder];
}


- (instancetype)nm_initWithFrame:(CGRect)frame {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NightModeChangeNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nm_updateNightModeStatusNotification:) name:NightModeChangeNotificationKey object:nil];
    
    return [self nm_initWithFrame:frame];
}

#pragma mark - Notification

- (void)nm_updateNightModeStatusNotification:(NSNotification *)noti {
    
    BOOL isON = [noti.object boolValue];
    if ([self respondsToSelector:@selector(nm_updateUIWithNightMode:)]) {
        [self performSelector:@selector(nm_updateUIWithNightMode:) withObject:[NSNumber numberWithBool:isON]];
    } else {
        [self _updateUIWithNightMode:isON];
    }
}

#pragma mark - UpdateUI
- (void)updateSwitch:(BOOL)isNightOn {
    if (![self isKindOfClass:[UISwitch class]]) return;
    UISwitch *sw = (UISwitch *)self;
    UIColor * onTintColor = isNightOn ? [UIColor whiteColor] : [UIColor colorWithRed:0.76 green:0.80 blue:1.00 alpha:1.00];
    [sw setOnTintColor:onTintColor];
}

- (void)updateLabel:(BOOL)isNightOn {
    if (![self isKindOfClass:[UILabel class]]) return;
    UIColor *textColor = isNightOn ? [UIColor whiteColor] : [UIColor blackColor];
    [self performSelector:@selector(setTextColor:) withObject:textColor];
}

- (void)updateSegementControl:(BOOL)isNightOn {
    if (![self isKindOfClass:[UISegmentedControl class]]) return;
    UISegmentedControl *segementControl = (UISegmentedControl *)self;
    if (isNightOn) {
        segementControl.layer.borderColor = [UIColor whiteColor].CGColor;
        segementControl.tintColor = [UIColor whiteColor];
        NSDictionary * dic = @{
                               NSForegroundColorAttributeName:[UIColor blackColor],
                               };
        [segementControl setTitleTextAttributes:dic forState:UIControlStateSelected];
        dic = @{
                NSForegroundColorAttributeName:[UIColor whiteColor],
                };
        [segementControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    } else {
        segementControl.layer.borderColor = [UIColor blackColor].CGColor;
        segementControl.tintColor = [UIColor blackColor];
        NSDictionary * dic = @{
                               NSForegroundColorAttributeName:[UIColor whiteColor],
                               };
        [segementControl setTitleTextAttributes:dic forState:UIControlStateSelected];
        dic = @{
                NSForegroundColorAttributeName:[UIColor blackColor],
                };
        [segementControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    }
}

- (void)updateButton:(BOOL)isNightOn {
    if (![self isKindOfClass:[UIButton class]]) return;
    UIButton *button = (UIButton *)self;
    UIColor *titleColor = isNightOn ? [UIColor greenColor] : [UIColor colorWithRed:0.04 green:0.38 blue:1.00 alpha:1.00];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)updateProgressView:(BOOL)isNightOn {
    if (![self isKindOfClass:[UIProgressView class]]) return;
    UIColor *progressTinitColor = isNightOn ? [UIColor colorWithRed:0.31 green:0.98 blue:0.48 alpha:1.00] : [UIColor colorWithRed:0.04 green:0.40 blue:0.97 alpha:1.00];
    UIColor *trackTintColor = isNightOn ? [UIColor colorWithRed:0.20 green:0.21 blue:0.26 alpha:1.00] : [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00];
    [self performSelector:@selector(setProgressTintColor:) withObject:progressTinitColor];
    [self performSelector:@selector(setTrackTintColor:) withObject:trackTintColor];
}

#pragma mark - Private
- (void)_updateUIWithNightMode:(BOOL)isON {
    
    NSString *className = NSStringFromClass(self.class);
    NSLog(@"%@", className);
    
    if ([self _isSubviewOfClass:[UILabel class]]) {
        [self updateLabel:isON];
    }
    else if ([self _isSubviewOfClass:[UIProgressView class]]) {
        [self updateProgressView:isON];
    }
    else if ([self _isSubviewOfClass:[UISwitch class]]) {
        [self updateSwitch:isON];
    }
    else if ([self _isSubviewOfClass:[UIButton class]]) {
        [self updateButton:isON];
    }
    else if ([self _isSubviewOfClass:[UISegmentedControl class]]) {
        [self updateSegementControl:isON];
    }
    else if([self isMemberOfClass:[UIView class]]) {
        self.backgroundColor = isON ? [UIColor colorWithRed:0.05 green:0.08 blue:0.23 alpha:1.00] : [UIColor whiteColor];
    }
    
}

/** 判断是否是某个视图的内部控件 */
- (BOOL)_isSubviewOfClass:(Class)class {
    if ([self isKindOfClass:class]) return YES;
    
    UIView *superView = self.superview;
    while (superView) {
        if ([superView isKindOfClass:class]) {
            return YES;
        }
        superView = superView.superview;
    }
    return NO;
}


@end
