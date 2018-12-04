//
//  XiamiH5Player.h
//  RLAudioRecord
//
//  Created by wpc on 2018/8/16.
//  Copyright © 2018年 Enorth.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
#import "AliGenieCallback.h"

@interface XiamiH5Player : NSObject<WKScriptMessageHandler,WKNavigationDelegate,UIWebViewDelegate>
- (void) initWithView:(UIView*)uv chatViewContainer:(UIView*)cvc callback:(AliGenieCallback*)callback;
- (void) setUrl:(long long)urlId;
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

- (AliGenieCallback*) getCallback;
- (UIWebView*) getMainUIWebView;
- (WKWebView*) getMainWKView;
- (UILabel*)   getUrlLabel;
- (BOOL) isUseWKWebView;
@end
extern XiamiH5Player* xiamiplayer;
