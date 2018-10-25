//
//  SettingsCell.m
//  Apple
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)refreshCell:(SettingModel *)model {
    self.textLabel.text = model.title;
    NSLog(@"title %@ detal %@",model.title,model.detailTitle);
    self.detailTextLabel.text = model.detailTitle;
    self.accessoryType = model.accessoryType;
    self.textLabel.textColor = model.textColor;
    self.detailTextLabel.textColor = model.detaiTextColor;
    self.selectionStyle = model.selectionStyle;
    self.textLabel.font = model.font;
    self.detailTextLabel.font = model.font;
}

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
