//
//  ConnectedViewController.m
//  Apple
//
//  Created by admin on 2018/10/26.
//  Copyright © 2018年 tongfy. All rights reserved.
//

#import "ConnectedViewController.h"
#import "EquipmentCell.h"
#import "NearEquipmentCell.h"

@interface ConnectedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView    *tableview;
@property (nonatomic,strong) UIButton       *bottomButton;
@property (nonatomic,strong) UIButton       *refreshButton;

@property (nonatomic,strong) NSMutableArray *connectedArr;//已配对设备
@property (nonatomic,strong) NSMutableArray *nonConnectedArr;//未连接设备

@end

@implementation ConnectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomButton];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-88);
        make.left.equalTo(self.view).offset(15);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(48);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectedDevice) name:kBLEDeviceConnectedOK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:kBLEDeviceLostNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:kBLEDeviceInfoModified object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:kDiscovedDeviceChanged object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];
    if (![BleTool shareManeger].connectedPeripherals.count) {
        [self refreshAction:nil];
    } else {
        [self refreshTableView:nil];
    }
}


#pragma mark - tableView 代理
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    UILabel *sectionName = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 44)];
    sectionName.textColor = kColor(51, 51, 51);
    sectionName.font = [UIFont boldSystemFontOfSize:15.0f];
    
    if (section == 0) {
        sectionName.text =  NSLocalizedString(@"已连接设备", nil);
    } else {
        sectionName.text =NSLocalizedString(@"其他设备", nil) ;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {//修改设备
        
        BleDevice *model = [[BleDevice alloc]init];
        model = self.connectedArr[indexPath.row];
        
    } else {
        BleDevice *model = [[BleDevice alloc]init];
        if (self.nonConnectedArr.count && (indexPath.row < self.nonConnectedArr.count)) {
            model = self.nonConnectedArr[indexPath.row];
            
            if ([BleTool shareManeger].connectedPeripherals.count>=1) {
                [TTErrorView tt_showError:@"只能连接一个设备" onView:self.view];
                return;
            }
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


#pragma mark - event response
-(void)refreshAction:(UIButton *)sender{
    
    self.refreshButton.userInteractionEnabled = NO;
    [self startAnimatingRefreshButton];
    
    __weak typeof(self) weakSelf = self;
    [[BleTool shareManeger] scanBLEPeripheralsWithTimeout:3.0 Block:^(NSMutableArray *peripherals){
        NSLog(@"扫描到设备：%@",peripherals);
        [weakSelf stopAnimatingRefreshButton];
        weakSelf.refreshButton.userInteractionEnabled = YES;
        [weakSelf refreshTableView:nil];
        
    }];
}

- (void)disconnectedDevices
{
    for (BleDevice *device in self.connectedArr) {
        [[BleTool shareManeger] disconnectPeripheral:device.peripheral Block:nil];
    }
}
- (void)didConnectedDevice
{
    [self refreshTableView:nil];
}

#pragma mark - private methods
- (void)refreshTableView:(NSNotification *)noti
{
    self.nonConnectedArr = [BleTool shareManeger].peripherals;
    self.connectedArr = [BleTool shareManeger].connectedPeripherals;
    [self.tableview reloadData];
    if (self.connectedArr.count) {
        self.bottomButton.backgroundColor = [UIColor colorWithRed:0.08 green:0.42 blue:0.71 alpha:1.00];
        self.bottomButton.enabled = YES;
    } else {
        self.bottomButton.backgroundColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00];
        self.bottomButton.enabled = NO;
    }
    
}
// 开始动画
- (void)startAnimatingRefreshButton
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.25f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1000;
    [self.refreshButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
// 结束动画
- (void)stopAnimatingRefreshButton
{
    [self.refreshButton.layer removeAnimationForKey:@"rotationAnimation"];
}

#pragma mark - getters and setters
- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (NSMutableArray *)connectedArr
{
    if (!_connectedArr) {
        _connectedArr = [NSMutableArray array];
    }
    return _connectedArr;
}

- (NSMutableArray *)nonConnectedArr
{
    if (!_nonConnectedArr) {
        _nonConnectedArr = [NSMutableArray array];
    }
    return _nonConnectedArr;
}

- (UIButton *)bottomButton
{
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.backgroundColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00];
        _bottomButton.layer.cornerRadius = 4.0f;
        _bottomButton.titleLabel.font = kFont(16.0f);
        [_bottomButton setTitle:NSLocalizedString(@"断开已连接的设备", nil) forState:UIControlStateNormal];
        [_bottomButton addTarget:self action:@selector(disconnectedDevices) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}
- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setImage:[UIImage imageNamed:@"9.刷新"] forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
        [_refreshButton sizeToFit];
    }
    return _refreshButton;
}
@end
