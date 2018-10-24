//
//  MethodHelper.h
//  Apple
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MethodHelper : NSObject

// 获取YmdHms当前时间
+ (NSString *) getYdmHmsCurrentTime;
// 获取Ymd当前时间
+ (NSString *) getYmdCurrentTime;
// 获取Ymd特定时间
+ (NSString *) getYmdTimeStringWithDate:(NSDate *)date;
// 获取本月
+ (NSString *) getCurrentMonth;
// 获取本年
+ (NSString *) getCurrentYear;
// 获取N天前日期
+ (NSString *) getDateDescByDaysAgo:(int)daysAgo;
// 根据字符串获取日期对象
+ (NSDate *) dateWithString:(NSString *)string;
// 获取今天是周几
+ (int) weekDayWithDateString:(NSString *)dateString;

//////各种弹出框定义
+ (void)alertNoWait:(NSString *)message withTitle:(NSString *)title;
+ (void)alert:(NSString *)message withTitle:(NSString *)title ContainerObj:(id)obj;
+ (void)confirm:(NSString *)message withTitle:(NSString *)title ContainerObj:(NSObject *)obj;

//////自动消失弹出控件
+ (void)showHint:(NSString *)hint yOffset:(float)yOffset;

//////判断字符串是否为纯阿拉伯数字或纯中文数字
+ (BOOL)isNum:(NSString *)checkedNumString;
+ (BOOL)isCNNumer:(NSString *)checkedNumString;
//////中文数字转阿拉伯数字
+ (NSString *)arabicNumersFromCNNumbers:(NSString *)cnNumbers;
//////打电话
+ (void)callPhone:(NSString *)phoneNo;
//////字典转json字符串
+ (NSString*)convertToJSONData:(id)infoDict;

@end
