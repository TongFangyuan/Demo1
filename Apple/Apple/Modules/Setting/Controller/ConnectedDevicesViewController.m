//
//  ConnectedDevicesViewController.m
//  HelloWord
//
//  Created by TY on 16/5/30.
//  Copyright © 2016年 008. All rights reserved.
//

#import "ConnectedDevicesViewController.h"
#import "EquipmentCell.h"
#import "NearEquipmentCell.h"
#import "BleDevice.h"
#import "SettingViewController.h"
@interface ConnectedDevicesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,strong) NSMutableArray *connectedArr;//已配对设备
@property (nonatomic,strong) NSMutableArray *nonConnectedArr;//未连接设备
@end
@implementation ConnectedDevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView:) name:kBLEDeviceConnectedOK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView:) name:kBLEDeviceLostNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView:) name:kBLEDeviceInfoModified object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView:) name:kDiscovedDeviceChanged object:nil]; 
    
    
    self.connectedArr = [NSMutableArray array];
    self.nonConnectedArr = [NSMutableArray array];
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableview = tableview;
    [self.view addSubview:tableview];
    
    // 底部
    UIView *bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 69, self.view.frame.size.width, 69)];
    bottomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomview];
    UIButton *keyAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    keyAdd.frame = CGRectMake((kScreenWidth - 105)/2.0, (69-38)/2.0, 105, 38);
    keyAdd.layer.cornerRadius = 7;
    [keyAdd setTitle:@"一键连接" forState:UIControlStateNormal];
    [keyAdd addTarget:self action:@selector(keyAddAction:) forControlEvents:UIControlEventTouchUpInside];
    keyAdd.backgroundColor = kBgColor;
    [bottomview addSubview:keyAdd];
    [self.tableview reloadData];
    
    [self refreshAction:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"refresh"];
    rightBtn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [rightBtn setImage:img forState:UIControlStateNormal];
    [self setNavigationBarRightView:rightBtn];
    [rightBtn addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    UILabel *sectionName = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 44)];
    
    if (section == 0) {
        sectionName.text = @"已配对设备";
    } else {
        sectionName.text = @"附近的设备";
        UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 0, 44, 44)];
        activity.activityIndicatorViewStyle =UIActivityIndicatorViewStyleGray;
        self.activity = activity;
        [view addSubview:activity];
    }
    [view addSubview:sectionName];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.connectedArr.count;
    }
    return self.nonConnectedArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BleDevice *model = [[BleDevice alloc]init];
        model = self.connectedArr[indexPath.row];
        static NSString *ID = @"EquipmentCell";
        EquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            NSArray *xib = [[NSBundle mainBundle]loadNibNamed:ID owner:self options:nil];
            cell = [xib objectAtIndex:0];
        }
        
        cell.deviceName.text = model.deviceName;
        cell.icon.image = [UIImage imageNamed:@"info"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        BleDevice *model = [[BleDevice alloc]init];
        model = self.nonConnectedArr[indexPath.row];
        static NSString *ID = @"NearEquipmentCell";
        NearEquipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            NSArray *xib = [[NSBundle mainBundle]loadNibNamed:ID owner:self options:nil];
            cell = [xib objectAtIndex:0];
        }
        cell.indicator.hidden = YES;
        cell.name.text = model.deviceName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//修改设备
        BleDevice *model = [[BleDevice alloc]init];
        model = self.connectedArr[indexPath.row];
        
        SettingViewController * settingsViewController = [[SettingViewController alloc]initWithTabTitle:@"设置" TabbarHidden:YES];
        settingsViewController.deviceModel = model;
        [self.navigationController pushViewController:settingsViewController animated:YES];
        
        
    } else {
        BleDevice *model = [[BleDevice alloc]init];
        if (self.nonConnectedArr.count && (indexPath.row < self.nonConnectedArr.count)) {
            model = self.nonConnectedArr[indexPath.row]; 
            
            //连接设备
            NearEquipmentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.indicator.hidden = NO;
            cell.status.hidden = YES;
            [cell.indicator startAnimating];
            
            double delayInSeconds = 15;
            dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.indicator.hidden = YES;
                    cell.status.hidden = NO;
                    [cell.indicator stopAnimating];
                });
            });
            [[BleTool shareManeger] connectPeripheral:model.peripheral];
        }

    }
}


#pragma mark - 一键连接
-(void)keyAddAction:(UIButton *)sender{
    for (int i = 0; i<self.nonConnectedArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        NearEquipmentCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
        cell.indicator.hidden = NO;
        cell.status.hidden = YES;
        [cell.indicator startAnimating];

        double delayInSeconds = 15;
        dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.indicator.hidden = YES;
                cell.status.hidden = NO;
                [cell.indicator stopAnimating];
            });
        });
        
        BleDevice *model = [[BleDevice alloc]init];
        model = self.nonConnectedArr[indexPath.row];
        [[BleTool shareManeger] connectPeripheral:model.peripheral];
    }
}

//refresh
-(void)refreshAction:(UIButton *)sender{
   // [self refresh];
    [self.activity startAnimating];
    [[BleTool shareManeger] scanBLEPeripheralsWithTimeout:3.0 Block:^(NSMutableArray *peripherals){
        [self.activity stopAnimating];
        [self updateTableView:nil];
    }];
}

-(void)updateTableView:(NSNotification *)noti{
    self.nonConnectedArr = [BleTool shareManeger].peripherals;
    self.connectedArr = [BleTool shareManeger].connectedPeripherals;
    [self.tableview reloadData];

    if ([noti.name isEqualToString:kBLEDeviceConnectedOK ]) {
        /////////////////////////  同步时间
        NSMutableArray *dataArr = [NSMutableArray array];
        dataArr = [BleTool shareManeger].connectedPeripherals;
        for (int i = 0; i < dataArr.count; i++) {
            BleDevice *model = dataArr[i];
            
            
        }
    }
}

#pragma mark -刷新界面
-(void)refresh{
    [self.activity startAnimating];
    double delayInSeconds = 3.5;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
            [self updateTableView:nil];
        });
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
