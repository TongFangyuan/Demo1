//
//  ViewController.m
//  ThirdPartySDK
//
//  Created by Tong on 2019/7/10.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import "ViewController.h"
#import "DetailsViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *faccbookBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateContent];
}

#pragma mark - facebook
- (IBAction)clickFacebookBtn:(id)sender {
    
    if (TTFacebookTool.shareTool.isCurrentAccessTokenActive) {
        WS(ws)
        [UIAlertController tt_showAlertWithTitle:@"提示" message:@"是否退出facebook" confirmHandler:^{
            [ws facebookLogOut];
        } cancelHandler:^{
            
        }];
    } else {
        [self facebookLogin];
    }
    
}

- (void)facebookLogin {
    WS(ws)
    [TTFacebookTool.shareTool loginFromViewController:self handler:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            [TTToastTool debug_show:error.localizedDescription];
        } else if (result) {
            [TTToastTool show:result.tt_toString];
            [ws _toDetailsView:result];
            [ws updateContent];
            NSLog(@"%@",result);
        }
    }];
}

- (void)facebookLogOut {
    WS(ws)
    [TTFacebookTool.shareTool logOutWithHandler:^(BOOL isFinish) {
        [ws updateContent];
    }];
}

- (void)_toDetailsView:(NSDictionary *)info {
    DetailsViewController *vc = [UIStoryboard tt_loadViewControllerWithsbName:@"Main" identifier:@"DetailsViewController"];
    vc.info = info;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateContent {
    if (TTFacebookTool.shareTool.isCurrentAccessTokenActive) {
        [self.faccbookBtn setTitle:@"facebook logOut" forState:UIControlStateNormal];
    } else {
        [self.faccbookBtn setTitle:@"facebook login" forState:UIControlStateNormal];
    }
}

@end
