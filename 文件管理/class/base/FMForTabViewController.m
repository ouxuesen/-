//
//  FMForTabViewController.m
//  文件管理
//
//  Created by oxs on 15/8/26.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMForTabViewController.h"

@interface FMForTabViewController ()

@end

@implementation FMForTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    if ([self.navigationController.viewControllers count] != 1) {
        self.tabBarController.tabBar.hidden = YES;
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController.viewControllers count] == 1) {

            self.tabBarController.tabBar.hidden = NO;
    }
}
@end
