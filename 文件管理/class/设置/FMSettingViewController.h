//
//  FMSettingViewController.h
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMForTabViewController.h"

@interface FMSettingViewController : FMForTabViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *settingTableView;
}
@end
