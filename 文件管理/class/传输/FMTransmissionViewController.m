//
//  FMTransmissionViewController.m
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMTransmissionViewController.h"
#import "FMWIFITransmissionVCViewController.h"
#import "FMCoreBlueToothViewController.h"

@implementation FMTransmissionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"传输";
}
#pragma mark - Ttable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SettingTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    if (indexPath.row) {
        cell.textLabel.text = @"WIFI接收";
    }else{
        cell.textLabel.text = @"蓝牙接收";
    }
    return cell;
}

//选中某行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row) {
        FMWIFITransmissionVCViewController * wifiVC = [[FMWIFITransmissionVCViewController alloc]initWithNibName:@"FMWIFITransmissionVCViewController" bundle:nil];
        [self.navigationController pushViewController:wifiVC animated:YES];
    }else{
        FMCoreBlueToothViewController * blueToothVC = [[FMCoreBlueToothViewController alloc]initWithNibName:@"FMCoreBlueToothViewController" bundle:nil];
        [self.navigationController pushViewController:blueToothVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
