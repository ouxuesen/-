//
//  FMbaseTableViewCell.h
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (PSTableCellTableViewCell)

- (id)tableViewDelegate;
- (UITableView *)superTableView;

@end

@interface FMbaseTableViewCell : UITableViewCell
{
    id _dataInfo;
    NSIndexPath *_indexPath;
}

@property(nonatomic, strong) UILabel *separatorLine;
@property(nonatomic, strong) UILabel *topLine;

@property(nonatomic, strong) id dataInfo;
@property(nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)heightForCellWithData:(id)data andType:(NSInteger)type;
+ (CGFloat)heightForCellWithData;
- (void)initTopLine;
- (void)initTopLineWithEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)initSeparatorLine;
- (void)initSeparatorLineWithEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)initBottomLineWithEdgeInsets:(UIEdgeInsets)edgeInsets ;
- (void)updateDisplay;

- (UIScrollView *)nearsetScrollView;
- (void)initWithData:(id)data indexPath:(NSIndexPath *)indexPath;

@end
