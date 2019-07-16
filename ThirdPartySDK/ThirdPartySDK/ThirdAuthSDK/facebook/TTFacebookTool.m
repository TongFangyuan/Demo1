//
//  TTFacebookTool.m
//  ThirdPartySDK
//
//  Created by Tong on 2019/7/16.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import "TTFacebookTool.h"

@implementation TTFacebookTool

+ (nonnull instancetype)shareTool {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
