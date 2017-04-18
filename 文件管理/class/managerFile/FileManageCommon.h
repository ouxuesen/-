//
//  FileManageCommon.h
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManageCommon : NSObject
/******************************************************************************
 函数名称 : + (NSString *)getRootDocumentPath:(NSString *)fileName
 函数描述 : 获取sandbox中Document文件夹中fileName的绝对路径
 输入参数 : (NSString *)fileName
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)getRootDocumentPath:(NSString *)fileName;

/******************************************************************************
 函数名称 : + (NSString *)getRootCachesPath:(NSString *)fileName
 函数描述 : 获取sandbox中Caches文件夹中fileName的绝对路径
 输入参数 : (NSString *)fileName
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)getRootCachesPath:(NSString *)fileName;

/******************************************************************************
 函数名称 : +(BOOL)isFileExists:(NSString *)fileFullPath
 函数描述 : 判断文件在绝对路径fileFullPath是否存在
 输入参数 : (NSString *)fileFullPath
 输出参数 : N/A
 返回参数 : (BOOL)
 备注信息 :
 ******************************************************************************/
+(BOOL)isFileExists:(NSString *)fileFullPath;

/******************************************************************************
 函数名称 : +(BOOL)createFolderIfNotExisting:(NSString *)folderFullPath
 函数描述 : 创建绝对路径folderFullPath文件夹,当文件夹不存在的时候
 输入参数 : (NSString *)folderFullPath
 输出参数 : N/A
 返回参数 : (BOOL)
 备注信息 :
 ******************************************************************************/
+(BOOL)createFolderIfNotExisting:(NSString *)folderFullPath;

/******************************************************************************
 函数名称 : +(NSString *)newFilePathForCreateFileAtPath:(NSString *)filePath
 函数描述 : 当创建文件存在重名时，则重命名该文件（格式:文件名(数字).扩展名）
 输入参数 : (NSString *)filePath
 输出参数 : N/A
 返回参数 : (BOOL)
 备注信息 :
 ******************************************************************************/
+(NSString *)newFilePathForCreateFileAtPath:(NSString *)filePath;

/******************************************************************************
 函数名称 : + (NSMutableArray *)getFolderContents:(NSString *)folderFullPath
 函数描述 : 返回绝对路径folderfullPath中的所有文件及文件夹
 输入参数 : (NSString *)folderFullPath
 输出参数 : N/A
 返回参数 : (NSMutableArray *)
 备注信息 :
 ******************************************************************************/
+ (NSMutableArray *)getFolderContents:(NSString *)folderFullPath;

/******************************************************************************
 函数名称 : + (NSInteger)getFolderCount:(NSString *)folderFullPath
 函数描述 : 返回绝对路径folderFullPath中的所有文件总数量
 输入参数 : (NSString *)folderFullPath
 输出参数 : N/A
 返回参数 : (NSInteger)
 备注信息 :
 ******************************************************************************/
+ (NSInteger)getFolderCount:(NSString *)folderFullPath;

/******************************************************************************
 函数名称 : + (UInt64 )getFolderSize:(NSString *)folderFullPath
 函数描述 : 返回绝对路径folderFullPath中的所有文件总大小
 输入参数 : (NSString *)folderFullPath
 输出参数 : N/A
 返回参数 : (UInt64)
 备注信息 :
 ******************************************************************************/
+ (UInt64)getFolderSize:(NSString *)folderFullPath;

/******************************************************************************
 函数名称 : + (UInt64 )getFolderSize:(NSString *)fileFullPath
 函数描述 : 返回绝对路径fileFullPath中的文件大小
 输入参数 : (NSString *)fileFullPath
 输出参数 : N/A
 返回参数 : (UInt64)
 备注信息 :
 ******************************************************************************/
+ (UInt64) getFileSize:(NSString *)fileFullPath;

/******************************************************************************
 函数名称 : + (UInt64) getFileArraySize:(NSArray *)fileFullPathArray
 函数描述 : 返回fileFullPathArray中的绝对路径文件总大小
 输入参数 : (NSString *)fileFullPathArray
 输出参数 : N/A
 返回参数 : (UInt64)
 备注信息 :
 ******************************************************************************/
+ (UInt64) getFileArraySize:(NSArray *)fileFullPathArray;

/******************************************************************************
 函数名称 : +(BOOL)isPhotoFile:(NSString *)fileName
 函数描述 : fileName文件是否是符合要求的图片格式
 输入参数 : (NSString *)fileName
 输出参数 : N/A
 返回参数 : (BOOL)
 备注信息 :
 ******************************************************************************/
+(BOOL)isVedioFile:(NSString *)fileName;
+(BOOL)isPhotoFile:(NSString *)fileName;

/******************************************************************************
 函数名称 : + (NSMutableArray *)filterPhotosFromArray:(NSMutableArray *)elementArray
 函数描述 : elementArray中的文件是否是符合要求的图片格式
 输入参数 : (NSMutableArray *)elementArray
 输出参数 : N/A
 返回参数 : (NSMutableArray *)
 备注信息 :
 ******************************************************************************/
+ (NSMutableArray *)filterPhotosFromArray:(NSMutableArray *)elementArray;

/******************************************************************************
 函数名称 : + (NSString *)stringForAllFileSize:(UInt64)fileSize
 函数描述 : 格式话返回文件大小
 输入参数 : (UInt64)fileSize
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)stringForAllFileSize:(UInt64)fileSize;
//创建文件类型 非文件夹
+(BOOL)createFileIfNotExisting:(NSString *)folderFullPath;
// 删除绝对路径的文件
+ (BOOL)deleteFileFullPath:(NSString *)fileFullPath;
//拷贝文件
+(BOOL)copyFileDataFromFullPath:(NSString *)fromPath toFullPatch:(NSString *)toPatch;
//拷贝文件夹
+(BOOL)copyFileFromFullPath:(NSString *)fromPath toFullPatch:(NSString *)toPatch;
//获取外部程序传入 inBox的信息
+(NSArray*)getFileFormInbox;
//移动文件
+(BOOL)moveFileFromFullPath:(NSString*)fromPath toFullPatch:(NSString*)toPatch;
//重命名
+ (BOOL)renameFileFileFromFullPath:(NSString*)fromPath withName:(NSString*)newName;
//拿到所有相片文件
+ (NSMutableArray *)filterPhotosFromFullPath:(NSString*)fromPath;
@end
