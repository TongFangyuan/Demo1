//
//  SettingModel.m
//  Apple
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel

- (instancetype)init
{
    if (self=[super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.textColor = UIColor.blackColor;
        self.detaiTextColor = UIColor.blackColor;
        
        self.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text detailText:(NSString *)detailText
{
    if (self = [super init]) {
        self.title = text;
        self.detailTitle = detailText;
    }
    return [self init];
}

- (instancetype)initWithText:(NSString *)text
                  detailText:(NSString *)detailText
                       vcCls:(Class)vcCls
                     vcTitle:(NSString *)vcTitle
{
    if (self = [super init]) {
        self.title = text;
        self.vcCls = vcCls;
        self.vcTitle = vcTitle;
    }
    return [self init];
}

@end
