//
//  AMDecimalFieldCell.m
//  Air Menu
//
//  Created by Robert Lis on 10/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMDecimalFieldCell.h"

@implementation AMDecimalFieldCell
-(UITextField *)textField
{
    UITextField *textField = [super textField];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    return textField;
}
@end
