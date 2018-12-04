//
//  NearEquipmentCell.h
//  HelloWord
//
//  Created by TY on 16/6/2.
//  Copyright © 2016年 008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearEquipmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
