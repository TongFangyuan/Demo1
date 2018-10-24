/* 
 * Filename         : AppStatus.h 
 * Author           : hongzhi.yuhz@alibaba-inc.com 
 * Created          : 2018-03-19
 * Description      : AppStatus header 
 * Copyright (c) Alibaba A.I. Labs. All rights reserved.
 */
#ifndef ALIGENIESDK_APP_APPSTATUS_H
#define ALIGENIESDK_APP_APPSTATUS_H
//Depends on libaligeniesdk.so/static library

#include "Object.h"

using namespace AliAiLabs::Base;

enum AppStatus
{   ST_NONE = 0,        //No use this
    ST_PLAYER,          //播放器状态, 用于CMD_AUDIO_PLAY播放状态上报, PlayerData
    ST_PLAYER_FEEDBACK, //播放器状态, 用于TTS和CMD_AUDIO_PLAY_ONETIME播放状态上报, PlayerFeedbackData
    ST_SPEAKER,         //扬声器状态（音量，静音), SpeakerData
    ST_SYSTEM,          //系统状态, SystemData
    ST_POWER,           //电源状态, PowerData
    ST_NETWORK,         //网络状态, NetworkData
    ST_BLUETOOTH        //蓝牙状态, BluetoothData
};

//ST_PLAYER
class PlayerData : public Object
{
public:
    enum Status      //播放器状态
    {
        ST_PLAY = 0, //播放中
        ST_PAUSE,    //暂停
        ST_STOP      //停止
    };

    enum Reason      //状态变化原因
    {
        REASON_PLAY = 0,        //开始播放
        REASON_PAUSE,           //暂停
        REASON_SUSPEND,         //挂起
        REASON_SUSPEND2RESUME,  //挂起后恢复
        REASON_RESUME,          //恢复播放
        REASON_STOP,            //停止播放
        REASON_FINISH,          //播放完成
        REASON_FAIL,            //播放失败
        REASON_RENDOR_UNDERRUN, //播放卡顿(underrun)
        REASON_RENDOR_WAITING_BUFFER //播放卡顿(waiting buffer)
    };

    enum Source         //播放来源
    {
        SRC_NONE = 0,   //未播放
        SRC_LINEIN,     //AUX线
        SRC_BLUETOOTH,  //蓝牙
        SRC_CLOUD       //云端
    };

public:
    Reason mReason;
    Status mStatus;
    Source mSource;
    CHAR* mAudioId;    //资源ID
    CHAR* mProgress;  //播放进度 
};

//ST_PLAYER_FEEDBACK
class PlayerFeedback : public Object
{
public:
    enum Reason            //状态变化的原因
    {
        REASON_PLAY = 0,   //开始播放
        REASON_COMPLETE,   //播放完成
        REASON_INTERUPT,   //播放中断
        REASON_FAIL        //播放失败
    };

    enum AudioType         //Audio类型
    {
        TYPE_ALARM = 0,    //Alarm
        TYPE_TTS,          //TTS
        TYPE_PROMPT        //提示音
    };

public:
    Reason mReason;      //状态变化原因
    AudioType mType;     //音频类型
};

//ST_SPEAKER
class SpeakerData : public Object
{
public:
    enum Reason           //变化原因
    {
        REASON_MUTE = 0,    //静音
        REASON_UNMUTE,      //解除静音
        REASON_VOLUME       //音量变化
    };

public:
    Reason mReason;
    INT32S mVolume;  //音量（0-100)
    BOOLEAN mIsMute; //是否静音
};

//ST_SYSTEM
class SystemData : public Object 
{
public:
    enum Status
    {
        ST_NORMAL = 0,  //工作状态
        ST_STANDBY      //待机（非工作）状态
    };

public:
    Status mStatus;           //系统状态
    CHAR* mFirmwareVersion;   //固件版本
};

//ST_POWER
class PowerData : public Object
{
public:
    enum Status             //电源状态
    {
        ST_CHARGE = 0,      //充电中
        ST_BATTERY,         //使用电池
        ST_ELECTRICITY      //外接电源
    };

public:
    Status mStatus;
    INT32S mQuantity;       //电量百分比(0-100)
};

//ST_NETWORK
class NetworkData : public Object
{
public:
    enum Status            //网络连接状态
    {
        ST_CONNECT = 0,    //网络已连接
        ST_DISCONNECT      //网络断开
    };

public:
    Status mStatus;
    INT32S mQuantity;      //WIFI信号强度(0-100)
    CHAR* mWifiName;       //WIFI网络名称
    CHAR* mMacAddress;     //MAC地址
};

//ST_BLUETOOTH
class BluetoothData : public Object
{
public:
    enum Status          //蓝牙连接状态
    {
        ST_START = 0,    //蓝牙已连接
        ST_CONNECT,      //蓝牙已连接
        ST_DISCONNECT,   //蓝牙断开
        ST_ERROR,
    };

public:
    Status mStatus;
    CHAR* mBTName;        //蓝牙名称
    CHAR* mPairName;      //配对的设备名称
    CHAR* mMacAddress;    //MAC地址
};

class AppStatusData : public Object {
public:
    AppStatusData();
    AppStatusData(AppStatus status);
    AppStatus mStatus;   // status to report
    Object* mData;       // params to report
};

#endif //ALIGENIESDK_APP_APPSTATUS_H
