//
//  CoreBlueToothPerphral.h
//  文件管理
//
//  Created by oxs on 15/9/2.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface NSString (CoreBlueToothPerphral)
 -(id)object;
@end
@protocol CoreBlueToothPerphralDelegate <NSObject>

@optional
- (void)receiveDataState:(NSString*)state;
-(void)receivedataAllDataLenth:(CGFloat)allLength currntLenth:(CGFloat)currntLenth;
- (void)receiveDataComplete;
- (void)receiveDataDataFault;

@end
@interface CoreBlueToothPerphral : NSObject<CBPeripheralManagerDelegate>
@property (nonatomic,strong) CBPeripheralManager* peripheralManger;
@property (nonatomic,assign) id<CoreBlueToothPerphralDelegate> delegate;
//path文件夹
- (void)receiveDataStoreFileFullPath:(NSString*)path;

@end
