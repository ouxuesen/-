//
//  FMWIFITransmissionVCViewController.h
//  文件管理
//
//  Created by oxs on 15/9/2.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMBaseViewController.h"
#import "InAppWebHTTPServer.h"

@class HTTPServer;

@interface FMWIFITransmissionVCViewController : FMBaseViewController
{
    UInt64 currentDataLength;
}
@property (strong, nonatomic) HTTPServer *httpserver;
@property (strong, nonatomic) UIProgressView *progressView;     //upload progress
@property (strong, nonatomic) UILabel *lbHTTPServer;
@property (strong, nonatomic) UILabel *lbFileSize;                      //Total size of uploaded file
@property (strong, nonatomic) UILabel *lbCurrentFileSize;           //The size of the current upload

@end
