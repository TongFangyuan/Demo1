//
//  TTAudioControl.h
//  PlayerDemo
//
//  Created by admin on 2018/12/27.
//  Copyright © 2018年 Tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTAudioControl <NSObject>

- (void) next;
- (void) pre;
- (void) pause;
- (void) stop;
- (void) play;

@end
