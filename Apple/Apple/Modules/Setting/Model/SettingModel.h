//
//  SettingModel.h
//  Apple
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, copy) Class vcCls;
@property (nonatomic, copy) NSString *vcTitle;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *detaiTextColor;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, strong) UIFont *font;

- (instancetype)initWithText:(NSString *)text
                  detailText:(NSString *)detailText;

- (instancetype)initWithText:(NSString *)text
                  detailText:(NSString *)detailText
                       vcCls:(Class )vcCls
                     vcTitle:(NSString *)vcTitle;

@end
