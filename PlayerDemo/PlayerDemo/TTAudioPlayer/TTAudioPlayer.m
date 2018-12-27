//
//  TTPlayer.m
//  PlayerDemo
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018年 Tongfy. All rights reserved.
//

#import "TTAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface TTAudioPlayer()
{
    NSInteger       currentIndex; //!< 歌曲索引
    id              timeObserver; //!< 进度观察
    NSTimeInterval  bufferTime;   //!< 缓冲时长    秒
    NSTimeInterval  currentTime;  //!< 当前播放进度 秒
}

@property (nonatomic, strong) AVPlayer                                  *player;
@property (nonatomic, strong) AVPlayerItem                              *playerItem;
@property (nonatomic, strong, readwrite) NSMutableArray<id<TTMusicModelProtocol>>  *playQueue;
@property (nonatomic, strong) NSMutableArray<id<TTAudioPlayerStatusDelegate>> *statusDelegates;

@end


static void* playerItemContext = &playerItemContext;

@implementation TTAudioPlayer

+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _playQueue = [NSMutableArray array];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreptionNotification:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
        
        _statusDelegates = [NSMutableArray array];
        
    }
    return self;
}

#pragma mark -      ------------------播放协议--------------------

#pragma mark 播放音频
- (void)playMusicWithInfo:(id<TTMusicModelProtocol>)model {
    
    [self removeTimeObserver];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:model.url]];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    self.player = player;
    self.playerItem = playerItem;
    
    currentTime = 0;
    bufferTime  = 0;
    
    [self play];
    NSLog(@"播放第%ld首歌曲：%@-%@",currentIndex,model.author,model.name);
    
    [self.statusDelegates makeObjectsPerformSelector:@selector(ttAduioPlayerMusicInfoUpdate:) withObject:model];
    
    NSLog(@"添加新的时间监听");
    timeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        [self updateProgress];
    }];
}

#pragma mark 播放队列管理

- (void)enterPlayQueueWithArray:(NSArray<id<TTMusicModelProtocol>> *)models {
    [_playQueue addObjectsFromArray:models];
    NSLog(@"进入播放队列:%@",models);
}


- (void)enterPlayQueueWithSingle:(id<TTMusicModelProtocol>)model {
    [_playQueue addObject:model];
    NSLog(@"进入播放队列:%@",model);
}


- (void)replaceAllQueueWithArray:(NSArray<id<TTMusicModelProtocol>> *)models {
    [self stop];
    [_playQueue addObjectsFromArray:models];
    NSLog(@"更新播放队列:%@",_playQueue);
}

- (void)replaceAllQueueWithSingle:(id<TTMusicModelProtocol>)model {
    [self stop];
    [_playQueue addObject:model];
    NSLog(@"更新播放队列:%@",_playQueue);
}

#pragma mark 播放器控制

- (void)next {
    if ([self isNextExist]) {
        NSLog(@"准备播放下一首");
        id<TTMusicModelProtocol> nextItem = _playQueue[currentIndex+1];
        currentIndex++;
        [self playMusicWithInfo:nextItem];
    } else if(_playQueue.count) {
        currentIndex = 0;
        NSLog(@"播放队首歌曲");
        [self playMusicWithInfo:_playQueue.firstObject];
    }
}

- (void)pre {
    if ([self isPreExist]) {
        NSLog(@"准备播放前一首");
        id<TTMusicModelProtocol> preItem = _playQueue[currentIndex-1];
        currentIndex--;
        [self playMusicWithInfo:preItem];
    } else if(_playQueue.lastObject) {
        currentIndex = [_playQueue indexOfObject:_playQueue.lastObject];
        NSLog(@"播放队尾歌曲");
        [self playMusicWithInfo:_playQueue.lastObject];
    }
}

- (void)pause {
    NSLog(@"暂停");
    [_player pause];
    
    [self.statusDelegates makeObjectsPerformSelector:@selector(ttAudioPlayerPause)];
}

- (void)stop {
    
    [self removeTimeObserver];
    
    [self.player cancelPendingPrerolls];
    self.player = nil;
    
    self.playerItem = nil;
    
    [self.playQueue removeAllObjects];
    currentIndex = 0;
    [self.statusDelegates makeObjectsPerformSelector:@selector(ttAudioPlayerStoped)];
    NSLog(@"停止播放");
}

- (void) play {
    [_player play];
    NSLog(@"播放");
    [self.statusDelegates makeObjectsPerformSelector:@selector(ttAudioPlayerPlayStart)];

}

- (void) continuePlay {
    [_player play];
    NSLog(@"继续播放");
    [self.statusDelegates makeObjectsPerformSelector:@selector(ttAudioPlayerPlayStart)];
}

- (BOOL)isNextExist {
    if (currentIndex>=(_playQueue.count-1) || _playQueue.count==0) {
        NSLog(@"没有下一曲");
        return NO;
    }
    NSLog(@"有下一曲");
    return YES;
}

- (BOOL)isPreExist {
    if (currentIndex<=0) {
        NSLog(@"没有前一首");
        return NO;
    }
    NSLog(@"有前一首");
    return YES;
}

- (BOOL)isPlaying {
    if (_player && (_player.rate>0.0) && (_player.error==nil) ) {
        NSLog(@"播放状态：播放");
        return YES;
    }
    NSLog(@"播放状态：暂停");
    return NO;
}

- (double) currentSecs {
    return CMTimeGetSeconds(_player.currentTime);
}

- (double) durationSecs {
    return CMTimeGetSeconds(_player.currentItem.duration);
}

#pragma mark - 播放进度
- (void)updateProgress {
    
    if (_playerItem.status != AVPlayerItemStatusReadyToPlay)
    {
        [self.statusDelegates makeObjectsPerformSelector:@selector(ttAudioPlayerUpdateProgress:) withObject:@(0.0f)];
        return;
    }
    
    double currentTime = [self currentSecs];
    double duration = [self durationSecs];
    if (isfinite(duration) && (duration>0))
    {
        float maxValue = CMTimeGetSeconds(_player.currentItem.asset.duration);
        double progress =  currentTime/maxValue;
        [self.statusDelegates makeObjectsPerformSelector:@selector(ttAudioPlayerUpdateProgress:) withObject:@(progress)];
        self->currentTime = currentTime;
    }
}

#pragma mark 可播放时长（缓冲时长）
- (NSTimeInterval)availableBufferTime
{
    NSArray *loadTimeRanges = [[self.player currentItem] loadedTimeRanges];
    //获取缓冲区域
    CMTimeRange range = [loadTimeRanges.firstObject CMTimeRangeValue];
    NSTimeInterval startTime = CMTimeGetSeconds(range.start);
    NSTimeInterval duration = CMTimeGetSeconds(range.duration);
    return startTime + duration;
}


#pragma mark -  -----------------KVO、通知-----------------
- (void)musicPlaybackFinished:(NSNotification *)noti {
    
    [self next];
    
//    if ([self.delegate respondsToSelector:@selector(ttAudioPlayerPlayFinished)]) {
//        [self.delegate ttAudioPlayerPlayFinished];
//    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context != playerItemContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([@"status" isEqualToString:keyPath]) {
        if (AVPlayerItemStatusFailed == [item status]) {
            NSError *error = [item error];
            [self.statusDelegates makeObjectsPerformSelector:@selector(ttAudioPlayerPlayError:) withObject:error];

            NSLog(@"AVPlayerItem.status->音频播放出错");
        } else if (AVPlayerItemStatusReadyToPlay == [item status]) {
            [self.statusDelegates makeObjectsPerformSelector:@selector(ttAudioPlayerPlayStart)];
            NSLog(@"AVPlayerItem.status->音频ReadyToPlay");
        }
    } else if ([@"loadedTimeRanges" isEqualToString:keyPath]) {
        bufferTime = [self availableBufferTime];
        
        /// 如果卡主，缓存大于播放进度1秒就开始播放
        if (bufferTime-currentTime>1) {
            
            if (!self.isPlaying && _player.status == AVPlayerStatusReadyToPlay) {
                NSLog(@"缓存大于播放进度1秒，继续播放");
                [self continuePlay];
            }
            
        } else {
            
            if (self.isPlaying) {
                NSLog(@"缓存小于播放进度1秒，暂停播放");
                [self pause];
            }
            
        }
    }
    
}

#pragma mark - ---------------处理中断事件-----------------
- (void)handleInterreptionNotification:(NSNotification *)notification {
    if ([notification.userInfo count] == 0) {
        return;
    }
    if (AVAudioSessionInterruptionTypeBegan == [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue]) {
        NSLog(@"中断，暂停音乐");
        [self pause];
    }
    else if (AVAudioSessionInterruptionTypeEnded == [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue]) {
        NSError *error,*activeError;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:0 error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&activeError];
        if (error) {
            NSLog(@"中断结束，设置类别失败:%@",error);
        } else if (activeError) {
            NSLog(@"中断结束，获取音频焦点失败:%@",activeError);
        } else {
            NSLog(@"中断结束，恢复音乐播放");
            [self continuePlay];
        }
    }
}

#pragma mark - /******************************     监听者管理    ******************************/
- (void)addStatusDelagate:(id<TTAudioPlayerStatusDelegate>)delegate {
    [_statusDelegates addObject:delegate];
}
- (void)removeStatusDelegate:(id<TTAudioPlayerStatusDelegate>)delegate
{
    [_statusDelegates removeObject:delegate];
}

#pragma mark - /******************************     private    ******************************/ate
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (_playerItem == playerItem) {return;}
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"]; //监听状态
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];//监听缓冲
        NSLog(@"移除AVPlayerItem监听");
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlaybackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:playerItemContext];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:playerItemContext];
        NSLog(@"添加AVPlayerItem监听");
    }
}

- (void)removeTimeObserver
{
    if (timeObserver) {
        [self.player removeTimeObserver:timeObserver];
        timeObserver = nil;
        NSLog(@"移除之前时间监听");
    }
}



@end
