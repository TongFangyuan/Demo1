//
//  NSObject+AliGenieCallback.m
//  AliGenieDemo
//
//  Created by wpc on 2018/9/29.
//  Copyright © 2018年 Enorth.com. All rights reserved.
//

#import "AliGenieCallback.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+Toast.h"

@implementation AliGenieCallback:NSObject

/*********
 * 唤醒录音相关回调
 */
//准备进入唤醒状态, 一般在APP侧进行提示: 播放声音、展示画面
- (void) prepareToRecord
{
    
}
//多轮对话中，由SDK侧主动发起语音事件; 一般在内部直接调用AliGenieLoaderOC的
//prepareToRecord, startToRecord
- (void) askToRecord
{
    [mainVC askToStartRecord];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kGenieAskToRecordNotification object:nil];
}
//由SDK侧VAD主动发起停止录音
- (void) stopRecording:(int32_t) sessionId
{
    [mainVC vadToStopRecord];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kGenieStopRecordingNotification object:@(sessionId)];
}
/*
 * 唤醒录音相关结束
 ********/

static UISlider* getMPVolumeSlider(){
    MPVolumeView* vv = [[MPVolumeView alloc]init];
    
    vv.showsRouteButton = NO;
    vv.showsVolumeSlider = YES;
    
    [vv sizeToFit];
    [vv setFrame:CGRectMake(-1000, -1000, 10, 10)];
    
    [vv userActivity];
    UISlider* vs;
    for (UIView *view in [vv subviews]){
        if ([[view.class description] isEqualToString:@"MPVolumeSlider"]){
            vs = (UISlider*)view;
            break;
        }
    }
    return vs;
}
/*********
 * 设备控制相关操作
 */
//获取当前音量, 需要将返回数值转成 0.0-100.0
- (float) getCurrentVolume
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    return audioSession.outputVolume*100;
}
//设置播放音量, 传入参数范围 0.0-100.0
- (void) setCurrentVolume:(float)v
{
    v = v*1.0/100;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        MPVolumeView* vv = [[MPVolumeView alloc]init];
        
        vv.showsRouteButton = NO;
        vv.showsVolumeSlider = YES;
        
        [vv sizeToFit];
        [vv setFrame:CGRectMake(-1000, -1000, 10, 10)];
        
        [vv userActivity];
        UISlider* vs;
        for (UIView *view in [vv subviews]){
            if ([[view.class description] isEqualToString:@"MPVolumeSlider"]){
                vs = (UISlider*)view;
                break;
            }
        }
        [vs setValue:v animated:YES];
    }];
}
//ASR云端音量大小
- (void) setASRVolume:(float)v
{
//    [mainVC setRecordVolume:(int)v];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGenieSetRecordVolumeNotification object:@(v)];
}
//获取设备唯一不变码UUID, 请使用手机的唯一码
- (NSString*) getDeviceUUID
{
    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return deviceUUID;
}
/*
 * 设备控制相关结束
 *********/

/*********
 * 消息记录与处理相关
 */
//ASR动态识别结果
//返回为0，则继续处理；返回为1，则不做NLU处理
- (int32_t) setInputText:(int32_t)sessionId txt:(NSString*)txt isFinish:(BOOL)isFinish
{
    [mainVC setInputText:txt];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kGenieSetInputTextNotification object:txt];
    return 0;
}
//NLP最终返回结果
- (int32_t) setOutputText:(int32_t)sessionId txt:(NSString*)txt
{
    [mainVC setOutputText:txt];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kGenieSetOutputTextNotification object:txt];
    return 0;
}
//NLP处理结果各型协议数据, 返回为1则NLP后续处理停止，返回为0则继续处理
- (int32_t) passthroughData:(int32_t)sessionId json:(NSString*)resp
{
    NSLog(@"Passthrough Data/%d=%@", sessionId, resp);
    return 0;
}
/*
 * TTS相关流程，开启时，会先走 setOutputText, 然后走一次passthroughtData
 */
//TTS二进制数据片断
- (int32_t) passthroughTtsFragment:(int32_t)sessionId data:(void*)data size:(int32_t)size
{
    NSLog(@"Passthrough Data TTS Fragment/%d=%d", sessionId, size);
    return 0;
}
//TTS结束标识
- (int32_t) passthroughTtsFinish:(int32_t)sessionId
{
    NSLog(@"Passthrough Data/%d Finish TTS", sessionId);
    return 0;
}
//UI展示Toast
- (void) makeToast:(UIView*)base message:(NSString*)txt
{
    [base makeToast:txt];
}
/*
 * 消息记录与处理结束
 *********/

@end
