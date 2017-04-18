//
//  FileManageCommon.m
//  文件管理
//
//  Created by oxs on 15/8/25.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FileManageCommon.h"

#import "EntityCommon.h"

#define DefaultFileManager              [NSFileManager defaultManager]

#define DefaultDocumentPath             NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)

#define DefaultCaches                   NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)

#define Localizable_LF_Size_Bytes                                   @"size: %lld Bytes"
#define Localizable_LF_Size_K                                       @"size: %lld K"
#define Localizable_LF_Size_M                                       @"size: %lld.%lld M"
#define Localizable_LF_Size_G                                       @"size: %lld.%d G"
#define Localizable_LF_All_Size_M                                   @"size: %lld.%lld M"
#define Localizable_LF_All_Size_G                                   @"size: %lld.%lld G"

@implementation FileManageCommon

/******************************************************************************
 函数名称 : + (NSString *)getRootDocumentPath:(NSString *)fileName
 函数描述 : 获取sandbox中Document文件夹中fileName的绝对路径
 输入参数 : (NSString *)fileName
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)getRootDocumentPath:(NSString *)fileName
{
    return [[DefaultDocumentPath objectAtIndex:0] stringByAppendingPathComponent:fileName];
}

/******************************************************************************
 函数名称 : + (NSString *)getRootCachesPath:(NSString *)fileName
 函数描述 : 获取sandbox中Caches文件夹中fileName的绝对路径
 输入参数 : (NSString *)fileName
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)getRootCachesPath:(NSString *)fileName
{
    return [[DefaultCaches objectAtIndex:0] stringByAppendingPathComponent:fileName];
}

/******************************************************************************
 函数名称 : +(BOOL)isFileExists:(NSString *)fileFullPath
 函数描述 : 判断文件在绝对路径fileFullPath是否存在
 输入参数 : (NSString *)fileFullPath
 输出参数 : N/A
 返回参数 : (BOOL)
 备注信息 :
 ******************************************************************************/
+(BOOL)isFileExists:(NSString *)fileFullPath
{
    return    [DefaultFileManager fileExistsAtPath:fileFullPath];
}

/******************************************************************************
 函数名称 : +(BOOL)createFolderIfNotExisting:(NSString *)folderFullPath
 函数描述 : 创建绝对路径folderFullPath文件夹,当文件夹不存在的时候
 输入参数 : (NSString *)folderFullPath
 输出参数 : N/A
 返回参数 : (BOOL)
 备注信息 :
 ******************************************************************************/
+(BOOL)createFolderIfNotExisting:(NSString *)folderFullPath
{
    //Only create if the folder does not exists yet.
    if (![DefaultFileManager fileExistsAtPath:folderFullPath])
    {
        NSError* error;
        [DefaultFileManager createDirectoryAtPath:folderFullPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"error = %@",error);
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
}

/******************************************************************************
 函数名称 : +(NSString *)newFilePathForCreateFileAtPath:(NSString *)fileFullPath
 函数描述 : 当创建文件存在重名时，则重命名该文件（格式:文件名(数字).扩展名）
 输入参数 : (NSString *)filePath
 输出参数 : N/A
 返回参数 : (BOOL)
 备注信息 :
 ******************************************************************************/
+(NSString *)newFilePathForCreateFileAtPath:(NSString *)fileFullPath
{
    NSString *newFilePath = fileFullPath;
    int i = 2;
    while([FileManageCommon isFileExists:newFilePath])
    {
        newFilePath = fileFullPath;
        //文件名
        NSString *newFilePathWithoutExtenion = [newFilePath stringByDeletingPathExtension];
        //扩展名
        NSString *newFilePathExtentension = [newFilePath pathExtension];
        newFilePath = [NSString stringWithFormat:@"%@(%d).%@",newFilePathWithoutExtenion,i,newFilePathExtentension];
        i++;
    }
    return newFilePath;
}

/******************************************************************************
 函数名称 : + (NSMutableArray *)getFolderContents:(NSString *)folderFullPath
 函数描述 : 返回绝对路径folderfullPath中的所有文件及文件夹
 输入参数 : (NSString *)folderFullPath
 输出参数 : N/A
 返回参数 : (NSMutableArray *)
 备注信息 :
 ******************************************************************************/
+ (NSMutableArray *)getFolderContents:(NSString *)folderFullPath
{
    NSMutableArray *files = [[NSMutableArray alloc] init];
    NSArray *directoryContent = [DefaultFileManager contentsOfDirectoryAtPath:folderFullPath error:nil];
    for(NSString *fileName in directoryContent)
    {
        NSString *fileFullPath = [folderFullPath stringByAppendingPathComponent:fileName];
        //获取普通文件或文件夹详细信息
        NSDictionary *fileAttributes = [DefaultFileManager attributesOfItemAtPath:fileFullPath error:nil];
        if (!fileAttributes) {
            continue;
        }
        if([fileName isEqualToString:@"Inbox"])
        {
            continue;
        }//模拟器中测试过滤条件
        if([fileName isEqualToString:@".DS_Store"])
        {
            continue;
        }
        //目录元素
        DirectoryElement *element = [[DirectoryElement alloc] init];
        //绝对路径
        element.path = fileFullPath;
        //文件名称
        element.name = fileName;
        NSLog(@"%@", fileName);
        //文件名称(大写)
        element.nameForSort = [fileName uppercaseString];
        //文件创建日期
        element.date = [fileAttributes objectForKey:NSFileCreationDate];
        //文件修改日期
        element.modificationDate = [fileAttributes objectForKey:NSFileModificationDate];
        
        NSString *fileType = [fileAttributes objectForKey:NSFileType];
        if([fileType isEqualToString:NSFileTypeDirectory])
        {
            //类型:文件夹
            element.elementType = ElementType_Folder;
            //文件夹中子文件数目
            element.numChilds = [[DefaultFileManager contentsOfDirectoryAtPath:fileFullPath error:nil] count];
            UIImage * iamge = [UIImage imageNamed:@"folder.png"];
            element.imageLogo = iamge;

        }
        else
        {
            //类型:普通文件
            element.elementType = ElementType_NomalFiles;
            //文件大小
            element.fileSize = [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
            //扩展名(大写)
            element.fileExtension = [[fileName pathExtension] uppercaseString];
            if ([self isPhotoFile:fileName]) {
                UIImage * iamge = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",folderFullPath,fileName]];
                element.imageLogo =(iamge.size.height<70&&iamge.size.width<70)?iamge :[iamge imageClipedSetFitSize:CGSizeMake(70, 70)];
                element.elementType = ElementType_photo;
            }else if ([self isVedioFile:fileName]){
                 UIImage * iamge = [UIImage imageNamed:@"vedio.png"];
                element.imageLogo = iamge;
                element.elementType = ElementType_vedio;
            }else if ([self isOtherFile:fileName :element]){
                
            }
        }
        [files addObject:element];
    }
    return files;
}

/******************************************************************************
 函数名称 : + (NSInteger)getFolderCount:(NSString *)folderFullPath
 函数描述 : 返回绝对路径folderFullPath中的所有文件总数量
 输入参数 : (NSString *)folderFullPath
 输出参数 : N/A
 返回参数 : (NSInteger)
 备注信息 :
 ******************************************************************************/
+ (NSInteger)getFolderCount:(NSString *)folderFullPath
{
    NSInteger fileCount = 0;
    NSArray *folderContentsArray = [DefaultFileManager contentsOfDirectoryAtPath:folderFullPath error:nil];
    for(NSString *name in folderContentsArray)
    {
        if([name isEqualToString:@"Inbox"])
        {
            continue;
        }
        NSString *fileName = [folderFullPath stringByAppendingPathComponent:name];
        NSDictionary *fileAttributes = [DefaultFileManager attributesOfItemAtPath:fileName error:nil];
        NSString *fileType = [fileAttributes objectForKey:NSFileType];
        if([fileType isEqualToString:NSFileTypeDirectory])
        {
            NSString *currentPath = [folderFullPath stringByAppendingPathComponent:name];
            fileCount = fileCount + [FileManageCommon getFolderCount:currentPath];
        }
        else
        {
            fileCount++;
        }
    }
    return fileCount;
}

/******************************************************************************
 函数名称 : + (UInt64 )getFolderSize:(NSString *)folderFullPath
 函数描述 : 返回绝对路径folderFullPath中的所有文件总大小
 输入参数 : (NSString *)folderFullPath
 输出参数 : N/A
 返回参数 : (UInt64)
 备注信息 :
 ******************************************************************************/
+ (UInt64)getFolderSize:(NSString *)folderFullPath
{
    UInt64 folderSize = 0;
    NSArray *folderContentsArray = [DefaultFileManager contentsOfDirectoryAtPath:folderFullPath error:nil];
    for(NSString *name in folderContentsArray)
    {
        if([name isEqualToString:@"Inbox"])
        {
            continue;
        }
        NSString *fileName = [folderFullPath stringByAppendingPathComponent:name];
        NSDictionary *fileAttributes = [DefaultFileManager attributesOfItemAtPath:fileName error:nil];
        NSString *fileType = [fileAttributes objectForKey:NSFileType];
        if([fileType isEqualToString:NSFileTypeDirectory])
        {
            NSString *currentPath = [folderFullPath stringByAppendingPathComponent:name];
            folderSize = folderSize + [FileManageCommon getFolderSize:currentPath];
        }
        else
        {
            UInt64 fileSize = [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
            folderSize = folderSize + fileSize;
        }
    }
    return folderSize;
}

/******************************************************************************
 函数名称 : + (UInt64 )getFolderSize:(NSString *)fileFullPath
 函数描述 : 返回绝对路径fileFullPath中的文件大小
 输入参数 : (NSString *)fileFullPath
 输出参数 : N/A
 返回参数 : (UInt64)
 备注信息 :
 ******************************************************************************/
+ (UInt64) getFileSize:(NSString *)fileFullPath
{
    NSDictionary *fileAttributes = [DefaultFileManager attributesOfItemAtPath:fileFullPath error:nil];
    UInt64 fileSize = [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
    return fileSize;
}

/******************************************************************************
 函数名称 : + (UInt64) getFileArraySize:(NSArray *)fileFullPathArray
 函数描述 : 返回fileFullPathArray中的绝对路径文件总大小
 输入参数 : (NSString *)fileFullPathArray
 输出参数 : N/A
 返回参数 : (UInt64)
 备注信息 :
 ******************************************************************************/
+ (UInt64) getFileArraySize:(NSArray *)fileFullPathArray
{
    UInt64 fileArraySize = 0;
    for(NSString *filePath in fileFullPathArray){
        fileArraySize +=[FileManageCommon getFileSize:filePath];
    }
    
    return fileArraySize;
}

/******************************************************************************
 函数名称 : + (BOOL)isPhotoFile:(NSString *)fileName
 函数描述 : fileName文件是否是符合要求的图片格式
 输入参数 : (NSString *)fileName
 输出参数 : N/A
 返回参数 : (BOOL)
 备注信息 :
 ******************************************************************************/
//是否图像文件
+ (BOOL)isPhotoFile:(NSString *)fileName
{
    NSString *fileType = [[fileName pathExtension] uppercaseString];
    if ([fileType isEqualToString:@"PNG"]) {
        return YES;
    }else if ([fileType isEqualToString:@"JPG"]) {
        return YES;
    }else if ([fileType isEqualToString:@"JPEG"]) {
        return YES;
    }else if ([fileType isEqualToString:@"GIF"]) {
        return YES;
    }else if ([fileType isEqualToString:@"BMP"]) {
        return YES;
    }else if ([fileType isEqualToString:@"TIP"]) {
        return YES;
    }else if ([fileType isEqualToString:@"TIFF"]) {
        return YES;
    }else if ([fileType isEqualToString:@"TIF"]) {
        return YES;
    }else{
        return NO;
    }
}
//是否视频文件
+ (BOOL)isVedioFile:(NSString *)fileName
{
    NSString *ext = fileName.pathExtension.lowercaseString;
    
    if ([ext isEqualToString:@"mp3"] ||
        [ext isEqualToString:@"caff"]||
        [ext isEqualToString:@"aiff"]||
        [ext isEqualToString:@"ogg"] ||
        [ext isEqualToString:@"wma"] ||
        [ext isEqualToString:@"m4a"] ||
        [ext isEqualToString:@"m4v"] ||
        [ext isEqualToString:@"wmv"] ||
        [ext isEqualToString:@"3gp"] ||
        [ext isEqualToString:@"mp4"] ||
        [ext isEqualToString:@"mov"] ||
        [ext isEqualToString:@"avi"] ||
        [ext isEqualToString:@"mkv"] ||
        [ext isEqualToString:@"mpeg"]||
        [ext isEqualToString:@"mpg"] ||
        [ext isEqualToString:@"flv"] ||
        [ext isEqualToString:@"vob"] ||
        [ext isEqualToString:@"rmvb"]){
        return YES;
    }
    return NO;
}
//包裹文档文件 压缩文件 声音文件
+ (BOOL)isOtherFile:(NSString *)fileName :(DirectoryElement *)element
{
    NSString *ext = fileName.pathExtension.lowercaseString;
    NSString * patch = [[NSBundle mainBundle] pathForResource:@"PropertyList.plist" ofType:nil];
    NSArray * folerArray = [NSArray arrayWithContentsOfFile:patch];
    for (NSDictionary* dic in folerArray) {
        for (NSString*suffixString in [self textParsingWith:dic[@"suffix"]]) {
            if ([suffixString isEqualToString:ext]) {
                element.elementType = [dic[@"type"] integerValue];
                element.imageLogo = [UIImage imageNamed:dic[@"image"]];
                FLOG(@"该文件类型  type= %@",dic[@"title"]);
                return YES;
            }
        }
    }
    
    return NO;
}
+ (NSArray*)textParsingWith:(NSString*)conteString
{
    NSMutableArray * tempArray =[NSMutableArray new];
   NSArray* textArray = [conteString componentsSeparatedByCharactersInSet: [NSCharacterSet
                                                                     characterSetWithCharactersInString:@"、（）"]] ;
    for (NSString * string in textArray) {
        NSString *strContent = [[string mutableCopy] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (string.length<=5&&string.length>0) {
            [tempArray addObject:strContent];
        }
      
    }
    return tempArray;
}
#pragma -- 以上判断仅是判断使用图表  打开方式不再
/******************************************************************************
 函数名称 : + (NSMutableArray *)filterPhotosFromArray:(NSMutableArray *)elementArray
 函数描述 : elementArray中的文件是否是符合要求的图片格式
 输入参数 : (NSMutableArray *)elementArray
 输出参数 : N/A
 返回参数 : (NSMutableArray *)
 备注信息 :
 ******************************************************************************/
+ (NSMutableArray *)filterPhotosFromArray:(NSMutableArray *)elementArray
{
    NSMutableArray *paramArrayOfPhotos = [[NSMutableArray alloc] init];
    for (DirectoryElement *element in elementArray)
    {
        if(element.elementType == ElementType_NomalFiles)
        {
            if ([self isPhotoFile:element.name]) {
                [paramArrayOfPhotos addObject:element];
            }
        }
    }
    return paramArrayOfPhotos;
}

/******************************************************************************
 函数名称 : + (NSString *)stringForAllFileSize:(UInt64)fileSize
 函数描述 : 格式话返回文件大小
 输入参数 : (UInt64)fileSize
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)stringForAllFileSize:(UInt64)fileSize
{
    if (fileSize<1024) {//Bytes/Byte
        if (fileSize>1) {
            return [NSString stringWithFormat:Localizable_LF_Size_Bytes,
                    fileSize];
        }else {//==1 Byte
            return [NSString stringWithFormat:Localizable_LF_Size_Bytes,
                    fileSize];
        }
    }
    if ((1024*1024)>(fileSize)&&(fileSize)>1024) {//K
        return [NSString stringWithFormat:Localizable_LF_Size_K,
                fileSize/1024];
    }
    
    if ((1024*1024*1024)>fileSize&&fileSize>(1024*1024)) {//M
        return [NSString stringWithFormat:Localizable_LF_All_Size_M,
                fileSize/(1024*1024),
                fileSize%(1024*1024)/(1024*102)];
    }
    if (fileSize>(1024*1024*1024)) {//G
        return [NSString stringWithFormat:Localizable_LF_All_Size_G,
                fileSize/(1024*1024*1024),
                fileSize%(1024*1024*1024)/(1024*1024*102)];
    }
    return nil;
}
+ (BOOL)deleteFileFullPath:(NSString *)fileFullPath
{
    NSError *error = nil;
    [DefaultFileManager removeItemAtPath:fileFullPath error:&error];
    if (error) {
        FLOG(@"error = %@",error);
        return NO;
    }else{
        return YES;
    }
}
//文件拷贝
+(BOOL)copyFileDataFromFullPath:(NSString *)fromPath toFullPatch:(NSString *)toPatch
{

    NSString *srcPath=fromPath;
    NSString *tarPath=toPatch;
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL success=[[NSFileManager defaultManager] createFileAtPath:toPatch contents:nil attributes:nil];
    if (success) {

        
        NSLog(@"文件创建成功");
        
        NSFileHandle *inFile=[NSFileHandle fileHandleForReadingAtPath:srcPath];
        NSFileHandle *outFile=[NSFileHandle fileHandleForWritingAtPath:tarPath];
        if (!inFile||!outFile) {
            return NO;
        }
        NSDictionary   *fileAttu=[fileManager attributesOfItemAtPath:srcPath error:nil];
        NSNumber *fileSizeNum=[fileAttu objectForKey:NSFileSize];
        
        int n=0;
        
        BOOL isEnd=YES;
        NSInteger readSize=0;//已经读取的数量
        NSInteger fileSize=[fileSizeNum longValue];//文件的总长度
        while (isEnd) {
            
            if (n%10==0) {
                
            }
            NSInteger subLength=fileSize-readSize;
            NSData *data=nil;
            if (subLength<5000) {
                isEnd=NO;
                data=[inFile readDataToEndOfFile];
                
            }else{
                data=[inFile readDataOfLength:5000];
                readSize+=5000;
                [inFile seekToFileOffset:readSize];
            }
            [outFile writeData:data];
            n++;
        }
        
        [inFile closeFile];
        [outFile closeFile];
        return YES;
    }
    return NO;
}
//文件夹拷贝
+(BOOL)copyFileFromFullPath:(NSString *)fromPath toFullPatch:(NSString *)toPatch
{
    NSError * error = nil;
    if (![DefaultFileManager fileExistsAtPath:fromPath]) {
        FLOG(@"fromPath 文件夹不存在");
        return NO;
    }
    if ([DefaultFileManager fileExistsAtPath:toPatch]) {
        FLOG(@"toPatch 文件夹已经存在");
        return NO;
    }
    BOOL flog =  [DefaultFileManager copyItemAtPath:fromPath toPath:toPatch error:&error];
    if (flog) {
        FLOG(@"复制成功");
        return YES;
    }
    if (error) {
        FLOG(@"error = %@",error);
    }
    return NO;

}
+(NSArray*)getFileFormInbox
{
    NSMutableArray * files= [NSMutableArray new];
    NSString* folderFullPath = [[DefaultDocumentPath objectAtIndex:0] stringByAppendingPathComponent:@"Inbox"];
    NSArray *directoryContent = [DefaultFileManager contentsOfDirectoryAtPath:folderFullPath error:nil];
    if (!directoryContent) {
        return nil;
    }
    for(NSString *fileName in directoryContent)
    {
        NSString *fileFullPath = [folderFullPath stringByAppendingPathComponent:fileName];
        //获取普通文件或文件夹详细信息
        NSDictionary *fileAttributes = [DefaultFileManager attributesOfItemAtPath:fileFullPath error:nil];
        if (!fileAttributes) {
            continue;
        }

        //模拟器中测试过滤条件
        if([fileName isEqualToString:@".DS_Store"])
        {
            continue;
        }
        //目录元素
        DirectoryElement *element = [[DirectoryElement alloc] init];
        //绝对路径
        element.path = fileFullPath;
        //文件名称
        element.name = fileName;
        NSLog(@"%@", fileName);
        //文件名称(大写)
        element.nameForSort = [fileName uppercaseString];
        //文件创建日期
        element.date = [fileAttributes objectForKey:NSFileCreationDate];
        //文件修改日期
        element.modificationDate = [fileAttributes objectForKey:NSFileModificationDate];
        
        NSString *fileType = [fileAttributes objectForKey:NSFileType];
        if([fileType isEqualToString:NSFileTypeDirectory])
        {
            //类型:文件夹
            element.elementType = ElementType_Folder;
            //文件夹中子文件数目
            element.numChilds = [[DefaultFileManager contentsOfDirectoryAtPath:fileFullPath error:nil] count];
            UIImage * iamge = [UIImage imageNamed:@"folder.png"];
            element.imageLogo = iamge;
            
        }
        else
        {
            //类型:普通文件
            element.elementType = ElementType_NomalFiles;
            //文件大小
            element.fileSize = [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
            //扩展名(大写)
            element.fileExtension = [[fileName pathExtension] uppercaseString];
            if ([self isPhotoFile:fileName]) {
                UIImage * iamge = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",folderFullPath,fileName]];
                element.imageLogo =(iamge.size.height<70&&iamge.size.width<70)?iamge :[iamge imageClipedSetFitSize:CGSizeMake(70, 70)];
                element.elementType = ElementType_photo;
            }else if ([self isVedioFile:fileName]){
                UIImage * iamge = [UIImage imageNamed:@"vedio.png"];
                element.imageLogo = iamge;
                element.elementType = ElementType_vedio;
            }else if ([self isOtherFile:fileName :element]){
                
            }
        }
        [files addObject:element];
    }
    return files;
}

+(BOOL)moveFileFromFullPath:(NSString*)fromPath toFullPatch:(NSString*)toPatch
{
     NSError * error = nil;
    if (![DefaultFileManager fileExistsAtPath:fromPath]) {
        FLOG(@"fromPath 文件夹不存在");
        return NO;
    }
    if ([DefaultFileManager fileExistsAtPath:toPatch]) {
        FLOG(@"toPatch 文件夹已经存在");
        return NO;
    }
   BOOL flog =  [DefaultFileManager moveItemAtPath:fromPath toPath:toPatch error:&error];
    if (flog) {
         FLOG(@"移动成功");
        return YES;
    }
    if (error) {
        FLOG(@"error = %@",error);
    }
     return NO;
}
+ (BOOL)renameFileFileFromFullPath:(NSString*)fromPath withName:(NSString*)newName
{
    NSError * error = nil;
    if (![DefaultFileManager fileExistsAtPath:fromPath]) {
        FLOG(@"fromPath 文件夹不存在");
        return NO;
    }
//    stringByAppendingPathComponent
     NSString * fullPath = [fromPath.stringByDeletingLastPathComponent stringByAppendingPathComponent:newName];
    if (fromPath.pathExtension.length) {
        fullPath = [NSString stringWithFormat:@"%@.%@",fullPath,fromPath.pathExtension];
    }
    if ([DefaultFileManager fileExistsAtPath:fullPath]) {
        FLOG(@"toPatch 文件夹已经存在");
        return NO;
    }
    BOOL flog =  [DefaultFileManager moveItemAtPath:fromPath toPath:fullPath error:&error];
    if (flog) {
        FLOG(@"移动成功");
        return YES;
    }
    if (error) {
        FLOG(@"error = %@",error);
    }
    return NO;
}
+ (NSMutableArray *)filterPhotosFromFullPath:(NSString*)fromPath
{
    NSMutableArray *paramArrayOfPhotos = [[NSMutableArray alloc] init];
    NSArray *directoryContent = [DefaultFileManager contentsOfDirectoryAtPath:fromPath error:nil];
    for(NSString *fileName in directoryContent)
    {
        NSString *fileFullPath = [fromPath stringByAppendingPathComponent:fileName];
        //获取普通文件或文件夹详细信息
        NSDictionary *fileAttributes = [DefaultFileManager attributesOfItemAtPath:fileFullPath error:nil];
        if (!fileAttributes) {
            continue;
        }
        if([fileName isEqualToString:@"Inbox"])
        {
            continue;
        }//模拟器中测试过滤条件
        if([fileName isEqualToString:@".DS_Store"])
        {
            continue;
        }
        //目录元素
        DirectoryElement *element = [[DirectoryElement alloc] init];
        //绝对路径
        element.path = fileFullPath;
        //文件名称
        element.name = fileName;
        NSLog(@"%@", fileName);
        //文件名称(大写)
        element.nameForSort = [fileName uppercaseString];
        //文件创建日期
        element.date = [fileAttributes objectForKey:NSFileCreationDate];
        //文件修改日期
        element.modificationDate = [fileAttributes objectForKey:NSFileModificationDate];
        
        NSString *fileType = [fileAttributes objectForKey:NSFileType];
        if([fileType isEqualToString:NSFileTypeDirectory])
        {
            [paramArrayOfPhotos addObjectsFromArray:[self filterPhotosFromFullPath:fileFullPath]];
        }
        else
        {
            //类型:普通文件
            element.elementType = ElementType_NomalFiles;
            //文件大小
            element.fileSize = [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
            //扩展名(大写)
            element.fileExtension = [[fileName pathExtension] uppercaseString];
            if ([self isPhotoFile:fileName]) {
                UIImage * iamge = [UIImage imageNamed:fileFullPath];
                element.imageLogo =(iamge.size.height<90&&iamge.size.width<90)?iamge :[iamge imageClipedSetFitSize:CGSizeMake(90, 90)];
                element.elementType = ElementType_photo;
                 [paramArrayOfPhotos addObject:element];
            }
        }
       
    }

    return paramArrayOfPhotos;
}
+(BOOL)createFileIfNotExisting:(NSString *)folderFullPath
{
    //Only create if the folder does not exists yet.
    if (![DefaultFileManager fileExistsAtPath:folderFullPath])
    {
        [DefaultFileManager createFileAtPath:folderFullPath contents:nil attributes:nil];
        return YES;
    }else{
        return YES;
    }

}

@end
