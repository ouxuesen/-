//
//  FMResetViewController.h
//  文件管理
//
//  Created by oxs on 15/9/1.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMBaseViewController.h"

@interface ResetModel : NSObject
@property (nonatomic,strong) NSString * passWord;
@property (nonatomic,assign) NSInteger  type; // 0修改密码 1设定密码
@property (nonatomic,strong) NSString * resetPassWord;
@property (nonatomic,strong) UITextField * currentTextField;

@end

@interface FMResetViewController : FMBaseViewController
{
    __weak IBOutlet UITableView *resetTableView;
    
}
@end
