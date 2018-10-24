//
//  BaseViewController.m
//  Apple
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018年 tongfy. All rights reserved.
//
#import "BaseViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (id) initWithTabTitle:(NSString *)title TabbarHidden:(BOOL)hidden;
{
    self = [super init];
    if (self) {
        
        tabbarHidden = hidden;
        if ([title isKindOfClass:[NSNull class]]) {
            self.title = @"";
        } else {
            self.title = title;
        }
        app = [Application theApp];
        mTitle = [title copy];
        
        if (hidden == YES) {
            self.hidesBottomBarWhenPushed = YES;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kBgColor;
    
    /*  解决NavigationBar与UIViewController重叠的问题 */
    if(IOS7) {
        self.edgesForExtendedLayout= UIRectEdgeBottom;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationController.navigationBar.translucent = YES;
    
    //字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18]
                                                                      }];
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    //背景色
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithUIColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1] height:kTopHeight] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self imageWithUIColor:kSepratorColor height:0.5f]];
    
    
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.frame = CGRectMake(0, -kTopHeight, kScreenWidth, kScreenHeight);
    bgImageView.tag = 100;
    bgImageView.image = [UIImage imageNamed:@"1.bg"];
    [self.view addSubview:bgImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self customNavigation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 自定义导航左右按钮
- (void)customNavigation {
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(0, 0, 38, 38)];
    [settingButton addTarget:self action:@selector(clickback) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [settingButton setImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.leftBarButtonItems = @[searchBtn];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems = nil;
    
    
}

- (void)clickback {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)imageWithUIColor:(UIColor *)color height:(CGFloat)height{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, height); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mask隐藏tabbar

- (void)hideTabbar:(BOOL)hidden {
    
    self.hidesBottomBarWhenPushed = hidden;
    
    CGRect windowFrame = CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight);
    if(hidden) {
        CGRect newFrame = windowFrame;
        newFrame.size.height -= navHeight + statusBarHeight;
        self.view.frame = newFrame;
    }
    else {
        CGRect newFrame = windowFrame;
        newFrame.size.height -= tabBarHeight + navHeight + statusBarHeight;
        self.view.frame = newFrame;
    }
    viewWidth = self.view.frame.size.width;
    viewHeight = self.view.frame.size.height;
    
    CGRect newFrame = self.view.frame;
    newFrame.size.height = viewHeight;
    newFrame.size.width = viewWidth;
    self.view.frame = newFrame;
}

#pragma mark
- (void) refreshTitle {
    self.title = mTitle;
}

#pragma mask 设置NavBarItem

- (void) setNavigationBarLeftView:(UIView *)leftView {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = item;
}

- (void) setNavigationBarRightView:(UIView *)rightView {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = item;
}

- (void) setNavigationBarBackView:(UIView *)backView {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.backBarButtonItem = item;
}

- (void) setNavigationBarCenterView:(UIView *)centerView {
    
    self.navigationItem.titleView = centerView;
}

#pragma mark 分割线
- (UIImageView *) findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


#pragma mark 根视图按钮事件
- (void) baseButtonEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 空界面提示
- (void)showEmptyTitle:(NSString *)title detail:(NSString *)detail {
    if (title == nil && detail== nil) return;
    CGFloat viewCenterY = viewHeight / 2;
    if (title == nil || detail == nil) {
        CGRect rect = title ? [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil] : [detail boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        tipLabel = [[UILabel alloc] initWithFrame:rect];
        tipLabel.text = title ? title : detail;
        tipLabel.textColor = UIColor.lightGrayColor;
        tipLabel.center = CGPointMake(self.view.center.x, viewCenterY);
        [self.view addSubview:tipLabel];
    } else {
        CGRect titleRect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        CGRect detailRect = [detail boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        
        tipLabel = [[UILabel alloc] initWithFrame:titleRect];
        tipLabel.textColor = UIColor.lightGrayColor;
        tipLabel.text = title;
        tipLabel.center = CGPointMake(self.view.center.x, viewCenterY - titleRect.size.height/2 - 3);
        
        detailLabel = [[UILabel alloc] initWithFrame:detailRect];
        detailLabel.textColor = UIColor.lightGrayColor;
        detailLabel.text = detail;
        detailLabel.center = CGPointMake(self.view.center.x, viewCenterY + detailRect.size.height/2 + 3);
        
        [self.view addSubview:tipLabel];
        [self.view addSubview:detailLabel];
        
        
        
    }
}
- (void)removeEmptyTip {
    [tipLabel removeFromSuperview];
    tipLabel = nil;
    
    [detailLabel removeFromSuperview];
    detailLabel = nil;
}


@end
