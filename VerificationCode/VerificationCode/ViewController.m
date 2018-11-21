//
//  ViewController.m
//  VerificationCode
//
//  Created by admin on 2018/11/21.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "ViewController.h"
#import "VerifyCodeView.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:33/255.0 green:220/255.0 blue:249/255.0 alpha:1];
    
    VerifyCodeView *view = [VerifyCodeView new];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(self.view);
        make.height.mas_equalTo(kItemHeight);
    }];
    view.backgroundColor = [UIColor redColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
