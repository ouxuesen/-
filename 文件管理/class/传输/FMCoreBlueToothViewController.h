//
//  FMCoreBlueToothViewController.h
//  文件管理
//
//  Created by oxs on 15/9/2.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMBaseViewController.h"
#import "CoreBlueToothPerphral.h"
@interface FMCoreBlueToothViewController : FMBaseViewController<CoreBlueToothPerphralDelegate>
{
    __weak IBOutlet UIActivityIndicatorView *activtyView;
    
    __weak IBOutlet UILabel *showStateLable;
}

@end
