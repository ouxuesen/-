//
//  ShowPhotosViewController.h
//  相册
//
//  Created by oxs on 15/7/24.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileManageCommon.h"
@interface ASKPermissions : NSObject

@end

typedef NS_ENUM (NSInteger ,showPhotoStyle){
    showPhotoStyle_Default = 0,
    showPhotoStyle_mobile = 1,
};
@interface ShowPhotosViewController : FMBaseViewController

@property (nonatomic, assign) showPhotoStyle *photoType;
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollection;

@end

