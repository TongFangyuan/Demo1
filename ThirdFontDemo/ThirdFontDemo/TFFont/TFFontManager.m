//
//  TFFontManager.m
//  ThirdFontDemo
//
//  Created by admin on 2018/11/21.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "TFFontManager.h"

@implementation TFFontManager

+ (void)printAllFonts {
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    NSLog(@"当前字体: %@",font);
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *familyNameArray = [[NSMutableArray alloc] init];
        NSArray* familyNamesAll = [UIFont familyNames];
        NSLog(@"--------------所有字体开始----------------");
        for (id family in familyNamesAll) {
            NSArray* fonts = [UIFont fontNamesForFamilyName:family];
            for (id font in fonts)
            {
                [familyNameArray addObject:font];
                NSLog(@"%@",font);
            }
        }
         NSLog(@"--------------所有字体结束----------------");
    });
}

@end
