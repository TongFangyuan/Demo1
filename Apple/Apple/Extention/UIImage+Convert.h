//
//  UIImage+Convert.h
//  JFBCoordinate
//
//  Created by wu qingqing on 13-6-19.
//  Copyright (c) 2013年 wu qingqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Convert)

+ (UIImage *) createImageWithColor: (UIColor *) color;
+(UIImage *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize;

+( UIImage *)getEllipseImageWithImage:( UIImage *)originImage;

@end
