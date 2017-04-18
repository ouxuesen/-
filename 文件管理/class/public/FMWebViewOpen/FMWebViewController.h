//
//  FMWebViewController.h
//  文件管理
//
//  Created by oxs on 15/8/26.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMBaseViewController.h"

@interface FMWebViewController : FMBaseViewController
typedef enum {
    WebViewLoad_MIMET,
    PSSETWORD_WEB,
} WebViewLoad_Type;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (assign, nonatomic) WebViewLoad_Type type;

//mimet
- (void)postMIMEWithUrl:(NSString*)url title:(NSString*)title mimet:(NSString*)mimet;

//打开网页
- (void)postWebViewWithurl:(NSString*)url title:(NSString*)title;
@end
