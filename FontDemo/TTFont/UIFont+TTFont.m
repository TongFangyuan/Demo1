//
//  UIFont+TTFont.m
//  FontDemo
//
//  Created by Tong on 2019/7/19.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import "UIFont+TTFont.h"

TTFontName const TTFontNameChantalNormal = @"CHANTAL-Normal";
TTFontName const TTFontNameChantalMedium = @"ChantalMedium";
TTFontName const TTFontNameChantalBoldItalic = @"ChantalBoldItalic";
TTFontName const TTFontNameChantalLightItalic = @"ChantalLightItalic";

TTFontName const TTFontNameFilsonSoftLight = @"FilsonSoft-Light";
TTFontName const TTFontNameFilsonSoftBook  = @"FilsonSoftBook";

TTFontName const TTFontNameSFProTextRegular = @"SFProText-Regular";

@implementation UIFont (TTFont)

+ (UIFont *)tt_fontWithName:(TTFontName)fontName size:(CGFloat)fontSize {
    return [UIFont fontWithName:fontName size:fontSize];
}

@end
