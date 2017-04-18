//
//  FMCoreBlueToothViewController.m
//  文件管理
//
//  Created by oxs on 15/9/2.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMCoreBlueToothViewController.h"
#import "FileManageCommon.h"
@interface FMCoreBlueToothViewController ()
{
    CoreBlueToothPerphral * blueToothPerphral;
}
@end

@implementation FMCoreBlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    blueToothPerphral = [[CoreBlueToothPerphral alloc]init];
    blueToothPerphral.delegate = self;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * toBoxPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"接收"];
    [FileManageCommon createFolderIfNotExisting:toBoxPath];
    [blueToothPerphral receiveDataStoreFileFullPath:toBoxPath];
    [activtyView startAnimating];
    // Do any additional setup after loading the view from its nib.

}
- (void)receiveDataState:(NSString*)state
{
    showStateLable.text = state;
}
- (void)receiveDataComplete
{
    showStateLable.text = @"传输完成";
    [activtyView stopAnimating];
}
-(void)receivedataAllDataLenth:(CGFloat)allLength currntLenth:(CGFloat)currntLenth
{
    showStateLable.text =[NSString stringWithFormat:@"已经接收 %.0f /%.0f",currntLenth,allLength];
}

- (void)receiveDataDataFault
{
     showStateLable.text = @"已断开连接";
     [activtyView stopAnimating];
}
@end
