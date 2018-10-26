//
//  MethodHelper.h
//  Apple
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MethodHelper : NSObject

#pragma mark - 时间相关
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

#pragma mark - 各种弹出框定义
+ (void)alertNoWait:(NSString *)message withTitle:(NSString *)title;
+ (void)alert:(NSString *)message withTitle:(NSString *)title ContainerObj:(id)obj;
+ (void)confirm:(NSString *)message withTitle:(NSString *)title ContainerObj:(NSObject *)obj;

//////自动消失弹出控件
+ (void)showHint:(NSString *)hint yOffset:(float)yOffset;

#pragma mark - 判断字符串是否为纯阿拉伯数字或纯中文数字
+ (BOOL)isNum:(NSString *)checkedNumString;
+ (BOOL)isCNNumer:(NSString *)checkedNumString;
//////中文数字转阿拉伯数字
+ (NSString *)arabicNumersFromCNNumbers:(NSString *)cnNumbers;

#pragma mark - 电话
//////打电话
+ (void)callPhone:(NSString *)phoneNo;

#pragma mark - 字典转json字符串
//////字典转json字符串
+ (NSString*)convertToJSONData:(id)infoDict;

#pragma mark - 常用正则表达式
/* 验证邮箱 */
+ (BOOL)isEmail:(NSString *)str;
/* 验证手机号 */
+ (BOOL)isPhone:(NSString *)str;
/* 验证身份证 */
+ (BOOL)isIDCard:(NSString *)str;
/* 验证邮政编码 */
+ (BOOL)isPostCode:(NSString *)str;

@end
