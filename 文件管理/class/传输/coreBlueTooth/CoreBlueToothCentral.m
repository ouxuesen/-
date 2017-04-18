//
//  CoreBlueToothCentral.m
//  文件管理
//
//  Created by oxs on 15/9/2.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "CoreBlueToothCentral.h"

@implementation NSObject (CoreBlueToothCentral)
- (NSString *)json
{
    NSString *jsonStr = @"";
    @try {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] 对象转换成JSON字符串出错了-->\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    @finally {
    }
    return jsonStr;
}
@end
@interface CoreBlueToothCentral ()
{
    NSTimer * connectTimer;
    CBPeripheral * _testPeripheral;
    NSMutableArray * _discoverdePeripherals;
    CBCharacteristic *_readCharacteristic;
    CBCharacteristic * _writeCharacteristic;
    NSTimer * scanTimeOut;
    BOOL fileTransmission;
    
    //----------文件数据处理
    NSInteger fileSize;
    NSInteger readSize;
    NSFileManager *fileManager;
    NSFileHandle *inFile;
    int n ;
    BOOL isEnd;
}
@end
@implementation CoreBlueToothCentral

- (instancetype)init
{
    self = [super init];
    if (self) {
        fileTransmission = YES;
        isEnd= NO;
    }
    return self;
}
- (void)transmissionDataFromDirectoryElement:(DirectoryElement*)elemen
{
    _element = elemen;
    //建立中心角色
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _discoverdePeripherals = [NSMutableArray new];
    [self beginDiscorver];

}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            // Scans for any peripheral
            [manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey :@YES}];
            break;
        default:
            NSLog(@"Central Manager did change state");
            break;
    }
}
+ (NSString*) getUUIDString

{
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString;
    
    
}
//扫秒外设
- (void)beginDiscorver
{
    scanTimeOut = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(outScanManager) userInfo:nil repeats:NO];
    //@[[CBUUID UUIDWithString:@"465B7C08-F31A-146A-C630-B387809888C7"]]
    [manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey :@YES }];
   
}
- (void)outScanManager
{
     [manager stopScan];
    [scanTimeOut invalidate];
    if ([_discoverdePeripherals count]) {
        if ([_discoverdePeripherals count]>1) {
            CBPeripheral * peripheral = _discoverdePeripherals[0];
            CBPeripheral * peripheral_1 = _discoverdePeripherals[1];
            MCActionSheet * actionSheet = [MCActionSheet initWithTitle:@"选择连接" cancelButtonTitle:@"取消" destructiveButtonTitle:peripheral.name otherButtonTitles:peripheral_1.name, nil];
            [actionSheet showWithCompletionBlock:^(NSInteger buttonIndex) {
                if (buttonIndex<=1) {
                    [self connect:_discoverdePeripherals[buttonIndex]];
                }
            }];
        }else{
            [self connect:_discoverdePeripherals[0]];
        }
    }else{
        [MCAlertView showWithMessage:@"未能扫描到设备,请确认接受蓝牙设备否打开"];
        if ([_delegate respondsToSelector:@selector(transmissionDataFault)]) {
            [_delegate transmissionDataFault];
        }
    }
}
// centeral扫描代理
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //    [manager stopScan];
    if(![_discoverdePeripherals containsObject:peripheral] && ([peripheral.name isEqualToString:@"ICServer"]||[peripheral.name isEqualToString:@"刘龙华的 iPhone"]))
    {
        [_discoverdePeripherals addObject:peripheral];
       
    }
    
    NSLog(@"dicoveredPeripherals:%@", peripheral);
    
}
//连接指定的设备
-(BOOL)connect:(CBPeripheral *)peripheral
{
    NSLog(@"connect start");
    //    _testPeripheral = nil;
    
    [manager connectPeripheral:peripheral
                       options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
    //开一个定时器监控连接超时的情况
    connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(connectTimeout:) userInfo:peripheral repeats:NO];
    
    return (YES);
}
- (void)connectTimeout:(NSTimer*)timer
{
    if (manager.state == 0) {
        [MCAlertView showWithMessage:@"连接超时"];
        NSLog(@"连接超时");
        if ([_delegate respondsToSelector:@selector(transmissionDataFault)]) {
            [_delegate transmissionDataFault];
        }
    }
    /*
     // 初始的时候是未知的（刚刚创建的时候）
     CBCentralManagerStateUnknown = 0,
     //正在重置状态
     CBCentralManagerStateResetting,
     //设备不支持的状态
     CBCentralManagerStateUnsupported,
     // 设备未授权状态
     CBCentralManagerStateUnauthorized,
     //设备关闭状态
     CBCentralManagerStatePoweredOff,
     // 设备开启状态 -- 可用状态
     CBCentralManagerStatePoweredOn,
     */
}
//连接周边的代理
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [connectTimer invalidate];//停止时钟
    
    NSLog(@"Did connect to peripheral: %@", peripheral);
    _testPeripheral = peripheral;
    
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}
//周边设备的服务和特征

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    
    NSLog(@"didDiscoverServices");
    NSLog(@"peripheral - service = %@",peripheral.services);
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        
    }
    for (CBService *service in peripheral.services)
    {
        //
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"312700E2-E798-4D5C-8DCF-49908332DF9F"]])
        {
            NSLog(@"Service found with UUID: %@", service.UUID);
            [peripheral discoverCharacteristics:nil forService:service];
            //            isVPOS3356 = YES;
            break;
        }
    }
    
    
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    NSLog(@"CBService.characteristics = %@",service.characteristics);
    NSLog(@"CBService.includedServices = %@",service.includedServices);
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
 
    }

    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"7777"]])
        {
            NSLog(@"Discovered read characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
            //
            _readCharacteristic = characteristic;//保存读的特征
            [self startSubscribe];
 
        }
    }
    
    for (CBCharacteristic * characteristic in service.characteristics)
    {
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"6666"]])
        {
            
            NSLog(@"Discovered write characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
            _writeCharacteristic = characteristic;//保存写的特征
            [self readFileAndTransmission];
        }
    }
    
    
}

- (void)readFileAndTransmission
{
   
//    NSData * dataFile = [NSData dataWithContentsOfFile:_element.path];
    
    NSString *srcPath = _element.path;
    fileManager=[NSFileManager defaultManager];
   inFile=[NSFileHandle fileHandleForReadingAtPath:srcPath];
    if (!inFile) {
        return ;
    }
    NSDictionary   *fileAttu=[fileManager attributesOfItemAtPath:srcPath error:nil];
    NSNumber *fileSizeNum=[fileAttu objectForKey:NSFileSize];
     n=0;
     readSize=0;//已经读取的数量
     fileSize=[fileSizeNum longValue];//文件的总长度
    isEnd= NO;
    [self piecewiseToSendData];

}

-(void)piecewiseToSendData
{
    if (fileTransmission) {
        NSDictionary * dictFile = @{@"fileName":_element.name,@"fileSize":@(_element.fileSize).stringValue};
        [self writeChar:[[dictFile json] dataUsingEncoding:NSUTF8StringEncoding]];
        fileTransmission = NO;
    }else{
        if (n%10==0) {
            
        }
        NSInteger subLength=fileSize-readSize;
        NSData *data=nil;
        if (subLength<500) {
            data=[inFile readDataToEndOfFile];
            [self writeChar:data];
            [inFile closeFile];
            if ([_delegate respondsToSelector:@selector(transmissionDataComplete)]) {
                [_delegate transmissionDataComplete];
            }
            isEnd= YES;
            return ;
        }else{
            data=[inFile readDataOfLength:500];
            readSize+=500;
            [inFile seekToFileOffset:readSize];
            [self writeChar:data];
            if ([_delegate respondsToSelector:@selector(transmissionData::)]) {
                [_delegate transmissionData:fileSize :readSize];
            }
        }
        n++;
        
    }
    
    
}
//写数据
-(void)writeChar:(NSData *)data
{
    [_testPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];
    
}
//监听设备
-(void)startSubscribe
{
    [_testPeripheral setNotifyValue:YES forCharacteristic:_readCharacteristic];
}
//通知  接受数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,0.25* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (error == nil) {
            NSString * value =[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            NSLog(@"peripheral = %@",value);
            if ([value boolValue]) {
                if (!isEnd) {
                    [self piecewiseToSendData];
                }
            }else{
                
            }
        }
//    });

}
-(void)disConnect
{
    
    if (_testPeripheral != nil)
    {
        NSLog(@"disConnect start");
        [manager cancelPeripheralConnection:_testPeripheral];
    }
    fileTransmission = YES;
    isEnd= NO;
}



@end
