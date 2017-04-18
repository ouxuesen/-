//
//  FMResetViewController.m
//  文件管理
//
//  Created by oxs on 15/9/1.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMResetViewController.h"
#import "FMResetTableViewCell.h"

@implementation ResetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

@interface FMResetViewController ()
{
    ResetModel * _model;
    NSArray * souceArray;
}
@end

@implementation FMResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    _model = [[ResetModel alloc]init];
    if ([userdefault objectForKey:NSUserdefault_passWord]) {
        self.title = @"修改密码";
        souceArray = @[@"",@""];
        _model.type = 0;
    }else{
        self.title = @"设置密码";
        souceArray = @[@"",];
        _model.type = 1;
    }
    
    
    UIBarButtonItem * rightBbi =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(determine:) ];
    self.navigationItem.rightBarButtonItem = rightBbi;
}
- (void)determine:(UIBarButtonItem*)item
{
     NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    if (_model.type) {
        [userdefault setObject:_model.passWord forKey:NSUserdefault_passWord];
        [userdefault synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([[userdefault objectForKey:NSUserdefault_passWord] isEqualToString:_model.passWord]) {
            if (_model.resetPassWord.length<4) {
                [MCAlertView showWithMessage:@"密码格式不对"];
                return;
            }
            [userdefault setObject:_model.resetPassWord forKey:NSUserdefault_passWord];
            [userdefault synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
              [MCAlertView showWithMessage:@"密码不对"];
        }
    }
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ResetTableCell";
    
    FMResetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"FMResetTableViewCell" owner:self options:nil][0];
    }
    cell.resetModel = _model;
    [cell initWithData:nil indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
