//
//  EntityCommon.h
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EntityCommon : NSObject

typedef enum{
    //普通文件
    ElementType_NomalFiles = 0,
    //文件夹
    ElementType_Folder = 1,
    //文档文件
    ElementType_text ,
    //压缩
    ElementType_zip ,
    //声音
    ElementType_MP3 ,
    //图形文件
    ElementType_photo ,
    //视频
    ElementType_vedio
    
}ElementLocationType;

@end

@interface DirectoryElement : NSObject
//文件名称
@property (strong, nonatomic) NSString      *name;
//文件名称(大写)
@property (strong, nonatomic) NSString      *nameForSort;
//绝对路径
@property (strong, nonatomic) NSString      *path;
//特定为ElementType_NomalFiles，文件大小
@property (assign, nonatomic) UInt64        fileSize;
//特定为ElementType_Folder，文件夹中子文件数目
@property (assign, nonatomic) NSInteger     numChilds;
//UI是否选中该文件或文件夹标识
@property (assign, nonatomic) BOOL          selected;
//创建时间
@property (strong, nonatomic) NSDate        *date;
//修改时间
@property (strong, nonatomic) NSDate        *modificationDate;
//特定为ElementType_NomalFiles，文件扩展名(大写)
@property (strong, nonatomic) NSString      *fileExtension;
//类型
@property (assign, nonatomic) NSInteger     elementType;
//备于特殊用途，如存储上传到Dropbox的路径或其他。
@property (strong, nonatomic) NSString      *specialPath;

//property for photos in camera.
//URL
@property (strong, nonatomic) NSURL         *url;
//缩略图
@property (strong, nonatomic) UIImage       *imageLogo;

@end
