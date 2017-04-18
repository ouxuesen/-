//
//  FMHomePageViewController.m
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMHomePageViewController.h"
#import "FMCollectionViewCell.h"
#import "FMWebViewController.h"
#import "KxMovieViewController.h"
#import "Main.h"
#import "MCPhotoShowViewController.h"
#import "CoreBlueToothCentral.h"
#import "TranssionProcessView.h"

static NSString* CellIdentifier = @"FMCollectionViewCell" ;
@interface FMHomePageViewController ()<UIAlertViewDelegate,CoreBlueToothCentralDelegate>
{
    NSMutableArray * contenArray;
    NSString * _filePath;
    NSString * _title;
    NSIndexPath * _currentIndexpath;
    UIDocumentInteractionController *_documentController;
    UIMenuController *copyMenu;
    CoreBlueToothCentral  * cental;
    TranssionProcessView * showTranssionView;
}
@end

@implementation FMHomePageViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //监控 app 活动状态，打电话/锁屏 时暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (collectionView) {
         [self refreshDataFromFile];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _title;
    
     contenArray = [FileManageCommon getFolderContents:_filePath];
   
    FLOG(@"contenArray = %@",contenArray);
      [collectionView registerNib:[UINib nibWithNibName:@"FMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    if (_fileStyleType != FileDefault) {
        [collectionView setContentInset:UIEdgeInsetsMake(10, 10, 44, 10)];
    }else{
       tooBarView.hidden = YES;
      [collectionView setContentInset:UIEdgeInsetsMake(10, 10, 0, 10)];  
    }
    
}

- (void)openFileName:(NSString *)path withTitle:(NSString*)title
{
    _filePath = path;
    _title = title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [contenArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMCollectionViewCell * cell = [collectionView1 dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell updateDisplay:contenArray[indexPath.row] indexPath:indexPath];
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
    DirectoryElement *element =contenArray[indexPath.row];
    if (element.elementType == ElementType_Folder) {
        FMHomePageViewController * homePageVC =[[FMHomePageViewController alloc]initWithNibName:@"FMHomePageViewController" bundle:nil];
        [homePageVC openFileName:element.path withTitle:element.name];
         homePageVC.fileStyleType = _fileStyleType;
         homePageVC.editorFromElement = _editorFromElement;
        [self.navigationController pushViewController:homePageVC animated:YES];
        
    }else if(element.elementType == ElementType_vedio){
        NSString *path = element.path;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        // increase buffering for .wmv, it solves problem with delaying audio frames
        if ([path.pathExtension isEqualToString:@"wmv"])
            parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
        
        // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
        
        // disable buffering
        //parameters[KxMovieParameterMinBufferedDuration] = @(0.0f);
        //parameters[KxMovieParameterMaxBufferedDuration] = @(0.0f);
        
        KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
                                                                                   parameters:parameters];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(element.elementType == ElementType_photo){
        MCPhotoShowViewController *showVC = [[MCPhotoShowViewController alloc] initWithNibName:@"MCPhotoShowViewController" bundle:nil];
        showVC.dataSourceArray = @[element];
    
        showVC.currentIndex = 0;
        [self.navigationController pushViewController:showVC animated:true];
        
    }else{
        NSString * patch = [[NSBundle mainBundle] pathForResource:@"Mime.plist" ofType:nil];
        NSDictionary * mimetDic = [NSDictionary dictionaryWithContentsOfFile:patch];
        for (NSString * suffixString in mimetDic.allKeys) {
            NSString * suffix_1 = [suffixString substringFromIndex:1];
            if ([element.name.pathExtension isEqualToString:suffix_1]) {
                FMWebViewController * webViewVC = [[FMWebViewController alloc]init];
                [webViewVC postMIMEWithUrl:element.path title:element.name mimet:mimetDic[suffixString]];
                [self.navigationController pushViewController:webViewVC animated:YES];
                return;
            }
        }
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma -- 进入前段的通知
-(void)appEnterForeground:(NSNotificationCenter*)not
{
    [self refreshDataFromFile];
}
- (void)refreshDataFromFile
{
    contenArray = [FileManageCommon getFolderContents:_filePath];
    [collectionView reloadData];
}
#pragma -- copyMenu:

-(void)copyMenu:(id)info
{
    if (!info) {
        return;
    }
    if (self.fileStyleType != FileDefault) {
        return;
    }

    CGRect rect = CGRectFromString(info[@"rect"]) ;
    _currentIndexpath =info[@"indexPath"];
    DirectoryElement *element =contenArray[_currentIndexpath.row];
    NSMutableArray * itemsArray =[NSMutableArray new];
    if (!copyMenu) {
        copyMenu = [UIMenuController sharedMenuController];
        
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"打开方式"action:@selector(OpenTheWay:)];
        [itemsArray addObject:copyItem];
        UIMenuItem *copyItem_1 = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(DeleteAction:)];
        [itemsArray addObject:copyItem_1];
        if (element.elementType == ElementType_zip) {
            UIMenuItem *copyItem_2 = [[UIMenuItem alloc] initWithTitle:@"解压缩"action:@selector(OpenZipAction:)];
            [itemsArray addObject:copyItem_2];
        }else{
            UIMenuItem *copyItem_3 = [[UIMenuItem alloc] initWithTitle:@"压缩"action:@selector(ZipAction:)];
            [itemsArray addObject:copyItem_3];
        }
        UIMenuItem *copyItem_4 = [[UIMenuItem alloc] initWithTitle:@"移动"action:@selector(moveFileAction:)];
        [itemsArray addObject:copyItem_4];
        UIMenuItem *copyItem_5 = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyFileAction:)];
        [itemsArray addObject:copyItem_5];
        UIMenuItem *copyItem_6= [[UIMenuItem alloc] initWithTitle:@"重命名"action:@selector(renameFileAction:)];
        [itemsArray addObject:copyItem_6];
        UIMenuItem *copyItem_7= [[UIMenuItem alloc] initWithTitle:@"蓝牙传输"action:@selector(transmissionAction:)];
        [itemsArray addObject:copyItem_7];
        
        [copyMenu setMenuItems:itemsArray];
        
        [copyMenu update];
       
    }
    
    [copyMenu setTargetRect:rect inView:self.view];
    [copyMenu setMenuVisible:YES animated:YES];
    [self becomeFirstResponder];
}
//蓝牙传输
- (void)transmissionAction:(UIMenuItem*)item
{
    DirectoryElement *element =contenArray[_currentIndexpath.row];
    if (!cental) {
         cental = [[CoreBlueToothCentral alloc]init];
         cental.delegate = self;
    }
   
    [cental disConnect];
    [cental transmissionDataFromDirectoryElement:element];
    
    [self cretatShowTranssionView];
}
#pragma --daili 

- (void)cretatShowTranssionView
{
    if (!showTranssionView) {
        showTranssionView = [[NSBundle mainBundle]loadNibNamed:@"TranssionProcessView" owner:self options:nil][0];
    }
//    [showTranssionView autoRemoveConstraintsAffectingView];
    [self.view addSubview:showTranssionView];
    [showTranssionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}
- (void)transmissionData:(CGFloat)tollLength :(CGFloat)currntLength
{
    FLOG(@"传送了%.2f /%.2f",currntLength,tollLength);
    [showTranssionView updateShowStateLable:[NSString stringWithFormat:@"已经传输 %.0f /%.0f",currntLength,tollLength] chrysanthemumState:NO];
}
- (void)transmissionDataComplete
{
     FLOG(@"传送完成");
    [showTranssionView updateShowStateLable:@"传送完成" chrysanthemumState:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,0.25* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [showTranssionView dissPresentFormSuperView];
    });
    [cental disConnect];
    cental = nil;
}
- (void)transmissionDataFault
{
     [showTranssionView updateShowStateLable:@"传送失败" chrysanthemumState:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,0.25* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [showTranssionView dissPresentFormSuperView];
    });
    cental = nil;
}

- (void)OpenTheWay:(UIMenuItem*)item
{
    DirectoryElement *element =contenArray[_currentIndexpath.row];
    
   _documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:element.path]];
    CGRect rect = self.view.frame;
//    这里有两种打开方式，一种是快速预览模式，一种是第三方应用打开模式
      BOOL open = [_documentController presentOptionsMenuFromRect:rect inView:self.view animated:YES];
    
    if (open) {
        
    }else{
        
    }
//       [_documentController presentOpenInMenuFromRect:rect inView:self.view animated:YES];
}
- (void)DeleteAction:(UIMenuItem*)item
{
    DirectoryElement *element =contenArray[_currentIndexpath.row];
    [FileManageCommon deleteFileFullPath:element.path];
    [contenArray removeObject:element];
    [collectionView reloadData];
}
- (void)OpenZipAction:(UIMenuItem*)item
{
    DirectoryElement *element =contenArray[_currentIndexpath.row];
//    NSString *destinationPath = @"path_to_the_folder_where_you_want_it_unzipped";

    [Main unzipFileAtPath:element.path
            toDestination:[NSString stringWithFormat:@"%@",element.path.stringByDeletingPathExtension]];
    
    [self refreshDataFromFile];
}
- (void)ZipAction:(UIMenuItem*)item
{
    // Zip Operation
    DirectoryElement *element =contenArray[_currentIndexpath.row];
    
    [Main createZipFileAtPath:[NSString stringWithFormat:@"%@.zip",element.path.stringByDeletingPathExtension] withFilesAtPaths:@[element.path]];
      [self refreshDataFromFile];
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma 编辑模式
- (void)moveFileAction:(UIMenuItem*)item
{
    // move file
   [self presentViewControllerWithFileType:FileEditorMove];
}
- (void)copyFileAction:(UIMenuItem*)item
{
    //copy file
    [self presentViewControllerWithFileType:FileEditorCopy];
}
//模式弹窗 1 move 2 copy
- (void)presentViewControllerWithFileType:(FileStyle)type
{
    FMHomePageViewController * homeVC =[[FMHomePageViewController alloc]initWithNibName:@"FMHomePageViewController" bundle:nil];
    NSString* rootPath = [FileManageCommon getRootDocumentPath:@""];
    [homeVC openFileName:rootPath withTitle:@"首页"];
    homeVC.fileStyleType = type;
    homeVC.editorFromElement = contenArray[_currentIndexpath.row];
    UINavigationController * niviVC = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [self.navigationController presentViewController:niviVC animated:YES completion:nil];
}
#pragma  --- toobar
- (IBAction)cancallBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)determineBtnClick:(id)sender {
    if (_fileStyleType == FileEditorMove) {
        [FileManageCommon moveFileFromFullPath:_editorFromElement.path toFullPatch:[NSString stringWithFormat:@"%@/%@",_filePath,_editorFromElement.name]];
    }else if (_fileStyleType == FileEditorCopy){
        [FileManageCommon copyFileFromFullPath:_editorFromElement.path toFullPatch:[NSString stringWithFormat:@"%@/%@",_filePath,_editorFromElement.name]];
       
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)renameFileAction:(UIMenuItem*)item
{
    // rename File
    DirectoryElement *element =contenArray[_currentIndexpath.row];
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"修改文件/文件夹的名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    UITextField * textField = [alertView textFieldAtIndex:0];
    textField.text = [[element.name componentsSeparatedByString:@"."] firstObject];
    [alertView show];
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex) {
         UITextField * textField = [alertView textFieldAtIndex:0];
          DirectoryElement *element =contenArray[_currentIndexpath.row];
        if ([textField.text length]) {
            [FileManageCommon renameFileFileFromFullPath:element.path withName:textField.text];
             [self refreshDataFromFile];
        }
       
    }
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
