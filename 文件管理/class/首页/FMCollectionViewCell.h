//
//  FMCollectionViewCell.h
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityCommon.h"

@interface FMCollectionViewCell : UICollectionViewCell
{
    
    __weak IBOutlet UIButton *btnColleview;
    __weak IBOutlet UILabel *nameLable;
    UILongPressGestureRecognizer*_longPressGesture;
    NSIndexPath*_indexPath;
    
}
- (void)updateDisplay:(DirectoryElement*)element indexPath:(NSIndexPath*)indexPath;

@end
