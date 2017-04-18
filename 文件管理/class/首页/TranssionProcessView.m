//
//  TranssionProcessView.m
//  文件管理
//
//  Created by oxs on 15/9/7.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "TranssionProcessView.h"

@implementation TranssionProcessView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    }
    return self;
}
-(void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
}

-(void)updateShowStateLable:(NSString*)showStr chrysanthemumState:(BOOL)state
{
    stateLable.text = showStr;
    if (state) {
        [activityView stopAnimating];
    }else{
        [activityView startAnimating];
    }
}

-(void)dissPresentFormSuperView
{
    [self removeFromSuperview];
}

@end
