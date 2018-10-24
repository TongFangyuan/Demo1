//
//  QingtingFM.h
//  RLAudioRecord
//
//  Created by wpc on 2018/9/14.
//  Copyright © 2018年 Enorth.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
#import "XiamiH5Player.h"


@interface QQMusicH5Player : NSObject<WKScriptMessageHandler,WKNavigationDelegate,UIWebViewDelegate>
- (void) initWithView:(UIView*)uv chatViewContainer:(UIView*)cvc XiamiH5Base:(XiamiH5Player*)xiamiplayer;
- (void) setUrlChannel:(long long)cid program:(long long)pid;
- (int) setUrl:(const char*)url;
- (void) setToTTSPlayer:(bool) isTTs;
- (void) start;
- (void) pause;
- (void) resume;
- (void) seek:(long long) msec;
- (void) stop;
- (void) reset;
- (void) setVolume:(float) vol;
- (void) getVolume:(float*) vol;
- (void) getCurrentPosistion:(long long *)msec;
- (void) setLooping:(bool)loop;
- (bool) isLooping;
- (bool) isPlaying;
- (void) setStateListener:(void*)listener;
- (void) userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

extern QQMusicH5Player* qqmusicH5Player;
