//
//  ViewController.m
//  Apple
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "SettingViewController.h"
#import "UIImage+Convert.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Application *app = [Application theApp];
    
    [self.view setBackgroundColor:kWhiteColor];
    UIImage *whiteImage = [UIImage createImageWithColor:kWhiteColor];
    [self.tabBar setBackgroundImage:whiteImage];
    
    UIImage *tabBarItemImage = nil;
    UIImage *tabBarItemSeletedImage = nil;
    UITabBarItem *tabBarItem = nil;
    
    /////////音乐
    MainViewController *mainCtl = [[MainViewController alloc] initWithTabTitle:@"首页" TabbarHidden:NO];
    tabBarItemImage = [app getImageWithImageName:@"shangcheng.png"];
    tabBarItemSeletedImage = [app getImageWithImageName:@"shangcheng_active.png"];
    tabBarItemImage = [tabBarItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItemSeletedImage = [tabBarItemSeletedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:tabBarItemImage selectedImage:tabBarItemSeletedImage];
    [self resetTabbarItemTextColor:tabBarItem];
    mainCtl.tabBarItem = tabBarItem;
    BaseNavigationController *navMain = [[BaseNavigationController alloc] initWithRootViewController:mainCtl];
    
    /////////设置
    SettingViewController *lightCtl = [[SettingViewController alloc] initWithTabTitle:@"设置" TabbarHidden:NO];
    tabBarItemImage = [app getImageWithImageName:@"shangcheng.png"];
    tabBarItemSeletedImage = [app getImageWithImageName:@"shangcheng_active.png"];
    tabBarItemImage = [tabBarItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItemSeletedImage = [tabBarItemSeletedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:tabBarItemImage selectedImage:tabBarItemSeletedImage];
    [self resetTabbarItemTextColor:tabBarItem];
    lightCtl.tabBarItem = tabBarItem;
    BaseNavigationController *navLight = [[BaseNavigationController alloc] initWithRootViewController:lightCtl];
    
    self.viewControllers = @[navMain,navLight];
}

- (void) resetTabbarItemTextColor:(UITabBarItem *) tabBarItem{
    
    UIFont *normalFont = [UIFont boldSystemFontOfSize:11.0];
    UIColor *normalColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0f];
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        normalFont, NSFontAttributeName,
                                        normalColor, NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        normalFont, NSFontAttributeName,
                                        kMainColor, NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
