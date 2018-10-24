//
//  BleDbTool.m
//  APlan
//
//  Created by ven on 14-8-26.
//  Copyright (c) 2014年 jingling. All rights reserved.
//

#import "BleDbTool.h"

@implementation BleDbTool

#pragma mark - 获取所有已连接的设备
+ (NSArray *)getAllConnectedDevicesFromDB {
    return [BleDevice getAllConnectedDevicesFromDB];
}
#pragma mark - 获取某个已连接的设备
+ (BleDevice *)getConnectedDeviceFromDBWithModel:(BleDevice *)model {
    return [BleDevice getConnectedDeviceFromDBWithModel:model];
}
#pragma mark - 获取所有扫描到的设备
+ (NSArray *) getAllDiscovedBleDevice {
    return [BleDevice getAllDiscovedBleDevice];
}
#pragma mark - 插入或更新某一设备
+ (void) insertOrModifyBleDeviceWithModel:(BleDevice *)new_model {
    [BleDevice insertOrModifyBleDeviceWithModel:new_model];
}
#pragma mark - 删除某一设备
+ (BOOL) removeBleDeviceWithModel:(BleDevice *)model {
    return [BleDevice removeBleDeviceWithModel:model];
}
#pragma mark - 删除所有已扫描到的设备
+ (BOOL) removeAllDiscovedBleDevice {
    return [BleDevice removeAllDiscovedBleDevice];
}

@end
