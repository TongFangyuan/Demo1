//
//  SettingViewController.m
//  Apple
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingModel.h"
#import "SettingsCell.h"
#import "ConnectedViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    
    // Do any additional setup after loading the view.
    [self initUI];

    [self getData];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingsCell.identifier forIndexPath:indexPath];
    [cell refreshCell:self.dataSource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingModel *item = self.dataSource[indexPath.row];
    if (item.vcCls) {
        BaseViewController *vc = [[item.vcCls alloc] initWithTabTitle:item.vcTitle TabbarHidden:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

////取消配对
//-(void)cancelAddAction:(UIButton *)sender{
//
//    [self showHudInView:self.view hint:@"正在取消配对..."];
//    [[BleTool shareManeger] disconnectPeripheral:self.deviceModel.peripheral Block:^(void){
//        [self hideHud];
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark -
- (void)initUI
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    self.tableView = tableview;
    [self.tableView registerClass:SettingsCell.class forCellReuseIdentifier:SettingsCell.identifier];
}
#pragma mark -
- (void)getData
{
    Application *app = [Application theApp];
    SettingModel *item1 = [[SettingModel alloc] initWithText:@"打印机连接" detailText:@"未连接" vcCls:ConnectedViewController.class vcTitle:@"连接设备"];
    
    SettingModel *item2 = [[SettingModel alloc] initWithText:@"当前版本号" detailText:[app appVersion]];
    item2.accessoryType = UITableViewCellAccessoryNone;
    
    self.dataSource = @[item1,item2];
}

@end
