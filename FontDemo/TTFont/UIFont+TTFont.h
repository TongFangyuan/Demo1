//
//  UIFont+TTFont.h
//  FontDemo
//
//  Created by Tong on 2019/7/19.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString * TTFontName;

#pragma mark - Chantal 字体
extern TTFontName const TTFontNameChantalNormal;
extern TTFontName const TTFontNameChantalMedium;
extern TTFontName const TTFontNameChantalBoldItalic;
extern TTFontName const TTFontNameChantalLightItalic;

#pragma mark - Filson Soft 字体
extern TTFontName const TTFontNameFilsonSoftLight;
extern TTFontName const TTFontNameFilsonSoftBook;

#pragma mark - SFProText 字体
extern TTFontName const TTFontNameSFProTextRegular;

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (TTFont)

+ (UIFont *)tt_fontWithName:(TTFontName)fontName size:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
