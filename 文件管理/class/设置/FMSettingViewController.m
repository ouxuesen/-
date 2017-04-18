//
//  FMSettingViewController.m
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMSettingViewController.h"
#import "FMResetViewController.h"
@interface FMSettingViewController ()
{
    NSArray * souceArray;
    UISwitch * switchView;
}
@end

@implementation FMSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
 
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    if ([userdefault objectForKey:NSUserdefault_passWord])
    {
        souceArray = @[@"修改密码",@"输入密码"];
    }else{
        souceArray = @[@"设置密码"];
    }
    [settingTableView reloadData];
    
}
#pragma mark - Ttable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [souceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"设置密码";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SettingTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = souceArray[indexPath.row];
    cell.accessoryView = nil;
    cell.selectionStyle =  UITableViewCellSelectionStyleDefault;
    if (indexPath.row == 1) {
        ;
        cell.accessoryView = [self creatSwitch];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switchView.on = [[[NSUserDefaults standardUserDefaults] objectForKey:NSUserdefault_passWordOPEN] boolValue];
    }
    return cell;
}

- (UISwitch*)creatSwitch
{
    if (!switchView) {
        switchView = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        [switchView addTarget:self action:@selector(switchChageValue:) forControlEvents:UIControlEventValueChanged];
    }
    return switchView;
}
- (void)switchChageValue:(UISwitch*)switchV
{
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:@(switchV.on).stringValue forKey:NSUserdefault_passWordOPEN];
    [userdefault synchronize];

}
//选中某行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        FMResetViewController * resetViewC = [[FMResetViewController alloc]initWithNibName:@"FMResetViewController" bundle:nil];
        [self.navigationController pushViewController:resetViewC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
