//
//  BluetoothDevice.m
//  MagicFinder
//
//  Created by weiheng on 15/2/3.
//  Copyright (c) 2015年 ven. All rights reserved.
//

#import "BleDevice.h"

@implementation BleDevice

+ (NSString *) getPrimaryKey
{
    return @"deviceUUID";
}
+ (NSString *) getTableName
{
    return @"BleDeviceTable";
}

#pragma mark - 获取所有已连接的设备
+ (NSArray *)getAllConnectedDevicesFromDB {
    BOOL isConnected = YES;
    NSString *querySql = [NSString stringWithFormat:@"isConnected = '%d'", isConnected];
    NSArray *result = [BleDevice searchWithWhere:querySql orderBy:nil offset:0 count:0];
    return result;
}

#pragma mark - 获取某个已连接的设备
+ (BleDevice *)getConnectedDeviceFromDBWithModel:(BleDevice *)model {
    if (model.deviceUUID.length <= 0) return nil;
    NSString *querySql = [NSString stringWithFormat:@"deviceUUID = '%@' and isConnected = 1", model.deviceUUID];
    return [BleDevice searchSingleWithWhere:querySql orderBy:nil];
}

#pragma mark - 获取所有扫描到的设备
+ (NSArray *)getAllDiscovedBleDevice {
    NSArray *result = [BleDevice searchWithWhere:nil orderBy:nil offset:0 count:0];
    return result;
}

#pragma mark - 插入或更新某一设备
+ (void)insertOrModifyBleDeviceWithModel:(BleDevice *)new_model {
    
    if(new_model.deviceUUID.length <= 0) return;
    NSString *querySql = [NSString stringWithFormat:@"deviceUUID = '%@'", new_model.deviceUUID];
    NSArray *result = [BleDevice searchWithWhere:querySql orderBy:nil offset:0 count:0];
    if(result.count <= 0) {
        BleDevice * device = [[BleDevice alloc]init];
        device.deviceUUID = new_model.deviceUUID;
        device.deviceName = new_model.deviceName;
        device.rssi = new_model.rssi;
        device.battery = new_model.battery;
        device.iconImageName = new_model.iconImageName;
        device.distance = new_model.distance;
        device.lostLength = new_model.lostLength;
        device.alertIsOn = new_model.alertIsOn;
        device.isConnected = new_model.isConnected;
        device.isDelete = new_model.isDelete;
        [BleDevice insertWhenNotExists:device];
    } else {
        NSString *deviceUUID = new_model.deviceUUID;
        NSString *deviceName = new_model.deviceName;
        NSNumber *rssi = new_model.rssi;
        NSString *battery = new_model.battery;
        NSString *iconImageName = new_model.iconImageName;
        float distance = new_model.distance;
        int lostLength = new_model.lostLength;
        BOOL alertIsOn = new_model.alertIsOn;
        BOOL isConnected = new_model.isConnected;
        BOOL isDelete = new_model.isDelete;
        
        for(BleDevice *oldModel in result) {
            if(deviceUUID.length > 0) {
                oldModel.deviceUUID = new_model.deviceUUID;
            }
            if (deviceName.length > 0) {
                oldModel.deviceName = deviceName;
            }
            oldModel.rssi = rssi;
            if (battery.length > 0) {
                oldModel.battery = battery;
            }
            if (iconImageName) {
                oldModel.iconImageName = iconImageName;
            }
            oldModel.distance = distance;
            oldModel.lostLength = lostLength;
            oldModel.alertIsOn = alertIsOn;
            oldModel.isConnected = isConnected;
            oldModel.isDelete = isDelete;
            [BleDevice updateToDB:oldModel where:querySql];
        }
    }
}

#pragma mark - 删除某一设备
+ (BOOL)removeBleDeviceWithModel:(BleDevice *)model {
    
    if(model.deviceUUID.length <= 0) return YES;
    NSString *querySql = [NSString stringWithFormat:@"deviceUUID = '%@'", model.deviceUUID];
    NSArray *result = [BleDevice searchWithWhere:querySql orderBy:nil offset:0 count:0];
    for(BleDevice *model in result) {
        [BleDevice deleteToDB:model];
    }
    return YES;
}

#pragma mark - 删除所有已扫描到的设备
+ (BOOL)removeAllDiscovedBleDevice {
    
    NSArray *result = [BleDevice searchWithWhere:nil orderBy:nil offset:0 count:0];
    for(BleDevice *model in result) {
        [BleDevice deleteToDB:model];
    }
    return YES;
}

@end
