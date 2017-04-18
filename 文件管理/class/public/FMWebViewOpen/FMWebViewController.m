//
//  FMWebViewController.m
//  文件管理
//
//  Created by oxs on 15/8/26.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMWebViewController.h"

@interface FMWebViewController ()
{
    NSString* _topTitle;
    NSString * _url;
    NSString * _mimetype;
}
@end

@implementation FMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _webView.scalesPageToFit = YES;
    self.title = _topTitle;
    if (_type == WebViewLoad_MIMET) {
        NSData *data = [NSData dataWithContentsOfFile:_url];
        self.webView.scalesPageToFit = YES;
        [self.webView loadData:data MIMEType:_mimetype textEncodingName:@"UTF-8" baseURL:nil];
//        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    }else if (_type == PSSETWORD_WEB){
        NSURL *urlRequest = [NSURL URLWithString:_url];
        NSURLRequest * request =[[NSURLRequest alloc]initWithURL:urlRequest];
        [self.webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)postMIMEWithUrl:(NSString*)url title:(NSString*)title mimet:(NSString*)mimet
{
    _topTitle = title;
    _type =  WebViewLoad_MIMET;
    _url = url;
    _mimetype = mimet;
}

- (void)postWebViewWithurl:(NSString*)url title:(NSString*)title
{
    _topTitle = title;
    _type =  PSSETWORD_WEB;
    _url = url;
}
@end
