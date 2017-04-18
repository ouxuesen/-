//
//  AppDelegate.h
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSObject (AppDelegate)
- (NSString *)json;
- (id)cleanNull;
@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

