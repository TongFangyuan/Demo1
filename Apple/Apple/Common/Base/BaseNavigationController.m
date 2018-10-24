//
//  BaseNavigationController.m
//  Apple
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ( gestureRecognizer == self.interactivePopGestureRecognizer ) {
        if ( self.visibleViewController == [self.viewControllers objectAtIndex:0] ) { //让第一个子控制器侧滑时不产生作用
            return NO;
        }
    }
    return YES;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"viewController %@",viewController);
    if (navigationController.viewControllers.count > 1 && ![self isAlertViewController]) {
        // 不是rootViewController级的时候隐藏topTabBar
        self.tabBarController.tabBar.hidden = YES;
    }
    
    if (navigationController.viewControllers.count < 2) {
        // 回到rootViewController级时显示topTabBar
        self.tabBarController.tabBar.hidden = NO;
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count < 2) {
        // 回到rootViewController级时显示topTabBar
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (BOOL)isAlertViewController {
    
    return [self.topViewController isKindOfClass:NSClassFromString(@"LocalMusicListViewController")] || [self.topViewController isKindOfClass:NSClassFromString(@"ZaixianCommonViewController")] || [self.topViewController isKindOfClass:NSClassFromString(@"SecondLocalMusicTableVC")];
}

@end
