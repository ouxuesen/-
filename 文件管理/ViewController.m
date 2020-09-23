//
//  ViewController.m
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "ViewController.h"
#import "FMTransmissionViewController.h"
#import "FMSettingViewController.h"
#import "FMHomePageViewController.h"
#import "FileManageCommon.h"
#import "ReadParserTextListViewController.h"
@interface ViewController ()
{
    NSArray * classArrayName;
    NSArray * titleArray;
    BOOL firstLoad;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    classArrayName = @[@"FMHomePageViewController",@"ReadParserTextListViewController",@"FMTransmissionViewController",@"FMSettingViewController"];
    titleArray = @[@"首页",@"小说",@"传输",@"设置"];
    UITabBarController * mainTabBarVC = [[UITabBarController alloc]init];
    mainTabBarVC.viewControllers = [self mainViewConrollWithArrayName:classArrayName];
    [self addChildViewController:mainTabBarVC];
    [self.view addSubview:mainTabBarVC.view];
    [mainTabBarVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!firstLoad) {
         [[NSNotificationCenter defaultCenter]postNotificationName:NSUserdefault_loadComplete object:nil];
        firstLoad = YES;
    }
}
- (FMBaseViewController*)creatViewControllWithName:(NSString*)VCName
{
    FMBaseViewController * vc = [[NSClassFromString(VCName) alloc]init];
    return vc;
}
- (NSMutableArray*)mainViewConrollWithArrayName:(NSArray*)nameArray
{
    NSMutableArray * classArray = [NSMutableArray new];
    NSInteger count = 0;
    for (NSString  *className in nameArray) {
        FMBaseViewController * vc = [self creatViewControllWithName:className];
        if ([vc isKindOfClass:[FMHomePageViewController class]]
            ) {
            NSString* rootPath = [FileManageCommon getRootDocumentPath:@""];
            [(FMHomePageViewController*)vc openFileName:rootPath withTitle:@"首页"];
        }
        UIImage* anImage = [UIImage imageNamed:@"首页-正常.png"];
        UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:titleArray[count] image:anImage tag:count];
        vc.tabBarItem = theItem;
        UINavigationController  *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        [ classArray addObject:navi];
        count ++ ;
    }
    return classArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
