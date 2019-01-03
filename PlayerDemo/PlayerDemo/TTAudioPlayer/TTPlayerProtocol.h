//
//  TTPlayerProtocol.h
//  PlayerDemo
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018年 Tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMusicModelProtocol.h"

@protocol TTPlayerProtocol <NSObject>

////// 播放歌曲
- (void) playMusicWithInfo:(id<TTMusicModelProtocol>)model;

#pragma mark - 播放队列控制
//// 将歌曲添加播放列表列尾
- (void) enterPlayQueueWithSingle:(id<TTMusicModelProtocol>)model;
//// 将数组歌曲添加播放列表列尾
- (void) enterPlayQueueWithArray:(NSArray<id<TTMusicModelProtocol>> *)models;

///// 清空播放列表，并将当前歌曲加入播放列表
- (void) replaceAllQueueWithSingle:(id<TTMusicModelProtocol>)model;
///// 清空播放列表，并将当前歌曲数组加入播放列表
- (void) replaceAllQueueWithArray:(NSArray<id<TTMusicModelProtocol>> *)models;


#pragma mark - 播放控制
- (void) next;
- (void) pre;
- (void) pause;
- (void) stop;
- (void) play;
- (void) continuePlay;

#pragma mark - 播放信息
- (double) currentSecs;
- (double) durationSecs;
- (BOOL) isPlaying;
- (BOOL) isNextExist;
- (BOOL) isPreExist;

@end
