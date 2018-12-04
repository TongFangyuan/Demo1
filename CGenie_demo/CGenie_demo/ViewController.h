//
//  ViewController.h
//  CGenie_demo
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
extern ViewController* mainVC;

@interface ViewController : UIViewController

- (void) setInputText:(NSString*)txt;
- (void) setOutputText:(NSString*)txt;
- (void) setRecordVolume:(int)v;
- (void) vadToStopRecord;
- (void) askToStartRecord;

@end
