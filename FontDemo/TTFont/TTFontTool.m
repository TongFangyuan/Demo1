//
//  TTFontTool.m
//  FontDemo
//
//  Created by Tong on 2019/7/19.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import "TTFontTool.h"

@implementation TTFontTool

+ (nonnull instancetype)shareTool {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self=[super init]) {
        
    }
    return self;
}

- (void)printAllFonts {
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    NSLog(@"系统字体: %@",font);
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//        NSMutableArray *familyNameArray = [[NSMutableArray alloc] init];
//        NSArray* familyNamesAll = [UIFont familyNames];
//        NSLog(@"--------------所有字体开始----------------");
//        for (id family in familyNamesAll) {
//            NSArray* fonts = [UIFont fontNamesForFamilyName:family];
//            for (id font in fonts)
//            {
//                [familyNameArray addObject:font];
//                NSLog(@"%@",font);
//            }
//        }
//        NSLog(@"--------------所有字体结束----------------");
        NSArray *fontFamilies = [UIFont familyNames];
        for (NSString *fontFamily in fontFamilies)
        {
            NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamily];
            NSLog (@">>> fontFamily : %@ , fontNames : %@", fontFamily, fontNames);
        }
        
    });
    
}

- (NSArray <TTFontName> *)getAllThirdFontNames {
    return @[
             TTFontNameChantalNormal,
             TTFontNameChantalBoldItalic,
             TTFontNameChantalMedium,
             TTFontNameChantalLightItalic,
             TTFontNameFilsonSoftLight,
             TTFontNameFilsonSoftBook,
             TTFontNameSFProTextRegular,
             ];
}

@end
