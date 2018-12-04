//
//  NSDate+Substract.h
//  UFTMobile
//
//  Created by PENG.Q on 11-8-26.
//  Copyright 2011年 UFTobacco Inc. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LONG_DATE_FORMAT    @"yyyy-MM-dd HH:mm:ss"
#define FULL_DATE_FORMAT    @"yyyy-MM-dd HH:mm:ss.SSS"
#define DEFAULT_DATE_FOMRAT @"yyyy-MM-dd"


typedef enum dateunit {
    YEAR,
    MONTH,
    DAY,
} dateunit;

typedef struct DATEPARTS_t {
    int year;
    int month;
    int day;
} DATEPARTS;


@interface NSDate (Convert)

+ (NSDate *)dateWithString:(NSString *)string inFormat:(NSString *)format;
+ (NSDate *)dateWithString:(NSString *)string inFormat:(NSString *)format isUTC:(BOOL)isUTC;
+ (NSDate *)dateWithStepsFromRefereceDate:(NSDate *)refDate forSteps:(int)steps forward:(BOOL)forward inUnit:(dateunit)inUnit;

- (NSString *)toYMDString;
- (NSString *)toStringWithFormat:(NSString *)dateFormat inUTC:(BOOL)inUTC;

- (void)dateParts:(DATEPARTS *)parts;
- (int)year;
- (int)month;
- (int)day;

/* 将特定时区的时间转为当前时区时间 */
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

@end
