//
//  ViewController.m
//  FontDemo
//
//  Created by Tong on 2019/7/19.
//  Copyright © 2019 Tongfy. All rights reserved.
//

#import "ViewController.h"
#import "TTFontTool.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSArray arrayWithArray:TTFontTool.shareTool.getAllThirdFontNames];
    [TTFontTool.shareTool printAllFonts];
}

#pragma mark - tableView 代理

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return 80;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.dataArray.count;
 }

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     if (!cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
         cell.detailTextLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
         cell.detailTextLabel.textColor = [UIColor lightGrayColor];
     }
     cell.textLabel.text = @"TTFont";
     TTFontName name = self.dataArray[indexPath.row];
     cell.textLabel.font = [UIFont tt_fontWithName:name size:35.f];
     cell.detailTextLabel.text = name;
     return cell;
 }
 

 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
 {
     return CGFLOAT_MIN;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
     return CGFLOAT_MIN;
 }
 
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
 {
     return nil;
 }
 
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
     return nil;
 }
 


@end
