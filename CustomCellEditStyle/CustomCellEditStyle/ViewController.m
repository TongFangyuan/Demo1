//
//  ViewController.m
//  CustomCellEditStyle
//
//  Created by Tong on 2019/9/10.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import "ViewController.h"
#import "UITableViewCell+TTEditStyle.h"
#import "UITableView+TTEditStyle.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configStyle];
    
}
#pragma mark - ------------- 样式配置 ------------------
- (void)configStyle {
    UITableViewCellEditButtonStyle *style = [UITableViewCellEditButtonStyle new];
    style.font = [UIFont systemFontOfSize:12.f];
    style.backgroundColor = [UIColor colorWithRed:0.76 green:0.15 blue:0.09 alpha:1.00];
    [UITableViewCell tt_registerStyle:style forActionTitle:@"删除"];
    
    UITableViewCellEditButtonStyle *style1 = [UITableViewCellEditButtonStyle new];
    style1.font = [UIFont systemFontOfSize:0.f];
    style1.backgroundColor = [UIColor grayColor];
    style1.image = [UIImage imageNamed:@"play_ic"];
    [UITableViewCell tt_registerStyle:style1 forActionTitle:@"播放"];
    
    UITableViewCellEditButtonStyle *style2 = [UITableViewCellEditButtonStyle new];
    style2.font = [UIFont systemFontOfSize:10.f];
//    style2.backgroundImage = [UIImage imageNamed:@"electricity_80"];
    style2.image = [UIImage imageNamed:@"electricity_80"];
    style2.textColor = [UIColor colorWithRed:0.76 green:0.15 blue:0.09 alpha:1.00];
    style2.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    style2.imageEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    [UITableViewCell tt_registerStyle:style2 forActionTitle:@"电量"];
    
}

#pragma mark - tableView 代理
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return 60;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return 1;
 }
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 20;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
     if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
     }
     cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section];
     cell.backgroundColor = [UIColor clearColor];
     return cell;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    }];
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"播放" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    }];
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"电量" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    }];
    return @[action0,action1,action2];
}


@end
