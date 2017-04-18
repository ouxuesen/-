//
//  POPPassWordViewController.m
//  欧学森看电影
//
//  Created by oxs on 15/8/24.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "POPPassWordViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface POPPassWordViewController ()
{
    BOOL firtsLoad;
    NSUserDefaults * userdefault;
}
@end

@implementation POPPassWordViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (textField) {
        textField.text = @"";
        [self chageTipsView:0];
    }
       firtsLoad = YES;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (firtsLoad) {
       [textField becomeFirstResponder];
        firtsLoad = NO;
    }
}
#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField_1 shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
   NSString* allstring = [textField_1.text stringByReplacingCharactersInRange:range withString:string];
    if (allstring.length > 4) {
         //比较密码
        return NO;
    }
   
    [self chageTipsView:allstring.length];
    
    return YES;
}
- (void)textFieldDidChange:(NSNotificationCenter *)not
{
    if (textField.text.length ==4) {
      [self proofreadingPasssWord];
    }
 
}

- (void)chageTipsView:(NSInteger)tipsCount
{
    if (tipsCount >[tipsView count]) {
       
        return;
    }
    for (int i=0; i<[tipsView count]; i++) {
        UIView * tip = [tipsView objectAtIndex:i];
        if (i<tipsCount) {
            tip.hidden = NO;
        }else{
            tip.hidden = YES;
        }
        
    }
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIView* tip in tipsView) {
        tip.hidden = YES;
    }
    self.title = @"解锁";
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
       UIBarButtonItem* rightBBi = [[UIBarButtonItem alloc]initWithTitle:@"指纹输入" style:UIBarButtonItemStylePlain target:self action: @selector(fingerprintInput)];
        self.navigationItem.rightBarButtonItem = rightBBi;
    }
   
    // Do any additional setup after loading the view from its nib.
}
- (void)fingerprintInput
{
    [textField resignFirstResponder];
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"Authentication is needed to access your notes.";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //用户选择输入密码，切换主线程处理
                   [self.navigationController.view removeFromSuperview];
                }];
                
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            [textField becomeFirstResponder];
                        }];
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            [textField becomeFirstResponder];
                        }];
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            [textField becomeFirstResponder];
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                            [textField becomeFirstResponder];
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //用户选择输入密码，切换主线程处理
            [textField becomeFirstResponder];
        }];
        NSLog(@"%@",error.localizedDescription);
//        [self showPasswordAlert];
    }
}
- (void)proofreadingPasssWord
{
      userdefault = [NSUserDefaults standardUserDefaults];
    if ([userdefault objectForKey:NSUserdefault_passWord]) {
        NSString* passwored = [userdefault objectForKey:NSUserdefault_passWord];
        if ([passwored isEqualToString:textField.text]) {
            [self.navigationController.view removeFromSuperview];
        }else{
             [MCAlertView showWithMessage:@"密码错误"];
            textField.text = @"";
            [self chageTipsView:0];
        }
    }else{
        [MCAlertView showWithMessage:@"还未设置密码"];
    }
}


@end
