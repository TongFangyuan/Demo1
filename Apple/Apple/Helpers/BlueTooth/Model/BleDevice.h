//
//  BluetoothDevice.h
//  MagicFinder
//
//  Created by weiheng on 15/2/3.
//  Copyright (c) 2015年 ven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BleDevice : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSString *deviceUUID;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSNumber *rssi;
@property (nonatomic, strong) NSString *battery;
@property (nonatomic, strong) NSString *iconImageName;
@property (nonatomic, assign) float distance;
@property (nonatomic, assign) int lostLength;         //丢失的距离长度 1近1-3m/2中3-8m/3远8-15m
@property (nonatomic, assign) BOOL alertIsOn;
@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, assign) BOOL isDelete;

/* 获取所有已连接的设备 */
+ (NSArray *)getAllConnectedDevicesFromDB;
/* 获取某个已连接的设备 */
+ (BleDevice *)getConnectedDeviceFromDBWithModel:(BleDevice *)model;
/* 获取所有扫描到的设备 */
+ (NSArray *) getAllDiscovedBleDevice;
/* 插入或更新某一设备 */
+ (void) insertOrModifyBleDeviceWithModel:(BleDevice *)new_model;
/* 删除某一设备 */
+ (BOOL) removeBleDeviceWithModel:(BleDevice *)model;
/* 删除所有已扫描到的设备 */
+ (BOOL) removeAllDiscovedBleDevice;

@end
