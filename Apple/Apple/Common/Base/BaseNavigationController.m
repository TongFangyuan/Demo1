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
+ (void)initialize
{
    // 方式二：当导航控制包含当前类时才需要设置,只会设置一次，因为是通过appearance皮肤全局配置
    if(@available(iOS 11.0, *)){
        [[UITableView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    //设置状态栏类型
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //// 设置导航栏背景色
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    if(@available(iOS 11.0, *)){
        navBar.prefersLargeTitles = NO;
        [navBar setLargeTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25],NSForegroundColorAttributeName:kBlackColor}];
        //[navBar setBackgroundColor:CCwhiteColor];
    }
    [navBar setHidden:NO];
    [navBar setBarTintColor:kWhiteColor];
    [navBar setTintColor:kWhiteColor];
    [navBar setTranslucent:NO];
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //[navBar setShadowImage:[UIImage new]];
    
    // 设置导航标题字体
    [navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium],NSForegroundColorAttributeName:kBlackColor}];
    // 设置导航菜单项
    UIBarButtonItem *barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor} forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kLightBlackColor} forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 方式一：直接设置当前导航的背景图，但每一个实例都要设置一次
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:R_Image_NavBkg] forBarMetrics:UIBarMetricsDefault];
    //[self setStatusBarBackgroundColor:CCwhiteColor];
    
    // 修复左滑失效问题
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
// 统一设置导航子界面的返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 如果不是top控制器
    if (self.childViewControllers.count) {
        UIButton *leftBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBackButton setImage:[UIImage imageNamed:@"nav_back_blue"] forState:UIControlStateNormal];
        
        CGRect frame = leftBackButton.frame;
        frame.size = CGSizeMake(70, 45);
        [leftBackButton setFrame:frame];
        
        // 使内容靠左排
        leftBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        // 继续向左移
        leftBackButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackButton];
        viewController.navigationItem.leftBarButtonItem = leftBackItem;
        // 添加点击事件
        if ([viewController respondsToSelector:@selector(popEvent:)]) {
            [leftBackButton addTarget:viewController action:@selector(popEvent:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [leftBackButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];            
        }
        // 自动隐藏TabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 调用父类push实现方法,可以在对应ViewController再次覆盖leftBarButtonItem默认返回样式
    [super pushViewController:viewController animated:animated];
}
//如果是top控制器不允许左滑
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    if (navigationController.childViewControllers.count==1) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)backAction
{
    [self.view endEditing:YES];//解决编辑状态黑影问题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self popViewControllerAnimated:YES];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
