//
//  MCPhotoShowViewController.m
//  MCFriends
//
//  Created by marujun on 14-5-13.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MCPhotoShowViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MCImageGridCell.h"
#import "EntityCommon.h"

#define WINDOW_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define WINDOW_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define ShortSystemVersion  [[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_6 (ShortSystemVersion < 7)
#define BASE_TAG     1001
#define GAP          20.f    //UIScrollView 之间的空隙

@interface MCPhotoShowViewController ()
{
}

@end

@implementation MCPhotoShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!IS_IOS_6) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.title = @"预览";
    
    CGRect rect;
    rect = imageGridView.frame;
    rect.size.width = WINDOW_WIDTH+20;
    rect.size.height = WINDOW_HEIGHT;
    imageGridView.frame = rect;
    
    imageGridView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
    imageGridView.backgroundColor = [UIColor clearColor];
    imageGridView.bounces = YES;
    imageGridView.pagingEnabled = true;
    imageGridView.showsHorizontalScrollIndicator = false;
    imageGridView.showsVerticalScrollIndicator = false;
    imageGridView.delegate = self;
    imageGridView.dataSource = self;
    [imageGridView reloadData];
    
    CGSize contentSize = imageGridView.contentSize;
    contentSize.height = rect.size.height;
    imageGridView.contentSize = contentSize;
    
    [imageGridView scrollToItemAtIndex:_currentIndex atScrollPosition:AQGridViewScrollPositionNone animated:NO];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
};

- (void)viewWillAppear:(BOOL)animated
{
    if (IS_IOS_6) {
//        self.navigationBar.translucent = YES;
        self.navigationController.navigationBar.translucent = YES;
    }
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (IS_IOS_6) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];  // 显示状态栏
    [super viewWillDisappear:animated];
}



#pragma mark - 单双击手势触发
-(void)handleSingleTap:(UITapGestureRecognizer*)tap
{
    [self hideNavigationBarAndTabBar];
}
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:tap.view];
    
    NSArray *cellArray = imageGridView.visibleCells;
    for (MCImageGridCell *cell in cellArray) {
        [cell doubleTapWithPoint:touchPoint index:_currentIndex];
    }
}

- (void)hideNavigationBarAndTabBar
{
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
    [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].statusBarHidden;
}




#pragma mark - AQGridView Data Source and Delegate
- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView
{
	return [_dataSourceArray count];
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger) index
{
	MCImageGridCell *cell = (MCImageGridCell *)[gridView dequeueReusableCellWithIdentifier:@"MCImageGridCell"];
	if (cell == nil) {
		cell = [[MCImageGridCell alloc] initWithFrame:gridView.bounds reuseIdentifier:@"MCImageGridCell"];
	}
    if ([_dataSourceArray[index] isKindOfClass:[ALAsset class]]) {
         [cell initWithAsset:_dataSourceArray[index] index:index];
    }else{
        DirectoryElement *eleMent = _dataSourceArray[index];
        UIImage *image = [UIImage imageNamed:eleMent.path];
        [cell initWithImage:image index:index];
    }
   
    
	return cell;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView
{
	return gridView.frame.size;
}


#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger beforeIndex = _currentIndex;
    _currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (_currentIndex != beforeIndex) {
//        self.title = [NSString stringWithFormat:@"%d / %d", _currentIndex+1, _dataSourceArray.count];
    }
}


- (void)dealloc
{
    imageGridView = nil;
}

@end
