//
//  AMSecureTextFielCell.m
//  Air Menu
//
//  Created by Robert Lis on 01/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMSecureTextFieldCell.h"

@implementation AMSecureTextFieldCell
-(UITextField *)textField
{
    UITextField *textField = [super textField];
    textField.secureTextEntry = YES;
    return textField;
}
@end
