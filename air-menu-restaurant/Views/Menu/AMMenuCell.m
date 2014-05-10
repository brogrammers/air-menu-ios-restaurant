//
//  AMMenuCell.m
//  Air Menu
//
//  Created by Robert Lis on 06/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuCell.h"
#import "UILabel+AttributesCopy.h"
#import "AMLineSpacer.h"
#import <pop/POP.h>

@interface AMMenuCell()
@property (nonatomic, readwrite, weak) UILabel *nameLabel;
@property (nonatomic, readwrite, weak) AMButton *addButton;
@property (nonatomic, readwrite, weak) AMLineSpacer *bottomSpacer;
@property (nonatomic, readwrite, weak) AMLineSpacer *topSpacer;
@property (nonatomic, readwrite, weak) UIView *container;
@end

@implementation AMMenuCell

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
    [self setupNameLabel];
    [self setupAddButton];
    [self setupSpacer];
    [self setupContainer];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = YES;
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)]];
}

-(void)setupNameLabel
{
    UILabel *nameLabel = [UILabel newAutoLayoutView];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0];
    [self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0];
    self.nameLabel.attributes = @{NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:15.0f],
                                  NSForegroundColorAttributeName : [UIColor whiteColor]};
}

-(void)setupAddButton
{
    AMButton *addButton = [AMButton button];
    self.addButton = addButton;
    self.addButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.addButton];
    [self.addButton setTitle:@"add section" forState:UIControlStateNormal];
    [self.addButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
    [self.addButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    self.addButton.fontSize = 12.0f;
    [self.addButton addTarget:self action:@selector(didPress:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupSpacer
{
    AMLineSpacer *bottomSpacer = [AMLineSpacer newAutoLayoutView];
    self.bottomSpacer = bottomSpacer;
    [self.contentView addSubview:self.bottomSpacer];
    [self.bottomSpacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.bottomSpacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [self.bottomSpacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:20.0f];
    [self.bottomSpacer autoSetDimension:ALDimensionHeight toSize:1.0f];
    self.bottomSpacer.shouldFade = NO;
    self.bottomSpacer.alpha = 0.5;
    
    AMLineSpacer *topSpacer = [AMLineSpacer newAutoLayoutView];
    self.topSpacer = topSpacer;
    [self.contentView addSubview:self.topSpacer];
    [self.topSpacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.topSpacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [self.topSpacer autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView];
    [self.topSpacer autoSetDimension:ALDimensionHeight toSize:1.0f];
    self.topSpacer.shouldFade = NO;
    self.topSpacer.alpha = 0.5;
}

-(void)setupContainer
{
    UIView *container = [UIView newAutoLayoutView];
    self.container = container;
    self.container.clipsToBounds = YES;
    [self.contentView addSubview:self.container];
    [self.container autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bottomSpacer];
    [self.container autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView];
    [self.container autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView];
    [self.container autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView];
}

-(void)setName:(NSString *)name
{
    [self.nameLabel setTextWithExistingAttributes:name];
}

-(void)setActive:(BOOL)active
{
    NSMutableDictionary *copy = [self.nameLabel.attributes mutableCopy];
    UIColor *color =  active ? [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1.0] : [UIColor whiteColor];
    CGFloat alpha = active ? 1.0 : 0.5;
    [copy addEntriesFromDictionary:@{NSForegroundColorAttributeName : color}];
    self.topSpacer.tintColor = color;
    [self.topSpacer setNeedsDisplay];
    self.bottomSpacer.tintColor = color;
    [self.bottomSpacer setNeedsDisplay];
    [self.addButton setTintColor:color];
    self.bottomSpacer.alpha = alpha;
    self.topSpacer.alpha = alpha;
    self.nameLabel.attributes = copy;
}

-(void)setViewToContain:(UIView *)view
{
    self.autoresizesSubviews = YES;
    
    [self.container.subviews each:^(id object) {
        [UIView animateWithDuration:0.5 animations:^{
            [object setAlpha:0.0];
        }];
        [object removeFromSuperview];
    }];
    
    if(view)
    {
        [self.container addSubview:view];
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        view.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha = 1.0;
        }];
    }

    [self.container layoutIfNeeded];
    [self.container setNeedsLayout];
    [view setNeedsLayout];
}

-(void)didTap:(UITapGestureRecognizer *)recogniser
{
    if([recogniser locationInView:self.contentView].y < self.bottomSpacer.frame.origin.y && self.tapBlock)
    {
        self.tapBlock(self.indexPath);
    }
}

-(void)didPress:(AMButton *)button
{
    if (self.addBlock) {
        self.addBlock(self.indexPath);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:self.contentView];
    if([scrollView.panGestureRecognizer locationInView:self.contentView].y - translation.y < self.bottomSpacer.frame.origin.y)
    {
        [super scrollViewDidScroll:scrollView];
    }
    else
    {
        scrollView.panGestureRecognizer.enabled = NO;
        scrollView.panGestureRecognizer.enabled = YES;
    }
}

@end
