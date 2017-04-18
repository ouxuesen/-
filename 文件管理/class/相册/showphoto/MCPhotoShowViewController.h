//
//  MCPhotoShowViewController.h
//  MCFriends
//
//  Created by marujun on 14-5-13.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AQGridView.h"

@interface MCPhotoShowViewController : UIViewController  <AQGridViewDelegate, AQGridViewDataSource>
{
    __weak IBOutlet AQGridView *imageGridView;
    
    UIButton *selectButton;
}

@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end
