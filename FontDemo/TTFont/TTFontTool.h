//
//  TTFontTool.h
//  FontDemo
//
//  Created by Tong on 2019/7/19.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIFont+TTFont.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTFontTool : NSObject

+ (nonnull instancetype)shareTool;

/** 打印所有字体信息，用来调试 */
- (void)printAllFonts;


/** 获取所有第三方字体名称 */
- (NSArray <TTFontName> *)getAllThirdFontNames;

@end

NS_ASSUME_NONNULL_END
