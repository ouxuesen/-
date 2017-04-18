//
//  MCImageGridCell.m
//  MCFriends
//
//  Created by marujun on 14-6-19.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MCImageGridCell.h"

#define WINDOW_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define WINDOW_WIDTH     [[UIScreen mainScreen] bounds].size.width
@interface MCImageGridCell ()
{
    NSInteger myIndex;
    BOOL isLoading;
}
@end

@implementation MCImageGridCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
	if (self){
        self.contentView.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = true;
        
        frame.origin.x = (frame.size.width-WINDOW_WIDTH)/2;
        frame.origin.y = 0;
        frame.size.width = WINDOW_WIDTH;
        
        _imageScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _imageScrollView.maximumZoomScale = 2;
        _imageScrollView.backgroundColor = [UIColor clearColor];
        _imageScrollView.showsHorizontalScrollIndicator = false;
        _imageScrollView.showsVerticalScrollIndicator = false;
        _imageScrollView.delegate = self;
        
        _zoomImageView = [[UIImageView alloc] initWithFrame:_imageScrollView.bounds];
        [_imageScrollView addSubview:_zoomImageView];
        [self.contentView addSubview:_imageScrollView];
        
//        _loadingView = [[TorusIndicatorView alloc] init];
//        _loadingView.center = self.contentView.center;
//        _loadingView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_loadingView];
//        
//        _loadingView.hidden = YES;
	}
	return self;
}


#pragma mark - 双击手势触发
- (void)doubleTapWithPoint:(CGPoint)point index:(NSInteger)index
{
    if (myIndex != index || isLoading) {
        return;
    }
	if (_imageScrollView.zoomScale > 1) {
		[_imageScrollView setZoomScale:1 animated:YES];
	} else {
		[_imageScrollView zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
	}
}


- (void)initWithAsset:(ALAsset *)asset index:(NSInteger)index
{
    myIndex = index;
    
    _imageScrollView.zoomScale = 1.0;
    CGSize scrollSize = _imageScrollView.frame.size;
    
    _zoomImageView.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    _zoomImageView.bounds = [self boundsOfImage:_zoomImageView.image forRect:_imageScrollView.bounds];
    _zoomImageView.center = CGPointMake(scrollSize.width/2, scrollSize.height/2);
    
    [self setMaximumZoomScale];
}

- (void)initWithImage:(UIImage *)image index:(NSInteger)index
{
    myIndex = index;
    
    _imageScrollView.zoomScale = 1.0;
    CGSize scrollSize = _imageScrollView.frame.size;
    
    _zoomImageView.image = image;
    _zoomImageView.bounds = [self boundsOfImage:image forRect:_imageScrollView.bounds];
    _zoomImageView.center = CGPointMake(scrollSize.width/2, scrollSize.height/2);
    
    [self setMaximumZoomScale];
}



- (void)setMaximumZoomScale
{
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    float scale = _zoomImageView.image.size.width/(WINDOW_WIDTH*scale_screen);
    
    _imageScrollView.maximumZoomScale = MAX(scale, 2);
}

- (CGRect)boundsOfImage:(UIImage *)image forRect:(CGRect)rect
{
    CGSize imageSize = image.size;
    CGSize viewSize = rect.size;
    
    CGSize finalSize = CGSizeZero;
    
    if (imageSize.width / imageSize.height < viewSize.width / viewSize.height) {
        finalSize.height = viewSize.height;
        finalSize.width = viewSize.height / imageSize.height * imageSize.width;
    }
    else {
        finalSize.width = viewSize.width;
        finalSize.height = viewSize.width / imageSize.width * imageSize.height;
    }
    return CGRectMake(0, 0, finalSize.width, finalSize.height);
}

#pragma mark UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIImageView *zoomView = _zoomImageView;
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? (scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    zoomView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX, scrollView.contentSize.height/2 + offsetY);
}

@end
