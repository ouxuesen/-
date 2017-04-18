//
//  FMResetTableViewCell.m
//  文件管理
//
//  Created by oxs on 15/9/1.
//  Copyright (c) 2015年 ouxuesen. All rights reserved.
//

#import "FMResetTableViewCell.h"

@implementation FMResetTableViewCell

-(void)awakeFromNib
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    _limitCount= 4;
    passWordTextField.keyboardType = UIKeyboardTypeNumberPad;
    passWordTextField.delegate = self;
}
- (void)updateDisplay
{
    if (!_resetModel.type) {
        if (_indexPath.row == 0) {
            passWordTextField.placeholder = @"输入原密码";
        }else{
            passWordTextField.placeholder = @"输入密码";
        }
        
    }
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _resetModel.currentTextField = textField;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    string = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length > _limitCount) {
        return NO;
    }
    if (!_resetModel.type) {
        if (_indexPath.row == 0) {
            _resetModel.passWord =string;
        }else{
             _resetModel.resetPassWord =string;
        }
        
    }else{
        _resetModel.passWord =string;
    }
    return YES;
}
- (void)textFieldDidChange:(NSNotificationCenter *)not
{
    NSString *text = passWordTextField.text;
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (passWordTextField.markedTextRange == nil && text.length > _limitCount) {
        passWordTextField.text = [text substringToIndex:_limitCount];
    }
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
