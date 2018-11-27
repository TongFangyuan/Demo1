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
    NSInteger currentIndex;//!< 歌曲索引
    id        timeObserver;//!< 进度观察
}

@property (nonatomic, strong) AVPlayer                                  *player;
@property (nonatomic, strong) AVPlayerItem                              *playerItem;
@property (nonatomic, strong) NSMutableArray<id<TTMusicModelProtocol>>  *playQueue;

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
    }
    return self;
}

#pragma mark -

- (void)playMusicWithInfo:(id<TTMusicModelProtocol>)model {
    
    [self removeTimeObserver];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:model.url]];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    self.player = player;
    self.playerItem = playerItem;
    [self.playQueue addObject:model];
    currentIndex = [self.playQueue indexOfObject:model];
    [self play];
    
    timeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        [self updateProgress];
    }];
}

#pragma mark - 播放队列管理

- (void)enterPlayQueueWithArray:(NSArray<id<TTMusicModelProtocol>> *)models {
    [_playQueue addObjectsFromArray:models];
}


- (void)enterPlayQueueWithSingle:(id<TTMusicModelProtocol>)model {
    [_playQueue addObject:model];
}


- (void)replaceAllQueueWithArray:(NSArray<id<TTMusicModelProtocol>> *)models {
    [self stop];
    [_playQueue removeAllObjects];
    [_playQueue addObjectsFromArray:models];
    [self playMusicWithInfo:models.firstObject];
}

- (void)replaceAllQueueWithSingle:(id<TTMusicModelProtocol>)model {
    [self stop];
    [_playQueue removeAllObjects];
    [_playQueue addObject:model];
    [self playMusicWithInfo:model];
}

#pragma mark - 播放器控制

- (void)next {
    if (![self isNextExist]) return;
    id<TTMusicModelProtocol> nextItem = _playQueue[currentIndex+1];
    [self playMusicWithInfo:nextItem];
}

- (void)pre {
    if (![self isPreExist]) return;
    id<TTMusicModelProtocol> preItem = _playQueue[currentIndex-1];
    [self playMusicWithInfo:preItem];
}

- (void)pause {
    [_player pause];
    if ([self.delegate respondsToSelector:@selector(ttAudioPlayerPause)]) {
        [self.delegate ttAudioPlayerPause];
    }
}

- (void)stop {
    
    [self removeTimeObserver];
    
    [self.player cancelPendingPrerolls];
    self.player = nil;
    
    self.playerItem = nil;
    
    [self.playQueue removeAllObjects];
    self.playQueue = nil;
    currentIndex = 0;
    if ([self.delegate respondsToSelector:@selector(ttAudioPlayerStoped)]) {
        [self.delegate ttAudioPlayerStoped];
    }
    
}

- (void) play {
    [_player play];
    if ([self.delegate respondsToSelector:@selector(ttAudioPlayerPlayStart)]) {
        [self.delegate ttAudioPlayerPlayStart];
    }
}

- (void) continuePlay {
    [_player play];
    if ([self.delegate respondsToSelector:@selector(ttAudioPlayerPlayStart)]) {
        [self.delegate ttAudioPlayerPlayStart];
    }
}

- (BOOL)isNextExist {
    if (currentIndex>=(_playQueue.count-1)) {
        return NO;
    }
    return YES;
}

- (BOOL)isPreExist {
    if (currentIndex<=0) {
        return NO;
    }
    return YES;
}

- (BOOL)isPlaying {
    if (_player && _player.rate > 0.0) {
        return YES;
    }
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
        if ([self.delegate respondsToSelector:@selector(ttAudioPlayerUpdateProgress:)]) {
            [self.delegate ttAudioPlayerUpdateProgress:0.0f];
        }
        return;
    }
    
    double currentTime = [self currentSecs];
    double duration = [self durationSecs];
    if (isfinite(duration) && (duration>0))
    {
        float maxValue = CMTimeGetSeconds(_player.currentItem.asset.duration);
        double progress =  currentTime/maxValue;
        if ([self.delegate respondsToSelector:@selector(ttAudioPlayerUpdateProgress:)]) {
            [self.delegate ttAudioPlayerUpdateProgress:progress];
        }
    }
}


#pragma mark - KVO
- (void)musicPlaybackFinished:(NSNotification *)noti {
    if ([self isNextExist]) {
        [self next];
    }
    if ([self.delegate respondsToSelector:@selector(ttAudioPlayerPlayFinished)]) {
        [self.delegate ttAudioPlayerPlayFinished];
    }
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
           if ([self.delegate respondsToSelector:@selector(ttAudioPlayerPlayError:)]) {
             [self.delegate ttAudioPlayerPlayError:error];
           }
        } else if (AVPlayerItemStatusReadyToPlay == [item status]) {
            if ([self.delegate respondsToSelector:@selector(ttAudioPlayerPlayStart)]) {
                [self.delegate ttAudioPlayerPlayStart];
            }
        }
    } else if ([@"loadedTimeRanges" isEqualToString:keyPath]) {
        
    }
    
}

#pragma mark - private
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (_playerItem == playerItem) {return;}
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlaybackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:playerItemContext];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:playerItemContext];
    }
}

- (void)removeTimeObserver
{
    if (timeObserver) {
        [self.player removeTimeObserver:timeObserver];
        timeObserver = nil;
    }
}



@end
