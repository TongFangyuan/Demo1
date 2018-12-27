//
//  TTPlayer.h
//  PlayerDemo
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018年 Tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPlayerProtocol.h"
#import "TTAudioPlayerStatusDelegate.h"
#import "TTMusicModel.h"

@interface TTAudioPlayer : NSObject<TTPlayerProtocol>

////// 单例
+ (instancetype)shareInstance;

/**
 播放队列
 */
@property (nonatomic, strong, readonly) NSMutableArray<id<TTMusicModelProtocol>>  *playQueue;

/**
 状态监听者添加
 */
- (void)addStatusDelagate:(id<TTAudioPlayerStatusDelegate>)delegate;
/**
 移除状态监听者
 */
- (void)removeStatusDelegate:(id<TTAudioPlayerStatusDelegate>)delegate;

@end
