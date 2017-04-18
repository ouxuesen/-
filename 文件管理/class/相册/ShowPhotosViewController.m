//
//  ShowPhotosViewController.m
//  相册
//
//  Created by oxs on 15/7/24.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "ShowPhotosViewController.h"
#import "PhotoCollectionViewCell.h"
#import "MCPhotoShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileManageCommon.h"
@implementation ASKPermissions

+ (BOOL)cameraGranted
{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied)
    {
        if (/* DISABLES CODE */ (/* DISABLES CODE */ (/* DISABLES CODE */ (&UIApplicationOpenSettingsURLString)))) {
            MCAlertView *alert = [MCAlertView initWithTitle:@"相机权限未开启" message:@"请在系统设置中开启相机权限以进行相关操作" cancelButtonTitle:@"确定" otherButtonTitles:@"开启相机", nil];
            [alert showWithCompletionBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
        } else {
            [MCAlertView showWithMessage:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"];
        }
        
        return NO;
    }
    return YES;
    
}

+ (BOOL)photoAlbumGranted
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted ||
        author == kCLAuthorizationStatusDenied)
    {
        //无权限
        if (&UIApplicationOpenSettingsURLString) {
            MCAlertView *alert = [MCAlertView initWithTitle:@"相册权限未开启" message:@"请在系统设置中开启相册权限以进行相关操作" cancelButtonTitle:@"确定" otherButtonTitles:@"开启相册", nil];
            [alert showWithCompletionBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
        } else {
            [MCAlertView showWithMessage:@"请在设备的\"设置-隐私-照片\"中允许访问相册。"];
        }
        
        return NO;
    }
    return YES;
}
@end
@interface ShowPhotosViewController ()
{
    ALAssetsFilter* _assetsFilter;
    NSMutableArray * _gropsAlbum;
    ALAssetsLibrary * _assetsPhotoLibrary;
    ALAssetsLibrary * _assetsAllLibrary;
    UIActivityIndicatorView * activityIndicator;
}

@property (nonatomic, strong) NSMutableArray* assets;
@end

@implementation ShowPhotosViewController
static NSString * CellIdentifier = @"PhotoCollectionViewCell";

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:activityIndicator];
    _assetsFilter = [ALAssetsFilter allPhotos];
    _gropsAlbum = [NSMutableArray new];
    _assetsPhotoLibrary = [ALAssetsLibrary new];
    _assetsPhotoLibrary = [ALAssetsLibrary new];
    [self.photosCollection registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    if (_photoType == showPhotoStyle_Default) {
        self.title = @"本地相册";
        [self donePhotoesFormApp];
    }else{
        self.title = @"手机相册";
        [self donePhotoAlbumData];
    }
    
    //调整固定间距
    CGFloat gaps = 10.0f;
    CGFloat cellWidth = 80.0f;
    CGSize sizeWindown = [UIScreen mainScreen].bounds.size;
    
    NSInteger row = floor((sizeWindown.width+gaps)/(gaps+cellWidth));
    CGFloat contentInset = sizeWindown.width - row*(gaps+cellWidth) +10;
    [self.photosCollection setContentInset:UIEdgeInsetsMake(0, contentInset/2, 49, contentInset/2)];
    
}
- (void)donePhotoesFormApp
{
    [activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.assets =  [[FileManageCommon filterPhotosFromFullPath:[FileManageCommon getRootDocumentPath:@""] ] mutableCopy];
        if (self.assets) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photosCollection reloadData];
                [activityIndicator stopAnimating];
            });
        }
    });
 
}
//拿相册的数据
- (void)donePhotoAlbumData
{
    if (![ASKPermissions photoAlbumGranted]) {
        return;
    }
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            [group setAssetsFilter:_assetsFilter];
            if (group.numberOfAssets > 0)
                [_gropsAlbum addObject:group];
        }
        else
        {
            for (ALAssetsGroup * asset in _gropsAlbum) {
                [self donePhotoesFromAlum:asset];
            }
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        
        
    };
    
    [_assetsPhotoLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                       usingBlock:resultsBlock
                                     failureBlock:failureBlock];
}

- (void)donePhotoesFromAlum:(ALAssetsGroup *)assetsGroup
{

    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset)
        {
            [self.assets addObject:asset];
        }
        
        else if (self.assets.count > 0)
        {
            [self.photosCollection reloadData];
            
        }
    };
    
    [assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assets count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.photoType == showPhotoStyle_Default) {
        [cell blindDirectoryElement:self.assets[indexPath.row] indexPath:indexPath];
    }else{
         [cell blindAsset:self.assets[indexPath.row] indexPath:indexPath];
    }
   
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
//#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCPhotoShowViewController *showVC = [[MCPhotoShowViewController alloc] initWithNibName:@"MCPhotoShowViewController" bundle:nil];
    showVC.dataSourceArray = _assets;

    showVC.currentIndex = indexPath.row;
    [self.navigationController pushViewController:showVC animated:true];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)dealloc
{
    
    NSLog(@"释放了--%@", NSStringFromClass([self class]));
    
}
@end
