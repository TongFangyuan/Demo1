
#import "BleTool.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define kDisconnectFromLocalTag             9999

@interface BleTool() <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager    *CM;
    NSMutableDictionary *re_connect_task;      //重连时间点管理
    NSMutableDictionary *dis_connect_task;     //断开时间点管理
    NSMutableDictionary *suc_connect_task;     //连接时间点管理
    NSMutableDictionary *rssi_infos_task;      //RSSI更新信息管理
    DisConnectBleBlock disConnBlock;
    NSMutableArray *tmpPeripheralInfo;
    
    ////////////各特征写入相关信息定义
    BleResponseBlock responseBlock;
    RequestLabelHeightGapBlock requestLabelHeightGapBlock;
    NSMutableDictionary *ledColorCharistcRepsTypeInfo;
}

@end

@implementation BleTool

+ (instancetype)shareManeger{
    static BleTool *maneger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maneger = [[self alloc] init];
    });
    return maneger;
}

- (id) init {
    
    if(self = [super init]) {
        re_connect_task = [NSMutableDictionary dictionary];
        rssi_infos_task = [NSMutableDictionary dictionary];
        dis_connect_task = [NSMutableDictionary dictionary];
        suc_connect_task = [NSMutableDictionary dictionary];
        ledColorCharistcRepsTypeInfo = [NSMutableDictionary dictionary];
        [self controlSetup];
    }
    return self;
}

#pragma mark -------------------common----------------------------
- (void) controlSetup
{
    CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}
 
-(NSString *) CBUUIDToString:(CBUUID *) cbuuid;
{
    NSData *data = cbuuid.data;
    if ([data length] == 2) {
        const unsigned char *tokenBytes = [data bytes];
        return [NSString stringWithFormat:@"%02x%02x", tokenBytes[0], tokenBytes[1]];
    }
    else if ([data length] == 16) {
        NSUUID* nsuuid = [[NSUUID alloc] initWithUUIDBytes:[data bytes]];
        return [nsuuid UUIDString];
    }
    return [cbuuid description];
}

- (BOOL) UUIDSAreEqual:(NSUUID *)UUID1 UUID2:(NSUUID *)UUID2
{
    if ([UUID1.UUIDString isEqualToString:UUID2.UUIDString])
        return TRUE;
    else
        return FALSE;
}

-(void) getAllServicesFromPeripheral:(CBPeripheral *)p
{
    [p discoverServices:nil]; // Discover all services without filter
}

-(void) getAllCharacteristicsFromPeripheral:(CBPeripheral *)p
{
    for (int i=0; i < p.services.count; i++)
    {
        CBService *s = [p.services objectAtIndex:i];
        [p discoverCharacteristics:nil forService:s];
    }
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2
{
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1 length:16];
    [UUID2.data getBytes:b2 length:16];
    if (memcmp(b1, b2, UUID1.data.length) == 0)
        return 1;
    else
        return 0;
}

-(UInt16) CBUUIDToInt:(CBUUID *) UUID
{
    char b1[16];
    [UUID.data getBytes:b1 length:16];
    return ((b1[0] << 8) | b1[1]);
}

-(CBUUID *) IntToCBUUID:(UInt16)UUID
{
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}

-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p
{
    for(int i = 0; i < p.services.count; i++)
    {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID])
            return s;
    }
    return nil;
}

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service
{
    for(int i=0; i < service.characteristics.count; i++)
    {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil;
}

-(void) readValue: (CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p
{
    CBService *service = [self findServiceFromUUID:serviceUUID p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:serviceUUID], p.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
    if (!characteristic)
    {
        NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:characteristicUUID], [self CBUUIDToString:serviceUUID], p.identifier.UUIDString);
        return;
    }
    [p readValueForCharacteristic:characteristic];
    [self dealResultByCharacteristic:characteristic Peripheral:p Error:nil Data:nil];
}

-(void) writeValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data WithResponse:(BOOL)withResp
{
    CBService *service = [self findServiceFromUUID:serviceUUID p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:serviceUUID], p.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:characteristicUUID], [self CBUUIDToString:serviceUUID], p.identifier.UUIDString);
        return;
    }
    if(withResp) {
        [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } else {
        [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        [self dealResultByCharacteristic:characteristic Peripheral:p Error:nil Data:data];
    }
}

- (const char *) centralManagerStateToString: (int)state
{
    switch(state)
    {
        case CBCentralManagerStateUnknown:
            return "State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return "State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return "State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return "State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return "State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return "State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return "State unknown";
    }
    return "Unknown state";
}

- (void) printKnownPeripherals
{
    NSLog(@"List of currently known peripherals :");
    for (int i = 0; i < self.peripherals.count; i++)
    {
        BleDevice *device = [self.peripherals objectAtIndex:i];
        CBPeripheral *p = device.peripheral;
        if (p.identifier != NULL) {
            NSLog(@"%d  |  %@", i, p.identifier.UUIDString);
        }
        else {
            NSLog(@"%d  |  NULL", i);
        }
        [self printPeripheralInfo:p];
    }
}

- (void) printPeripheralInfo:(CBPeripheral*)peripheral
{
    NSLog(@"------------------------------------");
    NSLog(@"Peripheral Info :");
    if (peripheral.identifier != NULL) {
        NSLog(@"UUID : %@", peripheral.identifier.UUIDString);
    }
    else {
        NSLog(@"UUID : NULL");
    }
    NSLog(@"Name : %@", peripheral.name);
    NSLog(@"-------------------------------------");
}




#pragma mark -------------------外部常用方法定义----------------------------
-(int) scanBLEPeripheralsWithTimeout:(int)timeout Block:(ScanBleBlock)block
{
    [CM stopScan];
    [self.peripherals removeAllObjects];
    if (CM.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"CoreBluetooth State = %d (%s)\r\n", (int)CM.state, [self centralManagerStateToString:CM.state]);
        return -2;
    }
    
    /*
     timeout小于0，实时扫描
     */
    if(timeout > 0) {
        double delayInSeconds = timeout;
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            dispatch_async(dispatch_get_main_queue(), ^{
                [CM stopScan];
                [self printKnownPeripherals];
                NSLog(@"Known peripherals : %lu", (unsigned long)[self.peripherals count]);
                if(block) {
                    block(_peripherals);
                }
            });
        });
    }
    
    NSArray *list = [CM retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceSearchUUID]]];
    for (CBPeripheral* peripheral in list) {
        if (peripheral != nil)
        {
            peripheral.delegate = self;
            [tmpPeripheralInfo addObject:peripheral];
            [self discoveredPeripheralWithPeripheral:peripheral RSSI:[NSNumber numberWithInt:0]];
            BOOL isLastConnected = [self judgePeripheralIsLastConnected:peripheral.identifier.UUIDString];
            if(!isLastConnected) continue;
            if (peripheral.state == CBPeripheralStateConnected) continue;
            [self connectPeripheral:peripheral];
        }
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [CM scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceSearchUUID]] options:options];
    NSLog(@"scanForPeripheralsWithServices");
    
    return 0;
}

- (void) connectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connecting to peripheral with UUID : %@", peripheral.identifier.UUIDString);
    [CM connectPeripheral:peripheral
                       options:@{CBConnectPeripheralOptionNotifyOnConnectionKey: @YES, CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES, CBConnectPeripheralOptionNotifyOnNotificationKey: @YES}];
}

-(void) disconnectPeripheral:(CBPeripheral *)peripheral Block:(DisConnectBleBlock)block {
    
    disConnBlock = block;
    if (peripheral.state == CBPeripheralStateConnected) {
        [peripheral setRowid:kDisconnectFromLocalTag];
        [CM cancelPeripheralConnection:peripheral];
    }
}

- (BOOL) judgeBLEPowerSwitchIsOn {
    return CM.state == CBManagerStatePoweredOn;
}

- (void) writeValue:(NSData *)data ServiceUUID:(NSString *)servcuuid CharactisUUID:(NSString *)charuuid Peripheral:(CBPeripheral *)peripheral WithResponse:(BOOL)withResp
{
//    NSLog(@"writeValue：%d", data.length);
    CBUUID *serviceUUID = [CBUUID UUIDWithString:servcuuid];
    CBUUID *charactisUUID = [CBUUID UUIDWithString:charuuid];
    [self writeValue:serviceUUID characteristicUUID:charactisUUID p:peripheral data:data WithResponse:withResp];
}


#pragma mark -------------------CBCentralManagerDelegate----------------------------
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Status of CoreBluetooth central manager changed %d (%s)", (int)central.state, [self centralManagerStateToString:central.state]);
    
    if (central.state != CBCentralManagerStatePoweredOn) {
        
        int count = (int)self.connectedPeripherals.count;
        while (count) {
            BleDevice *device = _connectedPeripherals[count-1];
            [self centralManager:CM didDisconnectPeripheral:device.peripheral error:nil];
            count = (int)self.connectedPeripherals.count;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kBLECBCentralManagerStatePoweredOff object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBLECBCentralManagerStatePoweredOn object:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if(peripheral.name.length <= 0) return;
    NSArray *peripherals = [NSArray arrayWithObjects:peripheral, nil];
    [self judgeAndReConnectDevices:peripherals];
    NSLog(@"didDiscoverPeripheral");
}

//////// 判断并重连设备
- (void) judgeAndReConnectDevices:(NSArray *)devices {
    
    NSArray *autoperiPherals;
    for(CBPeripheral *peripheral in devices) {
        BOOL isLastCounnected = [self judgePeripheralIsLastConnected:peripheral.identifier.UUIDString];
        if(isLastCounnected) {
            NSArray *uuids = [NSArray arrayWithObjects:peripheral.identifier, nil];
            NSArray *devs = [CM retrievePeripheralsWithIdentifiers:uuids];
            if(devs.count >= 1) {
                autoperiPherals = [NSArray arrayWithObjects:devs[0], nil];
            } else {
                autoperiPherals = [NSArray arrayWithObjects:peripheral, nil];
            }
        }
    }
    if(autoperiPherals.count>0) {
        for (int i =0; i<autoperiPherals.count; i++) {
            CBPeripheral* peripheral = autoperiPherals[i];
            if (peripheral != nil)
            {
                peripheral.delegate = self;
                [tmpPeripheralInfo addObject:peripheral];
                [self discoveredPeripheralWithPeripheral:peripheral RSSI:[NSNumber numberWithInt:0]];
                [self connectPeripheral:peripheral];
            }
        }
    } else {
        for(CBPeripheral *per in devices) {
            [self discoveredPeripheralWithPeripheral:per RSSI:[NSNumber numberWithInt:0]];
        }
    }
}

//////// 判断是否是上次连接成功的设备
- (BOOL) judgePeripheralIsLastConnected:(NSString *)uuidString {
    BOOL found = NO;
    NSArray *devices = [BleDevice getAllConnectedDevicesFromDB];
    for (BleDevice *device in devices) {
        if (!device.isConnected) continue;
        if([device.deviceUUID isEqualToString:uuidString]) {
            found = YES; break;
        }
    }
    return found;
}
- (void) discoveredPeripheralWithPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI {
    
    if(peripheral.state == CBPeripheralStateConnected) return;
    
    BleDevice *device = nil;
    NSArray *historyDevices = [BleDevice getAllConnectedDevicesFromDB];
    
    for (BleDevice *dv in historyDevices) {
        if ([dv.deviceUUID isEqual:peripheral.identifier.UUIDString]) {
            dv.peripheral = peripheral;
            device = dv; break;
        }
    }
    if (!device) {
        device = [[BleDevice alloc] init];
        device.peripheral = peripheral;
        device.deviceUUID = peripheral.identifier.UUIDString;
        device.deviceName = peripheral.name;
        device.iconImageName = @"default_ble.png";
        device.lostLength = 3; //默认开启最远
        device.alertIsOn = YES;//默认开启报警
        device.rssi = RSSI;
    }
    
    ////// 距离
    int a = abs([RSSI intValue]);
    CGFloat ci = (a - 60) / (10 * 5.0);
    NSString *distance = [NSString stringWithFormat:@"%.1f",pow(10,ci)];
    device.distance = [distance floatValue];
    device.isConnected = NO;
    [BleDevice insertOrModifyBleDeviceWithModel:device];
    
    if (!self.peripherals) {
        self.peripherals = [[NSMutableArray alloc] initWithObjects:device,nil];
    }
    else {
        ///////加入未连接队列
        BOOL contains = NO;
        for(int i = 0; i < self.peripherals.count; i++) {
            
            BleDevice *dv = [self.peripherals objectAtIndex:i];
            CBPeripheral *p = dv.peripheral;
            if ((p.identifier == NULL) || (peripheral.identifier == NULL))
                continue;
            if ([self UUIDSAreEqual:p.identifier UUID2:peripheral.identifier])
            {
                [self.peripherals replaceObjectAtIndex:i withObject:device];
                contains = YES;
            }
        }
        if(!contains) {
            [self.peripherals addObject:device];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kDiscovedDeviceChanged object:device];
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //如果连接数超过1个，断开连接
    if(self.connectedPeripherals.count >= 1) {
        [self disconnectPeripheral:peripheral Block:^(void){}];
    }
    
    ///////连接成功，加入连接队列
    NSString *uuid = peripheral.identifier.UUIDString;
    long long timeSince1970 = [[NSDate date] timeIntervalSince1970];
    NSString *time_str = [NSString stringWithFormat:@"%lli", timeSince1970];
    [suc_connect_task setObject:time_str forKey:uuid];
    
    
    if (!_connectedPeripherals) {
        self.connectedPeripherals = [NSMutableArray arrayWithCapacity:0];
    }
    BleDevice *device = nil;
    NSArray *historyDevices = [BleDevice getAllConnectedDevicesFromDB];
    for (BleDevice *dv in historyDevices) {
        if ([dv.deviceUUID isEqual:peripheral.identifier.UUIDString]) {
            dv.peripheral = peripheral;
            device = dv;
            break;
        }
    }
    if (!device) {
        device = [[BleDevice alloc] init];
        device.peripheral = peripheral;
        device.deviceUUID = peripheral.identifier.UUIDString;
        device.deviceName = peripheral.name;
        device.iconImageName = @"default_ble.png";
        device.lostLength = 3; //默认开启最远
        device.alertIsOn = YES;//默认开启报警
        device.rssi = peripheral.RSSI;
    }
    //保存到数据库
    device.isConnected = YES;
    [BleDevice insertOrModifyBleDeviceWithModel:device];
    
    ///////加入已连接队列
    BOOL contains = NO;
    for(int i = 0; i < _connectedPeripherals.count; i++) {
        
        BleDevice *dv = [_connectedPeripherals objectAtIndex:i];
        CBPeripheral *p = dv.peripheral;
        if ((p.identifier == NULL) || (peripheral.identifier == NULL))
            continue;
        if ([self UUIDSAreEqual:p.identifier UUID2:peripheral.identifier])
        {
            [_connectedPeripherals replaceObjectAtIndex:i withObject:device];
            contains = YES;
        }
    }
    if(!contains) {
        [_connectedPeripherals addObject:device];
    }
    /////////从未连接队列中移除
    NSArray *deleteList = [NSArray array];
    for (BleDevice *dev in self.peripherals) {
        if ([dev.peripheral.identifier isEqual:device.peripheral.identifier]) {
            deleteList = [deleteList arrayByAddingObject:dev];
        }
    }
    if (deleteList) {
        [_peripherals removeObjectsInArray:deleteList];
    }
    
    double delayInSeconds = 1.0;
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ///////指定时间后，自动断开情况
            NSString *last_dis_time = dis_connect_task[uuid];
            long long timeSince1970 = [[NSDate date] timeIntervalSince1970];
            float diff = timeSince1970 - [last_dis_time longLongValue];
            NSLog(@"%f", diff);
            if(diff <= 1.0) return ;
            
            if (peripheral.identifier != NULL)
                NSLog(@"Connected to %@ successful", peripheral.identifier.UUIDString);
            else
                NSLog(@"Connected to NULL successful");
            
            [self printPeripheralInfo:peripheral];
            
            [peripheral discoverServices:@[[CBUUID UUIDWithString:kServiceFindUUID]]];
            peripheral.delegate = self;
            [peripheral readRSSI];
            [re_connect_task removeObjectForKey:uuid];
            
            //////延迟通知，让菊花滚动一段时间
            [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDeviceConnectedOK object:device];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBLENotificationConnectState object:@0];
        });
    });
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kBLENotificationConnectState object:@-1];
    });
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
{
    for (BleDevice *device in _connectedPeripherals) {
        if ([device.peripheral.identifier isEqual:peripheral.identifier]) {
            
            //////////非本地主动断开连接
            NSInteger rowid = peripheral.rowid;
            if(rowid != kDisconnectFromLocalTag) {
                
                float re_conn_time = 60*5;
                
                ///////断开成功，加入断开队列
                NSString *uuid = peripheral.identifier.UUIDString;
                long long timeSince1970 = [[NSDate date] timeIntervalSince1970];
                NSString *time_str = [NSString stringWithFormat:@"%lli", timeSince1970];
                [dis_connect_task setObject:time_str forKey:uuid];
                
                //////断开重连机制
                NSString *value = [re_connect_task objectForKey:uuid];
                if(value.length <= 0) {
                    value = [NSString stringWithFormat:@"%lli", timeSince1970];
                    [re_connect_task setObject:value forKey:uuid];
                }
                long long dist = timeSince1970 - [value longLongValue];
                if(dist > re_conn_time) {
                    
                    [peripheral setRowid:0];
                    [self disconnectCurrentDevice:device];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDeviceLostNoti object:device];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kBLENotificationConnectState object:@-1];
                    if(disConnBlock) {
                        disConnBlock();
                    }
                    [re_connect_task removeObjectForKey:uuid];
                    return;
                }
                
                /*
                 errorCode 0 防丢器长按关机／断开蓝牙－网络
                 errorCode 6 防丢器自发断开／防丢器拆电池
                 */
                int errorCode = (int)error.code;
                if(errorCode == 0) {
                }
                if(errorCode == 6 || errorCode == 10) {
                }
                [peripheral setRowid:0];
                [self disconnectCurrentDevice:device];
                [self connectPeripheral:device.peripheral]; 
                
                double delayInSeconds = 1.0;
                dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //////////上次连接成功到断开间隔太短，不弹框
                        NSString *value = [suc_connect_task objectForKey:uuid];
                        long long timeSince1970 = [[NSDate date] timeIntervalSince1970];
                        float dist = timeSince1970 - [value longLongValue];
                        if(dist > 1.0) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDeviceLostNoti object:device];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kBLENotificationConnectState object:@-1];
                            if(disConnBlock) {
                                disConnBlock();
                            }
                        }
                    });
                });
                
            } else {
                ///////手动断开，更新数据库
                device.isConnected = NO;
                [BleDevice insertOrModifyBleDeviceWithModel:device];
                
                //////////上次连接成功到断开间隔太短，不弹框
                [peripheral setRowid:0];
                [self disconnectCurrentDevice:device];
                NSString *uuid = peripheral.identifier.UUIDString;
                NSString *value = [suc_connect_task objectForKey:uuid];
                long long timeSince1970 = [[NSDate date] timeIntervalSince1970];
                float dist = timeSince1970 - [value longLongValue];
                if(dist > 1.0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDeviceLostNoti object:device];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kBLENotificationConnectState object:@-1];
                    if(disConnBlock) {
                        disConnBlock();
                    }
                }
            }
            break;
        }
    }
}

#pragma mark 断开连接处理
- (void) disconnectCurrentDevice:(BleDevice *)device {
    
    if([_connectedPeripherals containsObject:device]) {
        [_connectedPeripherals removeObject:device];
    }
    if (!device.isDelete) {
        ///////加入未连接队列
        BOOL contains = NO;
        for(int i = 0; i < self.peripherals.count; i++) {
            
            BleDevice *dv = [self.peripherals objectAtIndex:i];
            CBPeripheral *p = dv.peripheral;
            if ((p.identifier == NULL) || (device.peripheral.identifier == NULL))
                continue;
            if ([self UUIDSAreEqual:p.identifier UUID2:device.peripheral.identifier])
            {
                [self.peripherals replaceObjectAtIndex:i withObject:device];
                contains = YES;
            }
        }
        if(!contains) {
            [self.peripherals addObject:device];
        }
    }
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
//        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
//            NSLog(@"已发现服务下可用特征...");
//        }
        
//        NSLog(@"发现服务：%@下可用特征...",service.UUID);
        //// 订阅特征
        for (CBCharacteristic *characteristic in service.characteristics) {
            
            // 发现了可写的特征
            if ([characteristic.UUID.UUIDString isEqualToString:kPrinterWriteCharacteristicUUID]) {
                NSLog(@"发现可写特征: %@", characteristic.UUID.UUIDString);
            }
            
            // 发现了提供订阅的特征
            if ([characteristic.UUID.UUIDString isEqualToString:kPrinterNotifyIndicateCharacteristicUUID]) {
                NSLog(@"发现订阅特征: %@", characteristic.UUID.UUIDString);
                // 订阅特征
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            
//            NSLog(@"特征描述：%@",characteristic.description);
            if (characteristic.properties & CBCharacteristicPropertyNotify) {
//                NSLog(@"订阅特征：%@",characteristic.UUID);
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
        
    } else {
        NSLog(@"外围设备寻找特征过程中发生错误，错误信息：%@",error.localizedDescription);
    }
//    for (CBCharacteristic *characteristic in service.characteristics) {
//        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"已发现可用服务...");
    if (!error) {
        [self getAllCharacteristicsFromPeripheral:peripheral];
    } else {
        NSLog(@"外围设备寻找服务过程中发生错误，错误信息：%@",error.localizedDescription);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"收到特征更新通知...");
    if (error) {
        NSLog(@"更新通知状态时发生错误，错误信息：%@",error.localizedDescription);
    } else {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kPrinterWriteCharacteristicUUID]]) {
            if (characteristic.isNotifying) {
                if ((characteristic.properties & CBCharacteristicPropertyNotify) != 0) {
                    NSLog(@"已订阅打印机写入服务特征通知.");
                }
                if ((characteristic.properties & CBCharacteristicPropertyRead) != 0) {
                    [peripheral readValueForCharacteristic:characteristic];
                }
                if((characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) == 0) {
                    NSNumber *respsType = [NSNumber numberWithBool:YES];
                    [ledColorCharistcRepsTypeInfo setObject:respsType forKey:peripheral.identifier.UUIDString];
                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDeviceLedColorCharFound object:nil];

            }else{
                NSLog(@"已停止打印机写入服务");
            }
        }
//        NSLog(@"成功订阅特征：%@",characteristic);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    if (data == nil) {
        return;
    }
    Byte *testByte = (Byte *)[data bytes];

    NSString *result = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"ble发送的数据: %@", result);
    if ([result containsString:@"OK"]) {
        if (responseBlock) {
            responseBlock(nil);
        }
    } else if ([result containsString:@"AUTOP"]) {
        if (requestLabelHeightGapBlock) {
            requestLabelHeightGapBlock(result);
        }
    }
//    else {
//        if (responseBlock) {
//            responseBlock([NSError errorWithDomain:@"打印失败" code:0 userInfo:nil]);
//        }
//    }

}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    NSLog(@"收到特征写入成功...");
    if (error) {
        NSLog(@"特征写入时发生错误，错误信息：%@",error.localizedDescription);
    } else {
        [self dealResultByCharacteristic:characteristic Peripheral:peripheral Error:error Data:nil];
    }
}

#pragma mark 处理写入硬件后结果
- (void) dealResultByCharacteristic:(CBCharacteristic *)characteristic Peripheral:peripheral Error:(NSError *)error Data:(NSData *)data {
    
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kLedColorCharacteristicUUID]]){
//        if(ledColorConfigBlock) {
//            ledColorConfigBlock(error);
//        }
//    }
}

#pragma mark rssi
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    ///////前8次打点，根据过滤算法，求最精确距离
    NSString *uuid = peripheral.identifier.UUIDString;
    NSMutableDictionary *info = rssi_infos_task[uuid];
    int times = [info[@"times"] intValue];
    NSNumber *rssi = [peripheral RSSI];
    int rssi_value = abs([rssi intValue]);
    
    if(times > 0) {
        NSMutableArray *list = info[@"list"];
        [list addObject:[NSString stringWithFormat:@"%d", rssi_value]];
        [info setObject:list forKey:@"list"];
        [rssi_infos_task setObject:info forKey:uuid];
        NSLog(@"信号：%i--列表：%i--次数：%i", abs([rssi intValue]), (int)list.count, times);
        
        BOOL to_limit = times >= 8;
        if(!to_limit) return;
        rssi_value = [self caculateExactRSSIWithList:list];
    }
    if (!error) {
        NSLog(@"rssi %i", rssi_value);
        for (BleDevice *device in _connectedPeripherals) {
            if ([device.peripheral.identifier isEqual:peripheral.identifier]) {
                
                int a = rssi_value;
                CGFloat ci = (a - 60) / (10 * 5.0);
                NSString *distance = [NSString stringWithFormat:@"%.1f",pow(10,ci)];
                NSLog(@"%@",distance);
                device.rssi = [NSNumber numberWithInt:rssi_value];
                device.distance = [distance floatValue];
                if (device.lostLength==1) {
                    if (device.distance>3) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDistanceWarming object:device];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDeviceInfoModified object:device];
                    }
                } else if (device.lostLength==2){
                    if (device.distance>8) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDistanceWarming object:device];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDeviceInfoModified object:device];
                    }
                } else if(device.lostLength ==3){
                    if (device.distance>15) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDistanceWarming object:device];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDeviceInfoModified object:device];
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kBLEDeviceDistanceChanged object:device];
                break;
            }
        }
    } else{
        NSLog(@"读取rrsi失败:%@",[error description]);
    }
}

#pragma mark 计算准确的rssi值
/* 将前8次数据收集、分析、异常排除、再均匀显示 */
- (int) caculateExactRSSIWithList:(NSArray *)list {
    
    NSMutableDictionary *rbt_dic = [NSMutableDictionary dictionary];
    
    for(NSString *value in list) {
        int rssi_int = [value intValue];
        float rssi_m_10 = rssi_int / 10;
        int prefix = floor(rssi_m_10);
        NSString *prefix_str = [NSString stringWithFormat:@"%d", prefix];
        NSMutableArray *rssi_arr = [rbt_dic objectForKey:prefix_str];
        if(!rssi_arr) {
            rssi_arr = [NSMutableArray array];
        }
        [rssi_arr addObject:value];
        [rbt_dic setObject:rssi_arr forKey:prefix_str];
    }
    
    //////最频繁出现的点信息
    NSString *tmp_key = nil;
    int list_max_count = 0;
    for(NSString *key in rbt_dic.allKeys) {
        NSArray *list = rbt_dic[key];
        if(list.count > list_max_count) {
            tmp_key = key;
            list_max_count = (int)list.count;
        }
    }
    int total = 0;
    NSArray *exact_list = rbt_dic[tmp_key];
    for(NSString *value in exact_list) {
        total += [value intValue];
    }
    return total / exact_list.count;
}

#pragma mark 读取信号强弱指示
- (void) readPeripheralsRSSI {
    
    for(BleDevice *device in self.connectedPeripherals) {
        CBPeripheral *peripheral = device.peripheral;
        
        //////////rssi更新管理
        NSString *uuid = device.peripheral.identifier.UUIDString;
        NSMutableDictionary *info = rssi_infos_task[uuid];
        if(!info) {
            info = [NSMutableDictionary dictionary];
        }
        ///////////// 次数 列表
        int times = [info[@"times"] intValue];
        BOOL to_limit = times >= 8;
        times = !to_limit ? ++times : 1;
        NSString *time_str = [NSString stringWithFormat:@"%d", times];
        [info setObject:time_str forKey:@"times"];
        
        NSMutableArray *list = info[@"list"];
        if(!list || times<=1) {
            list = [NSMutableArray array];
            [info setObject:list forKey:@"list"];
        }
        /////////////保存
        [rssi_infos_task setObject:info forKey:uuid];
        //////////readRSSI
        [peripheral readRSSI];
    }
}

//#pragma mark -
//#pragma mark 获取标签的宽度和间隙
//- (void) requestWidthAndGapOfLabel:(CBPeripheral *)per block:(RequestLabelHeightGapBlock)block
//{
//    requestLabelHeightGapBlock = block;
//
//    NSMutableData *finalData = [NSMutableData data];
//    NSString *CMD = [NSString stringWithFormat:@"AUTOP\n"];
//    [finalData appendData:[CMD dataUsingEncoding:GBK_Encoding]];
//    [self writeData:finalData peripheral:per];
//}

//#pragma mark 打印
//- (void) printModel:(BPTemplate *)model peripheral:(CBPeripheral *)peripheral block:(BleResponseBlock)block
//{
////    [self test_textPrintWithPeripheral:peripheral text:@"" block:block];
////    return;
//
//    responseBlock = block;
//
////    BPTemplate *template = [BPTemplate fetchModelWithRowid:model.templateID];
//
//    /// 重置打印机
//    [self sendResetCMD:peripheral];
//
//    NSMutableData *finalData = [NSMutableData data];
//    int offset = model.xOffset*8;
//    int height = model.height*8;
//
//    /// 设置打印纸张大小（打印区域）的大小
//    NSString *INIT_PRINT_COMMOND_TEMPLATE = [NSString stringWithFormat:@"! %d %d %d %d %d\n",offset,200,200,height,model.printCount];
//    NSString *PAGE_WIDTH = [NSString stringWithFormat:@"PAGE-WIDTH %d\n", (int)model.width*8];
//    NSString *SET_TOF    = [NSString stringWithFormat:@"SET-TOF %d\n", (int)model.space*8];
//    NSData *initData = [INIT_PRINT_COMMOND_TEMPLATE dataUsingEncoding:GBK_Encoding];
//    NSData *page_width_data = [PAGE_WIDTH dataUsingEncoding:GBK_Encoding];
//    NSData *set_of_data = [SET_TOF dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:initData];
//    [finalData appendData:page_width_data];
//    [finalData appendData:set_of_data];
//
//    /// 设置浓度
//    NSString *CONTRAST_CMD  = [NSString stringWithFormat:@"CONTRAST %d\n",model.concentration];
//    NSData *contrasttData = [CONTRAST_CMD dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:contrasttData];
//
////    /// TONE
////    NSArray *datas = @[@"0",@"25",@"100",@"200"];
////    NSString * TONE_CMD = [NSString stringWithFormat:@"TONE %@\n",datas[model.concentration]];
////    NSData *toneData = [TONE_CMD dataUsingEncoding:GBK_Encoding];
////    [finalData appendData:toneData];
//
//    /// 打印数据拼接
//    [model.properties enumerateObjectsUsingBlock:^(id<BPProperty>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj respondsToSelector:@selector(encode)]) {
//            NSData *data = [obj encode];
//            [finalData appendData:data];
//            NSLog(@"[encode] %@->%lu",obj.class,(unsigned long)data.length);
//        } else {
//            NSLog(@"%@ 没有实现encode方法", NSStringFromClass(obj.class));
//        }
//    }];
//
////    /// 打印图形
//////    UIImage *image = model.snapshot;
////////    UIImage *blackWhiteImage = [image tt_blackWhite];
//////    UIImage *newImage = [image tt_scaleImageToWidth:(model.width-model.xOffset)*8];
//////
//////    NSString *image_hex = [UIImage tt_picToBitmbp:newImage];
//////    NSInteger hei = newImage.size.height;
//////    NSInteger wid = newImage.size.width;
////
////    UIImage *image = model.snapshot;
////    NSString *image_hex = model.snapshot_hex;
////    if (!image_hex) {
////        image_hex = [UIImage tt_picToBitmbp:image];
////    }
////    NSInteger hei = image.size.height;
////    NSInteger wid = image.size.width;
////
////    if (wid % 8 > 0) {
////        wid = wid / 8;
////    }else{
////        wid = wid / 8 - 1;
////    }
////
////    hei = image_hex.length/(wid*2);
////
////    NSString *IMAGE_CMD = [NSString stringWithFormat:@"EG %ld %ld 0 0 %@\r\n",(long)wid,(long)hei,image_hex];
////
////    NSData *image_data = [IMAGE_CMD dataUsingEncoding:GBK_Encoding];
////    [finalData appendData:image_data];
//
//    /// FORM 命令
////    if (model.isPaging) {
////        [finalData appendData:[self formCMDData]];
////    }
//    [finalData appendData:[self formCMDData]];
//
//    /// PRINT 命令
//    [finalData appendData:[self printCMDData]];
//
//    NSString *cpcl_cmd = [[NSString alloc] initWithData:finalData encoding:GBK_Encoding];
//    NSLog(@"CPCL数据指令：\n%@",cpcl_cmd);
//    [self writeData:finalData peripheral:peripheral];
//
//}
///** 发送重置指令 */
//- (void) sendResetCMD:(CBPeripheral *)peripheral {
////    Byte reset[] = {0x1B, 0x40};
////    NSData *data = [NSData dataWithBytes:reset length:sizeof(reset)];
////    [self writeValue:data ServiceUUID:kServiceFindUUID CharactisUUID:kPrinterWriteCharacteristicUUID Peripheral:peripheral WithResponse:CBCharacteristicWriteWithResponse];
//}
///** 换行符数据 */
//- (NSData *) enterCMDData
//{
//    return [@"\n" dataUsingEncoding:GBK_Encoding];
//}
///** form数据 */
//- (NSData *) formCMDData
//{
//    return [@"FORM\n" dataUsingEncoding:GBK_Encoding];
//}
///** 打印指令数据 */
//- (NSData *) printCMDData
//{
//    return [@"PRINT\n" dataUsingEncoding:GBK_Encoding];
//}

#pragma mark - 发送数据
- (void)writeData:(NSData *)data peripheral:(CBPeripheral *)peripheral
{
    /// 不分包
    BOOL withResponse = [[ledColorCharistcRepsTypeInfo objectForKey:peripheral.identifier.UUIDString] boolValue];
    [self writeValue:data ServiceUUID:kServiceFindUUID CharactisUUID:kPrinterWriteCharacteristicUUID Peripheral:peripheral WithResponse:NO];
    return;
    
    NSUInteger limitLength = 20;
    // iOS 9 以后，系统添加了这个API来获取特性能写入的最大长度
    if ([peripheral respondsToSelector:@selector(maximumWriteValueLengthForType:)]) {
        limitLength = [peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithResponse];
    }
    NSLog(@"=====limitLength:%ld",limitLength);
    if(data.length > limitLength) {
        NSUInteger i = 0;
        while ((i + 1) * limitLength <= data.length) {
            //            注意：每个打印机都有一个缓冲区，缓冲区的大小视品牌型号有所不同。打印机的打印速度有限，如果我们瞬间发送大量的数据给打印机，会造成打印机缓冲区满。缓冲区满后，如继续写入，可能会出现数据丢失，打印乱码。
            [NSThread sleepForTimeInterval:0.002];
            NSData *dataSend = [data subdataWithRange:NSMakeRange(i * limitLength, limitLength)];
            BOOL withResponse = [[ledColorCharistcRepsTypeInfo objectForKey:peripheral.identifier.UUIDString] boolValue];
            [self writeValue:dataSend ServiceUUID:kServiceFindUUID CharactisUUID:kPrinterWriteCharacteristicUUID Peripheral:peripheral WithResponse:withResponse];
            i++;
        }
        i = data.length % limitLength;
        if(i > 0)
        {
            NSData *dataSend = [data subdataWithRange:NSMakeRange(data.length - i, i)];
            BOOL withResponse = [[ledColorCharistcRepsTypeInfo objectForKey:peripheral.identifier.UUIDString] boolValue];
            [self writeValue:dataSend ServiceUUID:kServiceFindUUID CharactisUUID:kPrinterWriteCharacteristicUUID Peripheral:peripheral WithResponse:withResponse];
            
        }
        
    }else {
        BOOL withResponse = [[ledColorCharistcRepsTypeInfo objectForKey:peripheral.identifier.UUIDString] boolValue];
        [self writeValue:data ServiceUUID:kServiceFindUUID CharactisUUID:kPrinterWriteCharacteristicUUID Peripheral:peripheral WithResponse:withResponse];
    }
}

//#pragma mark - 测试
//
//- (void) test_textPrintWithPeripheral:(CBPeripheral *)peripheral text:(NSString *)text block:(BleResponseBlock)block
//{
//    responseBlock = block;
//
//    /// 重置打印机
//    Byte reset[] = {0x1B, 0x40};
//    NSData *data = [NSData dataWithBytes:reset length:sizeof(reset)];
//    [self writeValue:data ServiceUUID:kServiceFindUUID CharactisUUID:kPrinterWriteCharacteristicUUID Peripheral:peripheral WithResponse:CBCharacteristicWriteWithResponse];
//    
//    NSMutableData *finalData = [NSMutableData data];
//    /// 设置打印纸张大小（打印区域）的大小
//    NSString *INIT_PRINT_COMMOND_TEMPLATE = [NSString stringWithFormat:@"! %d %d %d %d %d\n",0,200,200,800,1];
//    NSString *PAGE_WIDTH = [NSString stringWithFormat:@"PAGE-WIDTH %d\n",568];
//    NSData *initData = [INIT_PRINT_COMMOND_TEMPLATE dataUsingEncoding:GBK_Encoding];
//    NSData *page_width_data = [PAGE_WIDTH dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:initData];
//    [finalData appendData:page_width_data];
//    
//    /// 拼接文字
////    NSString *TEXT_CMD = [NSString stringWithFormat:@"TEXT %d %d %d %d %@\n",7,2,20,70,@"厦门宸芯测试1"];
//    NSString *TEXT_CMD = [NSString stringWithFormat:@"CONTRAST 0\nLEFT\nT 4 11 -0 0 请输入文本内容\n"];
//    NSData *text_data = [TEXT_CMD dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:text_data];
//    
//    /// FORM PRINT 命令
//    NSString *FORM = @"FORM\n";
//    NSData   *formData = [FORM dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:formData];
//    NSString *PRINT = @"PRINT\n";
//    NSData *printData = [PRINT dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:printData];
//    
//    NSLog(@"\n%@",[[NSString alloc] initWithData:finalData encoding:GBK_Encoding]);
//    BOOL withResponse = [[ledColorCharistcRepsTypeInfo objectForKey:peripheral.identifier.UUIDString] boolValue];
//    [self writeValue:finalData ServiceUUID:kServiceFindUUID CharactisUUID:kPrinterWriteCharacteristicUUID Peripheral:peripheral WithResponse:withResponse];
//    
//    
//}
//
//- (void) test_printImagePeripheral:(CBPeripheral *)peripheral
//{
//    /// 重置打印机
//    Byte reset[] = {0x1B, 0x40};
//    NSData *data = [NSData dataWithBytes:reset length:sizeof(reset)];
//    [self writeValue:data ServiceUUID:kServiceFindUUID CharactisUUID:kPrinterWriteCharacteristicUUID Peripheral:peripheral WithResponse:CBCharacteristicWriteWithResponse];
//    
//    NSMutableData *finalData = [NSMutableData data];
//    /// 设置打印纸张大小（打印区域）的大小
//    NSString *INIT_PRINT_COMMOND_TEMPLATE = [NSString stringWithFormat:@"! %d %d %d %d %d\n",0,576,200,800,1];
//    NSString *PAGE_WIDTH = [NSString stringWithFormat:@"PAGE-WIDTH %d\n",568];
//    NSData *initData = [INIT_PRINT_COMMOND_TEMPLATE dataUsingEncoding:GBK_Encoding];
//    NSData *page_width_data = [PAGE_WIDTH dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:initData];
//    [finalData appendData:page_width_data];
//    
//    /// 打印图形
//    UIImage *image = [UIImage imageNamed:@"phone"];
//    
//    NSString *image_hex = [UIImage tt_picToBitmbp:image];
//    NSInteger hei = image.size.height;
//    NSInteger wid = image.size.width;
//    
//    if (wid % 8 > 0) {
//        wid = wid / 8;
//    }else{
//        wid = wid / 8 - 1;
//    }
//    
//    hei = image_hex.length/(wid*2);
//    
//    NSString *IMAGE_CMD = [NSString stringWithFormat:@"EG %ld %ld 90 45 %@\r\n",wid,hei,image_hex];
//    
//    //    NSString *IMAGE_CMD = [NSString stringWithFormat:@"EG %d %d 90 45 %@\r\n",2,16,@"FFFFFFFF000000000F0F0F0F0F0F0F0FF0F0F0F0F0F0F0F00F0F0F0F0F0F0F0F"];
//    NSData *image_data = [IMAGE_CMD dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:image_data];
//    
//    //再添加一个换行
//    NSData *enterData = [@"\n" dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:enterData];
//    
//    /// FORM PRINT 命令
//    NSString *FORM = @"FORM\n";
//    NSData   *formData = [FORM dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:formData];
//    NSString *PRINT = @"PRINT\n";
//    NSData *printData = [PRINT dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:printData];
//    
//    NSLog(@"\n%@",[[NSString alloc] initWithData:finalData encoding:GBK_Encoding]);
//    [self writeData:finalData peripheral:peripheral];
//}
//
//
//- (void) test_printImage:(UIImage *)image peripheral:(CBPeripheral *)peripheral
//{
//    /// 重置打印机
//    Byte reset[] = {0x1B, 0x40};
//    NSData *data = [NSData dataWithBytes:reset length:sizeof(reset)];
//    [self writeValue:data ServiceUUID:kServiceFindUUID CharactisUUID:kPrinterWriteCharacteristicUUID Peripheral:peripheral WithResponse:CBCharacteristicWriteWithResponse];
//    
//    NSMutableData *finalData = [NSMutableData data];
//    /// 设置打印纸张大小（打印区域）的大小
//    NSString *INIT_PRINT_COMMOND_TEMPLATE = [NSString stringWithFormat:@"! %d %d %d %d %d\n",0,576,200,800,1];
//    NSString *PAGE_WIDTH = [NSString stringWithFormat:@"PAGE-WIDTH %d\n",568];
//    NSData *initData = [INIT_PRINT_COMMOND_TEMPLATE dataUsingEncoding:GBK_Encoding];
//    NSData *page_width_data = [PAGE_WIDTH dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:initData];
//    [finalData appendData:page_width_data];
//    
//    /// 图形
//    NSString *image_hex = [UIImage tt_picToBitmbp:image];
//    NSInteger hei = image.size.height;
//    NSInteger wid = image.size.width;
//    
//    if (wid % 8 > 0) {
//        wid = wid / 8;
//    }else{
//        wid = wid / 8 - 1;
//    }
//    
//    hei = image_hex.length/(wid*2);
//    
//    NSString *IMAGE_CMD = [NSString stringWithFormat:@"EG %ld %ld 0 45 %@\r\n",wid,hei,image_hex];
//    
//    //    NSString *IMAGE_CMD = [NSString stringWithFormat:@"EG %d %d 90 45 %@\r\n",2,16,@"FFFFFFFF000000000F0F0F0F0F0F0F0FF0F0F0F0F0F0F0F00F0F0F0F0F0F0F0F"];
//    NSData *image_data = [IMAGE_CMD dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:image_data];
//    
//    //再添加一个换行
//    NSData *enterData = [@"\n" dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:enterData];
//    
//    /// FORM PRINT 命令
//    NSString *FORM = @"FORM\n";
//    NSData   *formData = [FORM dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:formData];
//    NSString *PRINT = @"PRINT\n";
//    NSData *printData = [PRINT dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:printData];
//    
//    NSLog(@"\n%@",[[NSString alloc] initWithData:finalData encoding:GBK_Encoding]);
//    [self writeData:finalData peripheral:peripheral];
//}
//
//- (void) test_printBarCode:(id<BPDataEncoder>)model peripheral:(CBPeripheral *)peripheral
//{
//    [self sendResetCMD:peripheral];
//    
//    NSMutableData *finalData = [NSMutableData data];
//    /// 设置打印纸张大小（打印区域）的大小
//    NSString *INIT_PRINT_COMMOND_TEMPLATE = [NSString stringWithFormat:@"! %d %d %d %.f %d\n",0,200,200,72.0f*8,1];
//    NSString *PAGE_WIDTH = [NSString stringWithFormat:@"PAGE-WIDTH %.f\n",72*8.0f];
//    NSData *initData = [INIT_PRINT_COMMOND_TEMPLATE dataUsingEncoding:GBK_Encoding];
//    NSData *page_width_data = [PAGE_WIDTH dataUsingEncoding:GBK_Encoding];
//    [finalData appendData:initData];
//    [finalData appendData:page_width_data];
//    
//    /// 拼接二进制数
////    [finalData appendData:[@"BARCODE 128 1 1 50 150 10 HORIZ.\n" dataUsingEncoding:GBK_Encoding]];
//    [finalData appendData:[model encode]];
//    
//    /// 换行 FORM PRINT
//    [finalData appendData:[self enterCMDData]];
//    [finalData appendData:[self formCMDData]];
//    [finalData appendData:[self printCMDData]];
//    
//    NSLog(@"\n%@",[[NSString alloc] initWithData:finalData encoding:GBK_Encoding]);
//    [self writeData:finalData peripheral:peripheral];
//}

@end





