//
//  FMPhotoAlbumViewController.m
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMPhotoAlbumViewController.h"
#import "ShowPhotosViewController.h"
@interface FMPhotoAlbumViewController ()

@end

@implementation FMPhotoAlbumViewController

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
    self.title = @"相册";
    [photoTableView setTableFooterView:[UIView new]];
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
    static NSString *identifier = @"PhotoAlbumTableCell";
    
    FMbaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FMbaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    if (indexPath.row) {
         cell.textLabel.text = @"本地相册";
    }else{
         cell.textLabel.text = @"手机相册";
    }
    return cell;
}

//选中某行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowPhotosViewController * showPhotoVC = [[ShowPhotosViewController alloc]initWithNibName:@"ShowPhotosViewController" bundle:nil];
    if (indexPath.row) {
        showPhotoVC.photoType = showPhotoStyle_Default;
    }else{
        showPhotoVC.photoType = showPhotoStyle_mobile;
    }
    [self.navigationController pushViewController:showPhotoVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}



@end
