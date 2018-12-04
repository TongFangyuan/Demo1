//
//  TTAudioPlayerStatusDelegate.h
//  PlayerDemo
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018年 Tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTAudioPlayerStatusDelegate <NSObject>

@optional
- (void)ttAudioPlayerPlayStart;
- (void)ttAudioPlayerPlayFinished;
- (void)ttAudioPlayerPause;
- (void)ttAudioPlayerStoped;
- (void)ttAudioPlayerPlayError:(NSError *)error;
- (void)ttAudioPlayerSeekPosition:(double)progress;
- (void)ttAudioPlayerUpdateProgress:(double)progress;
- (void)ttAduioPlayerMusicInfoUpdate:(id<TTMusicModelProtocol>)musicInfo;

@end
