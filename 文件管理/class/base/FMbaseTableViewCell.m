//
//  FMbaseTableViewCell.m
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMbaseTableViewCell.h"

@implementation UITableViewCell (MCBaseTableCell)

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

- (id)tableViewDelegate
{
    UITableView *tableView = [self superTableView];
    
    if (tableView) {
        return tableView.delegate;
    }
    
    return nil;
}

- (UITableView *)superTableView
{
    id view = [self superview];
    
    while (view && ![view isKindOfClass:[UITableView class]]) {
        view = [view superview];
    }
    
    return (UITableView *)view;
}

@end


@interface FMbaseTableViewCell ()
{
    UIWebView * phoneCallWebView ;
}

@end


@implementation FMbaseTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)initTopLine
{
    [self initTopLineWithEdgeInsets:UIEdgeInsetsZero];
}

- (void)initTopLineWithEdgeInsets:(UIEdgeInsets)edgeInsets
{
    if (!_topLine) {
        _topLine = [[UILabel alloc] init];
        _topLine.backgroundColor = RGBACOLOR(200 , 199, 204,1);
        [self.contentView addSubview:_topLine];
        
        [_topLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [_topLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:edgeInsets.left];
        [_topLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:edgeInsets.right- 30];
        [_topLine autoSetDimension:ALDimensionHeight toSize:0.5];
        
    }
    
    [self.contentView bringSubviewToFront:_topLine];
    
    self.clipsToBounds = true;
    
    if (_indexPath.row) {
        _topLine.hidden = true;
    }else{
        _topLine.hidden = false;
    }
}
- (void)initBottomLineWithEdgeInsets:(UIEdgeInsets)edgeInsets ;
{
    [self initSeparatorLineWithEdgeInsets:edgeInsets];
    
}

- (void)initSeparatorLine
{
    [self initSeparatorLineWithEdgeInsets:UIEdgeInsetsZero];
}

- (void)initSeparatorLineWithEdgeInsets:(UIEdgeInsets)edgeInsets
{
    if (!_separatorLine) {
        _separatorLine = [[UILabel alloc] init];
        _separatorLine.backgroundColor = RGBACOLOR(200 , 199, 204,1);
        [self.contentView addSubview:_separatorLine];
        
        [_separatorLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:edgeInsets.left];
        [_separatorLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:edgeInsets.right- 30];
        [_separatorLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.5];
        [_separatorLine autoSetDimension:ALDimensionHeight toSize:0.5];
    }
    
    [self.contentView bringSubviewToFront:_separatorLine];
}

- (void)initWithData:(id)data indexPath:(NSIndexPath *)indexPath
{
    _dataInfo = data;
    _indexPath = indexPath;
    
    [self updateDisplay];
}


- (void)updateDisplay
{
    
}
+ (CGFloat)heightForCellWithData:(id)data andType:(NSInteger)type
{
    return 44;
}
+ (CGFloat)heightForCellWithData
{
    return 44;
}
#pragma mark - 获取父 ScrollView
- (UIScrollView *)nearsetScrollView
{
    UIScrollView *scrollView = nil;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIScrollView class]]) {
            if (![[(UIScrollView *)nextResponder superview] isKindOfClass:[UITableViewCell class]]) {
                scrollView = (UIScrollView *)nextResponder;
                break;
            }
        }
    }
    return scrollView;
}


@end
