//
//  ViewController.m
//  TabaoAuthDemo
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import "ViewController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)taobaoLogin:(id)sender {
    
    if(![[ALBBSession sharedInstance] isLogin]){
//        [[ALBBSDK sharedInstance] auth:self successCallback:_loginSuccessCallback failureCallback:_loginFailedCallback];
        [[ALBBSDK sharedInstance] auth:self successCallback:^(ALBBSession *session) {
            NSLog(@"登录成功：%@",[session getUser]);
        } failureCallback:^(ALBBSession *session, NSError *error) {
            NSLog(@"登录失败");
        }];
    }else{
        ALBBSession *session=[ALBBSession sharedInstance];
        NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[[session getUser] ALBBUserDescription]];
        NSLog(@"%@", tip);
    }
}

@end
