//
//  ViewController.m
//  ThirdFontDemo
//
//  Created by admin on 2018/11/21.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "ViewController.h"
#import "TFFontManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.label1.font = [UIFont chantalFontOfSize:16];
    self.label2.font = [UIFont filsonSoftLightFontOfSize:16];
    self.label3.font = [UIFont filsonSoftBookFontOfSize:16.f];
    self.label4.font = [UIFont sfProTextRegularFontOfSize:16.f];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [TFFontManager printAllFonts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
