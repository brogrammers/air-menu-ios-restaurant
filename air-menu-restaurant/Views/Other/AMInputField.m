//
//  AMInputField.m
//  Air Menu
//
//  Created by Robert Lis on 15/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMInputField.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMFloatingTextField.h"
#import "AMLineSpacer.h"

@implementation AMInputField

-(void)setFields:(NSDictionary *)fields
{
    _fields = fields;

    [fields.allValues each:^(NSString *input) {
        AMFloatingTextField *textField = [[AMFloatingTextField alloc] initForAutoLayout];
        NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        textField.textColor = [UIColor whiteColor];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:input attributes:placeholderAttributes];
        textField.font = [UIFont fontWithName:GOTHAM_LIGHT size:18];
        textField.floatingLabelYPadding = @10;
        textField.floatingLabel.font = [UIFont fontWithName:GOTHAM_BOOK size:12];
        textField.floatingLabel.text = input;
        textField.floatingLabelTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        textField.floatingLabelActiveTextColor = [UIColor whiteColor];
        [self addSubview:textField];
        [textField autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:10];
        [textField autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:10];
    }];
    
    NSArray *constraints = [self.subviews autoDistributeViewsAlongAxis:ALAxisVertical withFixedSpacing:20.0 alignment:NSLayoutFormatAlignAllLeft];
    [[constraints firstObject] setConstant:50];
    [[constraints lastObject] setConstant:0];

    [self.subviews each:^(UIView *object) {
        AMLineSpacer *spacer = [AMLineSpacer newAutoLayoutView];
        [self addSubview:spacer];
        [spacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20];
        [spacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:20];
        [spacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:object withOffset:5.0];
        [spacer autoSetDimension:ALDimensionHeight toSize:0.5];
        spacer.shouldFade = NO;
        spacer.alpha = 0.1;
    }];

    UILabel *label = [UILabel newAutoLayoutView];
    label.text = self.title;
    label.font = [UIFont fontWithName:GOTHAM_LIGHT size:24];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [label autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self];
    
    AMLineSpacer *spacer = [AMLineSpacer newAutoLayoutView];
    [self addSubview:spacer];
    [spacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:0];
    [spacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:20];
    [spacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:10.0];
    [spacer autoSetDimension:ALDimensionHeight toSize:1.0];
    spacer.shouldFade = NO;
}

@end
