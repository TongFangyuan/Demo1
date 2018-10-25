//
//  SettingsCell.h
//  Apple
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"
@interface SettingsCell : UITableViewCell

- (void)refreshCell:(SettingModel *)item;

+ (NSString *)identifier;

@end
