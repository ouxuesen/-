//
//  POPPassWordViewController.h
//  欧学森看电影
//
//  Created by oxs on 15/8/24.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMBaseViewController.h"



@interface POPPassWordViewController : FMBaseViewController
{
    
    __weak IBOutlet UITextField *textField;
    IBOutletCollection(UIView) NSArray *tipsView;
}
@end
