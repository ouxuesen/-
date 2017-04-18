//
//  AppDelegate.m
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "AppDelegate.h"
#import "FileManageCommon.h"
#import "EntityCommon.h"
#import "POPPassWordViewController.h"
@implementation NSObject (HttpManager)
- (NSString *)json
{
    NSString *jsonStr = @"";
    @try {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] 对象转换成JSON字符串出错了-->\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    @finally {
    }
    return jsonStr;
}
@end
@interface AppDelegate ()
@property (nonatomic,strong)UINavigationController *popNavi;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (launchOptions) {
          [self  receiveFile:launchOptions];
    }
//    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
//    [userdefault removeObjectForKey:NSUserdefault_passWord];
//    [userdefault removeObjectForKey:NSUserdefault_passWordOPEN];
//    [userdefault synchronize];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showPasswordView) name:NSUserdefault_loadComplete object:nil];
    return YES;
}

//外部应用传入
- (void)receiveFile:(NSDictionary*)launchOptions
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *InboxArray = [FileManageCommon getFileFormInbox];
    if ([InboxArray count]) {
        for ( DirectoryElement * element in InboxArray) {
            NSString * toBoxPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"外部应用文件"];
            if ([FileManageCommon createFolderIfNotExisting:toBoxPath]) {
                [FileManageCommon moveFileFromFullPath:element.path toFullPatch:[NSString stringWithFormat:@"%@/%@",toBoxPath,element.name]];
            } ;
            
        }
    }
}
- (void)showPasswordView
{
   NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    if (![userdefault objectForKey:@"NSUserdefault_passWordOPEN"]||![[userdefault objectForKey:@"NSUserdefault_passWordOPEN"] boolValue]) {
        return;
    }

    if (!_popNavi) {
        POPPassWordViewController *popViewC = [[POPPassWordViewController alloc]initWithNibName:@"POPPassWordViewController" bundle:nil];
        _popNavi = [[UINavigationController alloc]initWithRootViewController:popViewC];
        _popNavi.view.tag = 10001;
    }
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (![window viewWithTag:10001]) {
        [window addSubview:_popNavi.view];
        [window  bringSubviewToFront:_popNavi.view];
        [_popNavi.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
   
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self showPasswordView];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
