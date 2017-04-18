//
//  CoreBlueToothPerphral.m
//  文件管理
//
//  Created by oxs on 15/9/2.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "CoreBlueToothPerphral.h"
#import "FileManageCommon.h"

@implementation NSString(CoreBlueToothPerphral)

- (id)object
{
    id object = nil;
    @try {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];;
        object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] JSON字符串转换成对象出错了-->\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    @finally {
    }
    return object;
}

@end
@interface CoreBlueToothPerphral ()
{
    CBMutableService * _curentService;
    CBMutableCharacteristic * _characteristic;
    NSMutableArray * _arrayCBCentral;
    CBMutableCharacteristic* _Writecharacteristic;
    NSString * _storePath;
    NSFileManager * _fileManager ;
    NSFileHandle * _outFile;
    BOOL fistReceive;
    CGFloat allDataLenth;
    CGFloat receivedLenth;
}

@end
static NSString * const kServiceUUID = @"312700E2-E798-4D5C-8DCF-49908332DF9F";

@implementation CoreBlueToothPerphral

- (instancetype)init
{
    self = [super init];
    if (self) {
        fistReceive = YES;
    }
    return self;
}
- (void)receiveDataStoreFileFullPath:(NSString*)path
{
    _storePath = path;
    [self creatPeripheralManager];
}
- (void)creatPeripheralManager
{
    _peripheralManger = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil options:nil];
    
}
//开始广播
- (void)startAdvertising
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_peripheralManger startAdvertising:
         @{ CBAdvertisementDataLocalNameKey :
                @"ICServer", CBAdvertisementDataServiceUUIDsKey :
                @[[CBUUID UUIDWithString:kServiceUUID]] }];
    });
   
}
//停止广播
- (void)stopAdvertising
{
    [_peripheralManger stopAdvertising];
}
//添加服务
- (void)addService
{
    if (_curentService) {
        [_peripheralManger removeService:_curentService];
    }
    CBMutableService * service = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:@"312700E2-E798-4D5C-8DCF-49908332DF9F"] primary:YES];
    _characteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:@"7777"] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];//属性的读、写、加密的权限
    _Writecharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:@"6666"] properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];//属性的读、写、加密的权限
    service.characteristics = @[_characteristic,_Writecharacteristic];
    [_peripheralManger addService:service];
}
- (void)respondToRequest:(CBATTRequest *)request withResult:(CBATTError)result
{
    
}
- (BOOL)updateValue:(NSData *)value forCharacteristic:(CBMutableCharacteristic *)characteristic onSubscribedCentrals:(NSArray *)centrals
{
    return YES;
}

#pragma -- 代理
//更新状态 ，只有状态可用的时候才能够进行创建服务，发布等等操作
//状态和CBCentralManager一样
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral
{
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            [self addService];
            break;
        default:
        {
        [MCAlertView showWithMessage:@"Peripheral Manager did change state"];
            NSLog(@"Peripheral Manager did change state");
        }
         
            break;
    }
    
}

//peripheral提供信息，dict包含了应用程序关闭是系统保存的peripheral的信息，用dic去恢复peripheral
//app状态的保存或者恢复，这是第一个被调用的方法当APP进入后台去完成一些蓝牙有关的工作设置，使用这个方法同步app状态通过蓝牙系统
//dic里面有两对key值分别对应服务（数组）和数据（数组）
- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary *)dict;
{
    
}

// 开始向外广播数据  当startAdvertising被执行的时候调用这个代理方法
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if (error == nil) {
        
    }
    
}

// 当你执行addService方法后执行如下回调，当你发布一个服务和任何一个相关特征的描述到GATI数据库的时候执行
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    if (error == nil) {
        // Starts advertising the service
        [self startAdvertising];
    }
}


//central订阅了characteristic的值，当更新值的时候peripheral会调用【updateValue: forCharacteristic: onSubscribedCentrals:(NSArray*)centrals】去为数组里面的centrals更新对应characteristic的值，在更新过后peripheral为每一个central走一遍改代理方法
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    if (![_arrayCBCentral containsObject:central]) {
        if (!_arrayCBCentral) {
            _arrayCBCentral = [NSMutableArray new];
        }
        [_arrayCBCentral addObject:central];
    }
}


//当central取消订阅characteristic这个特征的值后调用方法。使用这个方法提示停止为这个central发送更新
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"已经断开连接");
    [MCAlertView showWithMessage:@"已经断开连接"];
    if ([_delegate respondsToSelector:@selector(receiveDataState:)]) {
        [_delegate receiveDataState:@"已经断开连接"];
    }
}


//当peripheral接受到一个读ATT读请求，数据在CBATTRequest
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    
}

//当peripheral接受到一个写请求的时候调用，参数有一个数组的CBATTRequest对象request
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    NSLog(@"1111");
    if (requests&&requests[0]) {
        if ([_delegate respondsToSelector:@selector(receiveDataState:)]) {
            [_delegate receiveDataState:@"开始接收"];
        }
        CBATTRequest *request = requests[0];
        if (fistReceive) {
            NSString * stringJson = [[NSString alloc]initWithData:request.value encoding:NSUTF8StringEncoding];
            NSDictionary * dicFile = [stringJson object];
            _storePath = [_storePath stringByAppendingPathComponent:dicFile[@"fileName"]];
            allDataLenth = [dicFile[@"fileSize"] floatValue];
            [FileManageCommon createFileIfNotExisting:_storePath];
            [_peripheralManger updateValue:[@"1"  dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_characteristic onSubscribedCentrals:_arrayCBCentral];
            fistReceive= NO;
            receivedLenth = 0;
        }else{
           [self storeFile:[request value]];
        }
        
    }
    
}

- (void)storeFile:(NSData*)data
{
    if (!_fileManager) {
          _fileManager=[NSFileManager defaultManager];
        _outFile=[NSFileHandle fileHandleForWritingAtPath:_storePath];
        
    }
    BOOL success=[FileManageCommon createFileIfNotExisting:_storePath];
    if (success) {
        NSLog(@"正在传输");
        
        
        if (!_outFile) {
            return ;
        }
        if ([_delegate respondsToSelector:@selector(receivedataAllDataLenth:currntLenth:)]) {
            [_delegate receivedataAllDataLenth:allDataLenth currntLenth:receivedLenth];
        }
       [_outFile writeData:data];
        if (data.length<500) {
            [_outFile closeFile];
            _outFile = nil;
            _fileManager = nil;
            if ([_delegate respondsToSelector:@selector(receiveDataComplete)]) {
                [_delegate receiveDataComplete];
            }
           
        }else{
             [_peripheralManger updateValue:[@"1"  dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_characteristic onSubscribedCentrals:_arrayCBCentral];
            receivedLenth +=500;
        }
       
    }

}
//peripheral再次准备好发送Characteristic值的更新时候调用

//当updateValue: forCharacteristic:onSubscribedCentrals:方法调用因为底层用于传输Characteristic值更新的队列满了而更新失败的时候，实现这个委托再次发送改值

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
        [_peripheralManger updateValue:[@"1"  dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_characteristic onSubscribedCentrals:_arrayCBCentral];
}



//- (IBAction)startAdvertisingBtnClick:(id)sender {
//    
//    [_peripheralManger updateValue:[@"我们都是好孩子  天天要向上"  dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_characteristic onSubscribedCentrals:_arrayCBCentral];
//   
//}
@end
