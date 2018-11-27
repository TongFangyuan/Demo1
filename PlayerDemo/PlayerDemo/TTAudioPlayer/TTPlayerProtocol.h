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

- (void) playMusicWithInfo:(id<TTMusicModelProtocol>)model;

- (void) enterPlayQueueWithSingle:(id<TTMusicModelProtocol>)model;
- (void) enterPlayQueueWithArray:(NSArray<id<TTMusicModelProtocol>> *)models;

- (void) replaceAllQueueWithSingle:(id<TTMusicModelProtocol>)model;
- (void) replaceAllQueueWithArray:(NSArray<id<TTMusicModelProtocol>> *)models;

- (BOOL) isPlaying;

- (BOOL) isNextExist;

- (BOOL) isPreExist;

- (void) next;

- (void) pre;

- (void) pause;

- (void) stop;

- (void) play;

- (void) continuePlay;

- (double) currentSecs;

- (double) durationSecs;

@end
