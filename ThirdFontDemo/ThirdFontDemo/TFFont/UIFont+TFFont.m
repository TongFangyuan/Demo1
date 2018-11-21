//
//  UIFont+TFFont.m
//  ThirdFontDemo
//
//  Created by admin on 2018/11/21.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "UIFont+TFFont.h"

@implementation UIFont (TFFont)

+ (UIFont *)chantalFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"CHANTAL-Normal" size:size];
}
+ (UIFont *)sfProTextRegularFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"SFProText-Regular" size:size];
}
+ (UIFont *)filsonSoftLightFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"FilsonSoft-Light" size:size];
}
+ (UIFont *)filsonSoftBookFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"FilsonSoftBook" size:size];
}
@end
