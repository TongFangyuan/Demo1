//
//  MethodHelper.m
//  Apple
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import "MethodHelper.h"
#import "NSDate+Convert.h"

@implementation MethodHelper

#pragma mark 获取YmdHms当前时间
+ (NSString *) getYdmHmsCurrentTime {
    NSDate *now = [NSDate date];
    return [now toStringWithFormat:LONG_DATE_FORMAT inUTC:NO];
}
#pragma mark 获取Ymd当前时间
+ (NSString *) getYmdCurrentTime {
    NSDate *now = [NSDate date];
    return [now toStringWithFormat:DEFAULT_DATE_FOMRAT inUTC:NO];
}
#pragma mark 获取Ymd特定时间
+ (NSString *) getYmdTimeStringWithDate:(NSDate *)date {
    return [date toStringWithFormat:DEFAULT_DATE_FOMRAT inUTC:NO];
}
#pragma mark 获取本月
+ (NSString *) getCurrentMonth {
    NSDate *now = [NSDate date];
    int month = [now month];
    return [NSString stringWithFormat:@"%d", month];
}
#pragma mark 获取本年
+ (NSString *) getCurrentYear {
    NSDate *now = [NSDate date];
    int year = [now year];
    return [NSString stringWithFormat:@"%d", year];
}
#pragma mark 获取N天前日期
+ (NSString *) getDateDescByDaysAgo:(int)daysAgo {
    
    NSDate *now = [NSDate date];
    long long distance = 3600*24*daysAgo;
    long long timeSince1970Interval = [now timeIntervalSince1970];
    long long daysAgoInterval = timeSince1970Interval - distance;
    NSDate *daysAgoDate = [NSDate dateWithTimeIntervalSince1970:daysAgoInterval];
    NSString *dateString = [daysAgoDate toStringWithFormat:DEFAULT_DATE_FOMRAT inUTC:NO];
    return dateString;
}
#pragma mark 根据字符串获取日期对象
+ (NSDate *) dateWithString:(NSString *)string {
    return [NSDate dateWithString:string inFormat:LONG_DATE_FORMAT];
}
#pragma mark 获取今天是周几
+ (int) weekDayWithDateString:(NSString *)dateString
{
    if(dateString.length < 10) return -1;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSString *nowString = [dateString substringToIndex:10];
    NSArray *array = [nowString componentsSeparatedByString:@"-"];
    if (array.count >= 3) {
        int year = [[array objectAtIndex:0] integerValue];
        int month = [[array objectAtIndex:1] integerValue];
        int day = [[array objectAtIndex:2] integerValue];
        [comps setYear:year];
        [comps setMonth:month];
        [comps setDay:day];
    }
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    
    int week = [weekdayComponents weekday];
    week = week-1;
    
    return week;
    
    NSString *weekDayStr = nil;
    switch (week) {
        case 0:
            weekDayStr = @"星期日";
            break;
        case 1:
            weekDayStr = @"星期一";
            break;
        case 2:
            weekDayStr = @"星期二";
            break;
        case 3:
            weekDayStr = @"星期三";
            break;
        case 4:
            weekDayStr = @"星期四";
            break;
        case 5:
            weekDayStr = @"星期五";
            break;
        case 6:
            weekDayStr = @"星期六";
            break;
        default:
            weekDayStr = @"";
            break;
    }
    return weekDayStr;
}




#pragma mark - 各种弹出框定义
+ (void) alertNoWait:(NSString *)message withTitle:(NSString *)title {
    UIAlertView * messageBox = [[UIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:kOKText
                                                otherButtonTitles: nil];
    [messageBox show];
}

+ (void) alert:(NSString *)message withTitle:(NSString *)title ContainerObj:(id)obj {
    UIAlertView * messageBox = [[UIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:obj
                                                cancelButtonTitle:kOKText
                                                otherButtonTitles: nil];
    [messageBox show];
}

+ (void) confirm:(NSString *)message withTitle:(NSString *)title ContainerObj:(NSObject *)obj {
    UIAlertView * messageBox = [[UIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:obj
                                                cancelButtonTitle:kNOText
                                                otherButtonTitles:kYESText, nil];
    [messageBox show];
}


+ (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = 240;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

#pragma mark - 判断字符串是否为纯阿拉伯数字
+ (BOOL)isNum:(NSString *)checkedNumString {
    //    之前的方法
    //    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    //    if(checkedNumString.length > 0) {
    //        return NO;
    //    }
    //    return YES;
    
    //// 纯阿拉伯数字
    NSString* number1=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number1];
    if ([numberPre evaluateWithObject:checkedNumString]) {
        NSLog(@"isNum->纯阿拉伯数字");
        return YES;
    }
    
    //// 纯中文数字
    NSString *numer2 = @"^[一壹幺二贰两三叁四肆五伍六陆七柒拐八捌九玖勾〇零洞]+$";
    NSPredicate *chNumberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numer2];
    if ([chNumberPre evaluateWithObject:checkedNumString]) {
        NSLog(@"isNum->纯中文数字");
        return YES;
    }
    
    return NO;
    
}
#pragma mark - 判断字符串是否为纯中文数字
+ (BOOL)isCNNumer:(NSString *)checkedNumString
{
    NSString *numer2 = @"^[一壹幺二贰两三叁四肆五伍六陆七柒拐八捌九玖勾〇零洞]+$";
    NSPredicate *chNumberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numer2];
    if ([chNumberPre evaluateWithObject:checkedNumString]) {
        NSLog(@"isNum->纯中文数字");
        return YES;
    }
    
    return NO;
}

#pragma mark - 中文数字转阿拉伯数字
+ (NSString *)arabicNumersFromCNNumbers:(NSString *)cnNumbers
{
    if (cnNumbers.length<=0 || !cnNumbers) {
        return nil;
    }
    NSString *arabNumer = [[NSString alloc] initWithString:cnNumbers];
    /// 一壹幺
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"一" withString:@"1"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"壹" withString:@"1"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"幺" withString:@"1"];
    /// 二贰两
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"二" withString:@"2"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"贰" withString:@"2"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"两" withString:@"2"];
    /// 三叁
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"三" withString:@"3"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"叁" withString:@"3"];
    /// 四肆
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"四" withString:@"4"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"肆" withString:@"4"];
    /// 五伍
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"五" withString:@"5"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"伍" withString:@"5"];
    /// 六陆
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"六" withString:@"6"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"陆" withString:@"6"];
    /// 七柒拐
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"七" withString:@"7"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"柒" withString:@"7"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"拐" withString:@"7"];
    /// 八捌
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"八" withString:@"8"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"捌" withString:@"8"];
    /// 九玖勾
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"九" withString:@"9"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"玖" withString:@"9"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"勾" withString:@"9"];
    /// 〇零洞
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"〇" withString:@"0"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"零" withString:@"0"];
    arabNumer = [arabNumer stringByReplacingOccurrencesOfString:@"洞" withString:@"0"];
    
    return arabNumer;
    
}

#pragma mark - 打电话
+ (void)callPhone:(NSString *)phoneNo {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNo];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark 字典转json字符串
+ (NSString*)convertToJSONData:(id)infoDict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = @"";
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}


#pragma mark - 常用正则表达式
+ (BOOL)isEmail:(NSString *)str
{
    NSString *email = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:email checkStr:str];
}
+ (BOOL)isPhone:(NSString *)str
{
    NSString *phone = @"^1+[3578]+\\d{9}";
    return [self isValidateByRegex:phone checkStr:str];
}
+ (BOOL)isIDCard:(NSString *)str
{
    NSString *IDCard = @"^(\\\\d{14}|\\\\d{17})(\\\\d|[xX])$";
    return [self isValidateByRegex:IDCard checkStr:str];
}
+ (BOOL)isPostCode:(NSString *)str
{
    NSString *post = @"^[0-8]\\\\d{5}(?!\\\\d)$";
    return [self isValidateByRegex:post checkStr:str];
}
+ (BOOL)isValidateByRegex:(NSString *)regex checkStr:(NSString *)checkStr
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:checkStr];
}

@end
