//
//  FMCollectionViewCell.m
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMCollectionViewCell.h"
#import "Main.h"
@implementation FMCollectionViewCell
- (id)collectionDelegate
{
    UICollectionView *collection = [self superCollection];
    
    if (collection) {
        return collection.delegate;
    }
    
    return nil;
}

- (UICollectionView *)superCollection
{
    id view = [self superview];
    
    while (view && ![view isKindOfClass:[UICollectionView class]]) {
        view = [view superview];
    }
    
    return (UICollectionView *)view;
}

-(void)awakeFromNib
{
//    self.layer.borderWidth = 1;
//    self.layer.cornerRadius = 4;
//    self.layer.borderColor =[RGBCOLOR(224, 226, 226) CGColor];
//    self.clipsToBounds = YES;
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:_longPressGesture];
}

-(void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
   
        UIViewController *parentVC = [self collectionDelegate];
        NSMutableDictionary * infoDic = [NSMutableDictionary new];
        infoDic[@"indexPath"] = _indexPath;
        CGRect rect = [self.superview convertRect:self.frame toView:parentVC.view];
        infoDic[@"rect"] = NSStringFromCGRect(rect);
        SEL replyAction = @selector(copyMenu:);
        if ([parentVC respondsToSelector:replyAction]) {
            [parentVC performSelectorOnMainThread:replyAction withObject:infoDic waitUntilDone:true];
        }
    }
    
#pragma clang diagnostic pop

  
}

- (void)updateDisplay:(DirectoryElement*)element indexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if (element.imageLogo) {
        [btnColleview setImage:element.imageLogo forState:UIControlStateNormal];
    }else{
        [btnColleview setImage:[UIImage imageNamed:@"DontRecognize.png"] forState:UIControlStateNormal];
    }
    nameLable.text = element.name;
  
}
- (void)setHighlighted:(BOOL)highlighted
{
    highlighted?(self.backgroundColor = [UIColor lightGrayColor]):(self.backgroundColor = [UIColor whiteColor]);
}

@end
