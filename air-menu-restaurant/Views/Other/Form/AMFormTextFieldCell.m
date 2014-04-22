//
//  AMFormTextFieldCell.m
//  Air Menu
//
//  Created by Robert Lis on 21/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMFormTextFieldCell.h"
#import "AMFloatingTextField.h"
#import "AMLineSpacer.h"

@protocol AMHackLabelDelegate <NSObject>
-(void)didSetText:(NSString *)text;
@end

@interface AMHackLabel : UILabel
@property (nonatomic, readwrite, weak) id <AMHackLabelDelegate> delegate;
@end

@implementation AMHackLabel
-(void)setText:(NSString *)text
{
    [self.delegate didSetText:text];
}
@end

@interface AMFormTextFieldCell() <AMHackLabelDelegate>
@end

@implementation AMFormTextFieldCell
@synthesize textField = _textField;
@synthesize textLabel = _textLabel;

-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    AMHackLabel *label = [AMHackLabel newAutoLayoutView];
    label.delegate = self;
    _textLabel = label;
    return _textLabel;
}

-(UITextField *)textField
{
    if (_textField) return _textField;
    AMFloatingTextField *textField = [[AMFloatingTextField alloc] initForAutoLayout];
    textField.textColor = [UIColor whiteColor];
    textField.font = [UIFont fontWithName:GOTHAM_LIGHT size:18];
    textField.floatingLabelYPadding = @10;
    textField.floatingLabel.font = [UIFont fontWithName:GOTHAM_BOOK size:12];
    textField.floatingLabelTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    textField.floatingLabelActiveTextColor = [UIColor whiteColor];
    _textField = textField;
    
    AMLineSpacer *spacer = [AMLineSpacer newAutoLayoutView];
    [self.contentView addSubview:spacer];
    [spacer autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:0.0];
    [spacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:30.0];
    [spacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:0];
    [spacer autoSetDimension:ALDimensionHeight toSize:0.5];
    spacer.alpha = 0.1;
    spacer.shouldFade = NO;
    
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];

    return _textField;
}

-(void)didSetText:(NSString *)text
{
    AMFloatingTextField *field =  (AMFloatingTextField *)self.textField;
    field.floatingLabel.text = text;
    NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:placeholderAttributes];
}

+(CGFloat)formDescriptorCellHeightForRowDescription:(XLFormRowDescriptor *)rowDescriptor
{
    return 60;
}

-(void)updateConstraints
{
    [self.textField autoRemoveConstraintsAffectingView];
    [self.textLabel autoRemoveConstraintsAffectingView];
    [super updateConstraints];
    [self.textField autoRemoveConstraintsAffectingView];
    [self.textLabel autoRemoveConstraintsAffectingView];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.font = [UIFont fontWithName:GOTHAM_LIGHT size:18];
    [self.textField autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20];
    [self.textField autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:0];
    [self.textField autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-10];
}

@end

