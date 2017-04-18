//
//  FMHomePageViewController.h
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMForTabViewController.h"
#import "FileManageCommon.h"
#import "EntityCommon.h"
typedef NS_ENUM (NSInteger, FileStyle) {
    FileDefault = 0,
    FileEditorMove =1,
    FileEditorCopy =2,
    };

@interface FMHomePageViewController : FMForTabViewController

{
    
    __weak IBOutlet UICollectionView *collectionView;
    __weak IBOutlet UIToolbar *tooBarView;
}
@property (nonatomic,assign) FileStyle fileStyleType;
@property (nonatomic,strong) DirectoryElement * editorFromElement;
- (IBAction)cancallBtnClick:(id)sender;
- (IBAction)determineBtnClick:(id)sender;
- (void)openFileName:(NSString *)path withTitle:(NSString*)title;
@end
