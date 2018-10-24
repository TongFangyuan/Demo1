//
//  NSDate+Substract.m
//  UFTMobile
//
//  Created by PENG.Q on 11-8-26.
//  Copyright 2011年 UFTobacco Inc. Ltd. All rights reserved.
//

#import "NSDate+Convert.h"
#include <time.h>


@implementation NSDate (Convert)


+ (NSDate *)dateWithString:(NSString *)string inFormat:(NSString *)format {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    if (!format) format = LONG_DATE_FORMAT;
    [formatter setDateFormat:format];
	NSDate *value = [formatter dateFromString:string];
	return value;
}

+ (NSDate *)dateWithString:(NSString *)string inFormat:(NSString *)format isUTC:(BOOL)isUTC {
    //ymd: string in 'YYYY-MM-DD' format
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    if (!format) format = LONG_DATE_FORMAT;
    
    // NSDateFormatter: -dateFromString: 默认认为参数时间字符串为本地时间
    if (isUTC) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    }
    [formatter setDateFormat:format];
    NSDate * dt = [formatter dateFromString:string];
    return dt;
}

+ (NSDate *)dateWithStepsFromRefereceDate:(NSDate *)refDate forSteps:(int)steps forward:(BOOL)forward inUnit:(dateunit)inUnit {
    time_t t = (time_t)[refDate timeIntervalSince1970];
    struct tm * tm_ = localtime(&t);
    int direction = forward ? 1 : -1;
    
    switch (inUnit) {
        case YEAR:
            tm_->tm_year += direction * steps;
            break;
        
        case MONTH:
            tm_->tm_mon += direction * steps;
            break;
            
        default:
            tm_->tm_mday += direction * steps;
            break;
    }
    
    t = mktime(tm_);
    return [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)t];
}

- (NSString *)toYMDString {
	return [self toStringWithFormat:DEFAULT_DATE_FOMRAT inUTC:NO];
}

- (NSString *)toStringWithFormat:(NSString *)dateFormat inUTC:(BOOL)inUTC {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateFormat];
    
    // NSDateFormatter: -stringFromDate: 默认格式化为本地时间
    if (inUTC) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    }
    
	NSString *value = [formatter stringFromDate:self];
	
	return value;
}


// 以下各方法均计算为本地时间

- (void)dateParts:(DATEPARTS *)parts {
    time_t t = (time_t)[self timeIntervalSince1970];
    struct tm * tm_ = localtime(&t);
    parts->year = tm_->tm_year + 1900;
    parts->month = tm_->tm_mon + 1;
    parts->day = tm_->tm_mday;
}

- (int)year {
    time_t t = (time_t)[self timeIntervalSince1970];
    struct tm * tm_ = localtime(&t);
    return tm_->tm_year + 1900;
}

- (int)month {
    time_t t = (time_t)[self timeIntervalSince1970];
    struct tm * tm_ = localtime(&t);
    return tm_->tm_mon + 1;
}

- (int)day {
    time_t t = (time_t)[self timeIntervalSince1970];
    struct tm * tm_ = localtime(&t);
    return tm_->tm_mday;
}



#pragma mark 将特定时区的时间转为当前时区时间
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}



@end
