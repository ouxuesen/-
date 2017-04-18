//
//  TranssionProcessView.h
//  文件管理
//
//  Created by oxs on 15/9/7.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranssionProcessView : UIView
{
    __weak IBOutlet UIActivityIndicatorView *activityView;
    __weak IBOutlet UILabel *stateLable;
    
}
-(void)updateShowStateLable:(NSString*)showStr chrysanthemumState:(BOOL)state ;
- (void)dissPresentFormSuperView;
@end
