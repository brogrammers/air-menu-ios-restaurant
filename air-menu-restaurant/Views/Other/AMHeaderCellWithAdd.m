//
//  AMHeaderCellWithAdd.m
//  Air Menu
//
//  Created by Robert Lis on 14/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMHeaderCellWithAdd.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "UILabel+AttributesCopy.h"
#import "AMButton.h"

@interface AMHeaderCellWithAdd()
@property (nonatomic, readwrite, weak) UILabel *titleLabel;
@property (nonatomic, readwrite, weak) AMButton *addButton;
@end

@implementation AMHeaderCellWithAdd

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self setupTitleLabel];
    [self setupButton];
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch:)]];
}

-(void)setupTitleLabel
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.titleLabel = label;
    [self.contentView addSubview:label];
    self.titleLabel.attributes = @{NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:25],
                                   NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSKernAttributeName : @1.0};
    [self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView].priority = 1;
    //[self.titleLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0].priority = 750;
    [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    label.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView].priority = 500;
}

-(void)setupButton
{
    AMButton *button = [AMButton button];
    self.addButton = button;
    [self.contentView addSubview:self.addButton];
    [self.addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.addButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20];
    [self.addButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.titleLabel];
    [self.addButton setTitle:@"add" forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    [self.titleLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.addButton withOffset:-20.0f].priority = 750;
    button.fontSize = 15.0;
    [button addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
    [button setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

-(void)setSelected:(BOOL)selected
{
    if(selected)
    {
        self.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    else
    {
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    }
}

-(void)didTouch:(UITapGestureRecognizer *)recogniser
{
    if (recogniser.state == UIGestureRecognizerStateEnded && self.touchBlock) {
        self.touchBlock();
    }
}

-(void)didTap:(UIButton *)buttom
{
    if (self.tapBlock) {
        self.tapBlock();
    }
}
@end
