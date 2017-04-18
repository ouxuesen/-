//
//  FMResetTableViewCell.h
//  文件管理
//
//  Created by oxs on 15/9/1.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMbaseTableViewCell.h"
#import "FMResetViewController.h"
@interface FMResetTableViewCell : FMbaseTableViewCell<UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *passWordTextField;
     NSInteger _limitCount;
}
@property (nonatomic,strong)ResetModel * resetModel;

@end
