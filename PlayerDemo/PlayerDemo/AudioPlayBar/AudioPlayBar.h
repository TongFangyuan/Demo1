//
//  AudioPlayBar.h
//  PlayerDemo
//
//  Created by admin on 2018/11/28.
//  Copyright © 2018年 Tongfy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTAudioPlayer.h"

@interface AudioPlayBar : UIView

+ (instancetype)sharePlayBar;

- (void)updateProgress:(double)value;
- (void)updatePlayStatus:(BOOL)isPlay;
- (void)updateMusicInfo:(id<TTMusicModelProtocol>) model;

@end
