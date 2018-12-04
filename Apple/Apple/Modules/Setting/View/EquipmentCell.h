//
//  EquipmentCell.h
//  HelloWord
//
//  Created by TY on 16/6/2.
//  Copyright © 2016年 008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end
