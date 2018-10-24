//
//  SettingViewController.m
//  Apple
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    // 底部
    UIView *bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 69, self.view.frame.size.width, 69)];
    bottomview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomview];
    UIButton *cancelAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelAdd.frame = CGRectMake((kScreenWidth - 105)/2.0, (69-38)/2.0, 105, 38);
    cancelAdd.layer.cornerRadius = 7;
    [cancelAdd setTitle:@"取消配对" forState:UIControlStateNormal];
    [cancelAdd addTarget:self action:@selector(cancelAddAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelAdd.backgroundColor = kMainColor;
    [bottomview addSubview:cancelAdd];
    tableview.tableFooterView = bottomview;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingcell"];
    UITextField *name = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth - 15, 44)];
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = kBlackBgColor;
    [cell addSubview:name];
    
    name.text = self.deviceModel.deviceName;
    
    name.delegate = self;
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];// 放弃第一响应者
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    self.deviceModel.deviceName = textField.text;
    [BleDbTool insertOrModifyBleDeviceWithModel:_deviceModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDeviceInfoModified object:nil];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location > 20)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}

//取消配对
-(void)cancelAddAction:(UIButton *)sender{
    
    [self showHudInView:self.view hint:@"正在取消配对..."];
    [[BleTool shareManeger] disconnectPeripheral:self.deviceModel.peripheral Block:^(void){
        [self hideHud];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

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

@end
