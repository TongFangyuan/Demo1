//
//  BleDbTool.h
//  APlan
//
//  Created by ven on 14-8-26.
//  Copyright (c) 2014年 jingling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleDbTool : NSObject

/* 获取所有已连接的设备 */
+ (NSArray *) getAllConnectedDevicesFromDB;
/* 获取某个已连接的设备 */
+ (BleDevice *) getConnectedDeviceFromDBWithModel:(BleDevice *)model;
/* 获取所有扫描到的设备 */
+ (NSArray *) getAllDiscovedBleDevice;
/* 插入或更新某一设备 */
+ (void) insertOrModifyBleDeviceWithModel:(BleDevice *)new_model;
/* 删除某一设备 */
+ (BOOL) removeBleDeviceWithModel:(BleDevice *)model;
/* 删除所有已扫描到的设备 */
+ (BOOL) removeAllDiscovedBleDevice;

@end
