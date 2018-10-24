//
//  AliGenieLoaderOC.h
//  RLAudioRecord
//
//  Created by wpc on 2018/6/17.
//  Copyright © 2018年 Enorth.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliGenieLoaderOC : NSObject

+ (void) initInstance:(NSString*)persistDirectory
            configJson:(NSString*)configJson
            bizInfo:(NSString*)bizInfo
            bizType:(NSString*)type
            secret:(NSString*)secret;
+ (id) getInstance;
- (void) setCallback:(id) callback;
- (void) enableDebugLog:(BOOL) enable;

//Let the system to silence and prepare to record
//准备录音: 将目前所有的播放进行中止打断.
- (void) prepareToRecord;

//Goto record & asr status
//    useVad: use the system VAD
//    return: id
//进入录音状态, useVad是否使用系统自带VAD
//返回本次请求的id
- (int32_t) startToRecord:(BOOL) useVad; 

//feed data by user
//Return true if VAD  happens
//音频数据传输, 如果使用系统自带的VAD，数据长度必须是160的整数倍
- (BOOL) record:(NSData*) buf size:(int32_t)s;

//Stop Recording by user
//用户强制停止录音
- (int32_t) stopRecording:(int32_t)sessionId;

//系统状态同步
- (int32_t) onStatusChanged:(void*)appStatusData;
- (int32_t) playTts:(NSString*)tts isOpenMic:(BOOL)isOpenMic;
- (BOOL) stopTts:(int32_t)sessionId;
@end

