//
//  BaseViewController.h
//  Apple
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import <UIKit/UIKit.h>

enum BaseViewCtlElements {
    kBackButtonTag = 9999,
};

@class Application;

@interface BaseViewController : UIViewController
{
    float viewWidth, viewHeight;
    float navHeight, tabBarHeight, statusBarHeight;
    
    NSString *mTitle;
    Application *app;
    BOOL tabbarHidden;
    
    UILabel *tipLabel;
    UILabel *detailLabel;
}

- (id) initWithTabTitle:(NSString *)title TabbarHidden:(BOOL)hidden;
- (void) refreshTitle;

/*
 分割线
 */
- (UIImageView *) findHairlineImageViewUnder:(UIView *)view;

/*
 data为一个数组，数组类型为NSDictionnary，两个属性：image－tag
 */
- (void) setNavigationBarLeftView:(UIView *)leftView;
- (void) setNavigationBarRightView:(UIView *)rightView;
- (void) setNavigationBarBackView:(UIView *)backView;
- (void) setNavigationBarCenterView:(UIView *)centerView;

/*
 根视图按钮事件
 */
- (void) baseButtonEvent:(id)sender;

#pragma mark - 空界面提示
- (void)showEmptyTitle:(NSString *)title detail:(NSString *)detail;
- (void)removeEmptyTip;

@end
