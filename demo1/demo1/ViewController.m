//
//  ViewController.m
//  demo1
//
//  Created by admin on 2018/6/1.
//  Copyright © 2018年 tongfangyuan. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "UIView+NightMode.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    Class * classes = NULL;
//    int numClasses = objc_getClassList(NULL, 0);
//
//    if (numClasses > 0 )
//    {
//        classes = (Class *) malloc(sizeof(Class) * numClasses);
//        numClasses = objc_getClassList(classes, numClasses);
//
//        for (int i = 0; i < numClasses; ++i){
//            if (class_getSuperclass(classes[i]) == [UICollectionReusableView class]){
//                NSLog(@"%@", NSStringFromClass(classes[i]));
//            }
//        }
//
//        free(classes);
//    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 29, 20)];
    [self.view addSubview:label];
    label.text = @"Label_code_create";
    [label sizeToFit];
    label.center = self.view.center;
    
}

- (IBAction)lightSwitchAction:(UISwitch *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NightModeChangeNotificationKey object:[NSNumber numberWithInteger:sender.isOn]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
