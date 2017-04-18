//
//  PhotoCollectionViewCell.h
//  相册
//
//  Created by oxs on 15/7/24.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import <UIKit/UIKit.h>
 #import <AssetsLibrary/AssetsLibrary.h>
#import "EntityCommon.h"

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSIndexPath * indexPathS;
@property (nonatomic,strong) ALAsset *asset;

@property (weak, nonatomic) IBOutlet UIImageView *backGroudImageView;
- (void)blindAsset:(ALAsset*)asset indexPath:(NSIndexPath*)indexPathS;
- (void)blindDirectoryElement:(DirectoryElement*)element indexPath:(NSIndexPath*)indexPathS;
@end
