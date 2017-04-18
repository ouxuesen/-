//
//  FMWIFITransmissionVCViewController.m
//  文件管理
//
//  Created by oxs on 15/9/2.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMWIFITransmissionVCViewController.h"
#import "HTTPServer.h"
#import "AYHTTPConnection.h"
#define GBUnit 1073741824
#define MBUnit 1048576
#define KBUnit 1024

@interface FMWIFITransmissionVCViewController ()

@end

@implementation FMWIFITransmissionVCViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self  =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithStart:) name:UPLOADSTART object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploading:) name:UPLOADING object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithEnd:) name:UPLOADEND object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithDisconnect:) name:UPLOADISCONNECTED object:nil];
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"传输";
    [self initViews];
    
    [self creatServer];
}
- (void)creatServer
{
    _httpserver = [[HTTPServer alloc] init];
    [_httpserver setType:@"_http._tcp."];
    [_httpserver setPort:16918];
    NSString *webPath = [[NSBundle mainBundle] resourcePath] ;
    [_httpserver setDocumentRoot:webPath];
    [_httpserver setConnectionClass:[AYHTTPConnection class]];
    [self startServer];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_httpserver) {
        [self creatServer];
    }
    if (_httpserver) {
        [self startServer];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_httpserver stop];
    currentDataLength = 0;
    [_progressView setHidden:YES];
    [_progressView setProgress:0.0];
    [_lbFileSize setText:@""];
    [_lbCurrentFileSize setText:@""];
}
- (void) uploadWithStart:(NSNotification *) notification
{
    UInt64 fileSize = [(NSNumber *)[notification.userInfo objectForKey:@"totalfilesize"] longLongValue];
    __block NSString *showFileSize = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (fileSize>GBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"/%.1fG", (CGFloat)fileSize / (CGFloat)GBUnit];
        if (fileSize>MBUnit && fileSize<=GBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"/%.1fMB", (CGFloat)fileSize / (CGFloat)MBUnit];
        else if (fileSize>KBUnit && fileSize<=MBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"/%lliKB", fileSize / KBUnit];
        else if (fileSize<=KBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"/%lliB", fileSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lbFileSize setText:showFileSize];
            [_progressView setHidden:NO];
        });
    });
    showFileSize = nil;
}

- (void) uploadWithEnd:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        currentDataLength = 0;
        [_progressView setHidden:YES];
        [_progressView setProgress:0.0];
        [_lbFileSize setText:@""];
        [_lbCurrentFileSize setText:@""];
    });
}

- (void) uploadWithDisconnect:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        currentDataLength = 0;
        [_progressView setHidden:YES];
        [_progressView setProgress:0.0];
        [_lbFileSize setText:@""];
        [_lbCurrentFileSize setText:@""];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Upload data interrupt!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    });
}

- (void) uploading:(NSNotification *)notification
{
    float value = [(NSNumber *)[notification.userInfo objectForKey:@"progressvalue"] floatValue];
    currentDataLength += [(NSNumber *)[notification.userInfo objectForKey:@"cureentvaluelength"] intValue];
    __block NSString *showCurrentFileSize = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (currentDataLength>GBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%.1fG", (CGFloat)currentDataLength / (CGFloat)GBUnit];
        if (currentDataLength>MBUnit && currentDataLength<=GBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%.1fMB", (CGFloat)currentDataLength / (CGFloat)MBUnit];
        else if (currentDataLength>KBUnit && currentDataLength<=MBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%lliKB", currentDataLength / KBUnit];
        else if (currentDataLength<=KBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%lliB", currentDataLength];
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressView.progress += value;
            [_lbCurrentFileSize setText:showCurrentFileSize];
        });
    });
    showCurrentFileSize = nil;
}

- (void) startServer
{
    NSError *error;
    if ([_httpserver start:&error])
        [_lbHTTPServer setText:[NSString stringWithFormat:@"在同一局域网中浏览器中输入 可上传文件\nhttp://%@:%hu", [_httpserver hostName], [_httpserver listeningPort]]];
    else
        NSLog(@"Error Started HTTP Server:%@", error);
}

- (void) initViews
{
    CGFloat gap = 64;
    _lbHTTPServer = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 50.0+gap, 300.0, 40.0)];
    [_lbHTTPServer setBackgroundColor:[UIColor clearColor]];
    [_lbHTTPServer setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_lbHTTPServer setLineBreakMode:UILineBreakModeWordWrap];
    [_lbHTTPServer setNumberOfLines:2];
    [self.view addSubview:_lbHTTPServer];
    
    _lbFileSize = [[UILabel alloc] initWithFrame:CGRectMake(250.0, 95.0+gap, 60.0, 20.0)];
    [_lbFileSize setBackgroundColor:[UIColor clearColor]];
    [_lbFileSize setFont:[UIFont boldSystemFontOfSize:13.0]];
    [self.view addSubview:_lbFileSize];
    
    _lbCurrentFileSize = [[UILabel alloc] initWithFrame:CGRectMake(188.0, 95.0+gap, 60.0, 20.0)];
    [_lbCurrentFileSize setBackgroundColor:[UIColor clearColor]];
    [_lbCurrentFileSize setFont:[UIFont boldSystemFontOfSize:13.0]];
    [_lbCurrentFileSize setTextAlignment:UITextAlignmentRight];
    [self.view addSubview:_lbCurrentFileSize];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [_progressView setFrame:CGRectMake(10.0, 120.0+gap, 300.0, 20.0)];
    [_progressView setHidden:YES];
    [self.view addSubview:_progressView];
}

@end
