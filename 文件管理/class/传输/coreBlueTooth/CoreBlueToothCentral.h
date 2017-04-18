//
//  CoreBlueToothCentral.h
//  文件管理
//
//  Created by oxs on 15/9/2.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityCommon.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface NSObject (CoreBlueToothCentral)
- (NSString *)json;
@end

@protocol CoreBlueToothCentralDelegate <NSObject>

@optional
- (void)transmissionData:(CGFloat)tollLength :(CGFloat)currntLength;
- (void)transmissionDataComplete;
- (void)transmissionDataFault;

@end
@interface CoreBlueToothCentral : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

{
    CBCentralManager * manager ;
    DirectoryElement*_element;
}
@property (nonatomic,assign) id<CoreBlueToothCentralDelegate> delegate;
-(void)disConnect;
- (void)transmissionDataFromDirectoryElement:(DirectoryElement*)element;
@end
