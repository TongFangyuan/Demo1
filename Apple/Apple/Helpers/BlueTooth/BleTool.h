//
//  BleTool.h
//  APlan
//
//  Created by linzhiyong on 14-8-26.
//  Copyright (c) 2014年 linzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ScanBleBlock)(NSMutableArray *peripherals);
typedef void (^DisConnectBleBlock)(void);
typedef void (^BleResponseBlock)(NSError *error);
typedef void (^RequestLabelHeightGapBlock)(id data);

@interface BleTool : NSObject

+ (instancetype) shareManeger;

@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) NSMutableArray *connectedPeripherals;

/* 判断蓝牙是否打开 */
- (BOOL) judgeBLEPowerSwitchIsOn;
/* 扫描设备。timeout小于0实时扫描 */
- (int) scanBLEPeripheralsWithTimeout:(int)timeout Block:(ScanBleBlock)block;
/* 连接指定设备 */
- (void) connectPeripheral:(CBPeripheral *)peripheral;
/* 与设备断开连接 */
- (void) disconnectPeripheral:(CBPeripheral *)peripheral Block:(DisConnectBleBlock)block;


/******************************打印机******************************/
///* 打印数据*/
//- (void) printModel:(BPTemplate *)model peripheral:(CBPeripheral *)peripheral block:(BleResponseBlock)block;
///** 获取标签的宽度和间隙 */
//- (void) requestWidthAndGapOfLabel:(CBPeripheral *)per block:(RequestLabelHeightGapBlock)block;
//
//#pragma mark - test
///* 文字打印测试 */
//- (void) test_textPrintWithPeripheral:(CBPeripheral *)peripheral text:(NSString *)text block:(BleResponseBlock)block;
///* 图片打印测试 */
//- (void) test_printImage:(UIImage *)image peripheral:(CBPeripheral *)peripheral;
///** 测试打印条形码 */
//- (void) test_printBarCode:(id<BPDataEncoder>)model peripheral:(CBPeripheral *)peripheral;


@end
