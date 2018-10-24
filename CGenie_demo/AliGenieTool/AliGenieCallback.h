/**
 ******************************************************
 *         该类需要客户自行实现
 ******************************************************
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

#define kGenieAskToRecordNotification         @"kGenieAskToRecordNotification"       //请求录音
#define kGenieStopRecordingNotification       @"kGenieStopRecordingNotification"     //结束录音
#define kGenieSetRecordVolumeNotification     @"kGenieSetRecordVolumeNotification"   //设置录音音量
#define kGenieSetInputTextNotification        @"kGenieSetInputTextNotification"      //输入文字
#define kGenieSetOutputTextNotification       @"kGenieSetOutputTextNotification"     //输出文字

@interface AliGenieCallback : NSObject

/*********
 * 唤醒录音相关回调
 */
//准备进入唤醒状态, 一般在APP侧进行提示: 播放声音、展示画面
- (void) prepareToRecord;
//多轮对话中，由SDK侧主动发起语音事件; 一般在内部直接调用AliGenieLoaderOC的
//prepareToRecord, startToRecord
- (void) askToRecord;
//由SDK侧VAD主动发起停止录音
- (void) stopRecording:(int32_t) sessionId;
/*
 * 唤醒录音相关结束
 ********/

/*********
 * 设备控制相关操作
 */
//获取当前音量, 需要将返回数值转成 0.0-100.0
- (float) getCurrentVolume;
//设置播放音量, 传入参数范围 0.0-100.0
- (void) setCurrentVolume:(float)v;
//ASR云端音量大小
- (void) setASRVolume:(float)v;
//获取设备唯一不变码UUID, 请使用手机的唯一码
- (NSString*) getDeviceUUID;
/*
 * 设备控制相关结束
 *********/

/*********
 * 消息记录与处理相关
 */
/*ASR动态识别结果
 * params:
 *     sessionId: 本次会话的id
 *     txt: ASR具体文本
 *     isFinish: ASR是否结束标识
 * return:
 *     返回为0，则继续NLU处理;
 *     返回为1，则停止NLU处理;
 **/
- (int32_t) setInputText:(int32_t)sessionId txt:(NSString*)txt isFinish:(BOOL)isFinish;
/* TTS返回结果
 * params:
 *     sessionId: 本次会话的id
                    {
                        TtsData* td = (TtsData*)cd->mData;
                        printf("Get User data=%s", td->mStremData);
                        if(callback){
                            callback->setOutputText(data->mSessionId, td->mStremData);
                        }
                        break;
                    }
 *     txt: TTS具体文本 
 *     isFinish: ASR是否结束标识
 * return:
 *     返回为0，则继续NLU处理; 请统一返回0
 *     返回为1，则停止NLU处理; 目前不起效果
 **/
- (int32_t) setOutputText:(int32_t)sessionId txt:(NSString*)txt;

//NLP处理结果各型协议数据, 返回为1则NLP后续处理停止，返回为0则继续处理
/* NLU返回结果:透传数据
 * params:
 *     sessionId: 本次会话的id
 *     resp: 服务端消息
 * return:
 *     返回为0，则继续NLU后续处理; 主要是播放控制相关逻辑的SDK自有处理机制
 *     返回为1，则停止NLU后续处理;
 **/
- (int32_t) passthroughData:(int32_t)sessionId json:(NSString*)resp;

/*
 * TTS相关流程，开启时，会先走 setOutputText, 然后走一次passthroughtData
 */
//TTS二进制数据片断
- (int32_t) passthroughTtsFragment:(int32_t)sessionId data:(void*)data size:(int32_t)size;
//TTS结束标识
- (int32_t) passthroughTtsFinish:(int32_t)sessionId;

//UI展示Toast
- (void) makeToast:(UIView*)base message:(NSString*)txt;
/*
 * 消息记录与处理结束
 *********/



@end
