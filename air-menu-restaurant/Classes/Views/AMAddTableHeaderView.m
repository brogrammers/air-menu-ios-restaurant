//
//  AMHeaderAddTableHeaderView.m
//  Air Menu
//
//  Created by Robert Lis on 11/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMAddTableHeaderView.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface ExtendedTouchButton : FRDLivelyButton
@end

@implementation ExtendedTouchButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect relativeFrame = self.bounds;
    UIEdgeInsets hitTestEdgeInsets = UIEdgeInsetsMake(-44, -44, -44, -44);
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

@end

@interface AMAddTableHeaderView()
@property (nonatomic, readwrite, weak) UILabel *label;
@property (nonatomic, readwrite, weak) FRDLivelyButton *button;
@end

@implementation AMAddTableHeaderView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self setupLabel];
    [self setupButton];
}

-(void)setupLabel
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.label = label;
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    [self.label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.label.font = [UIFont fontWithName:GOTHAM_BOOK size:25];
    self.label.textColor = [UIColor whiteColor];
}


-(void)setupButton
{
    FRDLivelyButton *button = [[ExtendedTouchButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.button = button;
    self.button.options = @{kFRDLivelyButtonColor : [UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0],
                            kFRDLivelyButtonLineWidth : @1.0};
    [self.button addTarget:self action:@selector(didTapAdd:) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.button];
    [self.button autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.label withOffset:0];
    [self.button autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20];
    [self.button autoSetDimension:ALDimensionHeight toSize:25];
    [self.button autoSetDimension:ALDimensionWidth toSize:25];
    
    
    self.button.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.button.layer.shadowOpacity = 1.0;
    self.button.layer.shadowRadius = 1.0;
    self.button.layer.shadowOffset = CGSizeMake(0.0f,1.0f);
}

-(void)didTapAdd:(FRDLivelyButton *)button
{
    [self.delegate sectionAtIndex:self.sectionIndex didPressButton:button];
}

@end
