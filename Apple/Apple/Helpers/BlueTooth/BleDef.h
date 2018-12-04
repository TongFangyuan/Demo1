
/////////蓝牙相关头文件
#import "BleDevice.h"
#import "BleDbTool.h"
#import "BleTool.h"

/****************************蓝牙模块通知声明********************/
#define kBLEDeviceConnectedOK               @"kBLEDeviceConnectedOK"                 //蓝牙设备连接成功
#define kBLEDeviceLostNoti                  @"BLEDeviceLostNoti"                     //蓝牙设备丢失
#define kBLEDistanceWarming                 @"kBLEDistanceWarming"                   //距离警告
#define kBLEDeviceInfoModified              @"kBLEDeviceInfoModified"                //设备信息修改
#define kBLEDeviceDistanceChanged           @"kBLEDeviceDistanceChanged"             //距离变化
#define kDiscovedDeviceChanged              @"kDiscovedDevicesChanged"               //扫描到了新设备
#define kBLENotificationConnectState        @"kBLENotificationConnectState"          //蓝牙连接状态变化
#define kBLECBCentralManagerStatePoweredOn  @"kBLECBCentralManagerStatePoweredOn"    //蓝牙状态为打开
#define kBLECBCentralManagerStatePoweredOff @"kBLECBCentralManagerStatePoweredOff"   //蓝牙状态为关闭
#define kBLEDeviceLedColorCharFound         @"kBLEDeviceLedColorCharactristcFound"   //蓝牙颜色控制特征发现

/****************************蓝牙模块协议声明********************/

// 搜索指定UUID的设备
#define kServiceSearchUUID                                 @"E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"

// 发现打印机的指定服务
#define kServiceFindUUID                                 @"49535343-FE7D-4AE5-8FA9-9FAFD205E455"
// 提供通知的特征
#define kPrinterNotifyIndicateCharacteristicUUID     @"49535343-1E4D-4BD9-BA61-23C647249616"
// 提供只写的特征
#define kPrinterWriteCharacteristicUUID              @"49535343-8841-43F4-A8D4-ECBE34729BB3"
