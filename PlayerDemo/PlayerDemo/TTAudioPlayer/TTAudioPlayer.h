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

@property (nonatomic, weak) id<TTAudioPlayerStatusDelegate> delegate;

+ (instancetype)shareInstance;

@end
