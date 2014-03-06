//
//  AMActionCell.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 06/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMActionCell.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>

@interface AMActionCellScrollView : UIScrollView
@property (nonatomic, readwrite, weak) UIView *viewToMove;
@property (nonatomic, readwrite) CGRect viewFrame;
@end

@implementation AMActionCellScrollView
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.viewToMove.frame = self.viewFrame;
}
@end

@interface AMActionCell() <UIScrollViewDelegate>
@property (nonatomic, weak, readwrite) AMActionCellScrollView *scrollView;
@property (nonatomic, weak, readwrite) UIView *innerContentView;
@property (nonatomic, weak, readwrite) UIView *actionsContainerView;
@property (nonatomic, readwrite) CGFloat revealWidth;
@property (nonatomic, readwrite) BOOL isOpen;
@end

@implementation AMActionCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(UIView *)contentView
{
    return self.innerContentView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.superview.superview.frame = self.bounds;
}

-(void)setup
{
    self.revealWidth = self.bounds.size.width * (2.0/3.0);
    self.backgroundColor = [UIColor clearColor];
    [super contentView].backgroundColor = [UIColor clearColor];
    [self setupScrollView];
    [self setupInnerContentView];
    [self setupActionsContainerView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeCell:)
                                                 name:@"ActionCellDidOpenNotification"
                                               object:nil];
}

-(void)setupScrollView
{
    AMActionCellScrollView *scrollView = [AMActionCellScrollView newAutoLayoutView];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [[super contentView] addSubview:self.scrollView];
    [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

-(void)setupInnerContentView
{
    UIView *innerContentView = [UIView newAutoLayoutView];
    self.innerContentView = innerContentView;
    [self.scrollView addSubview:self.innerContentView];
    [self.innerContentView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.scrollView];
    [self.innerContentView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.scrollView];
    [self.innerContentView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.scrollView];
    [@[self.innerContentView,[super contentView]] autoMatchViewsDimension:ALDimensionHeight];
    [@[self.innerContentView,[super contentView]] autoMatchViewsDimension:ALDimensionWidth];
}

-(void)setupActionsContainerView
{
    UIView *actionsContainerView = [UIView newAutoLayoutView];
    self.actionsContainerView = actionsContainerView;
    self.actionsContainerView.layer.mask = [CAShapeLayer layer];
    [self.scrollView insertSubview:self.actionsContainerView belowSubview:self.innerContentView];
    [self.actionsContainerView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.scrollView];
    [self.actionsContainerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.scrollView];
    [self.actionsContainerView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.scrollView];
    [self.actionsContainerView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.innerContentView];
    [@[self.actionsContainerView, [super contentView]] autoMatchViewsDimension:ALDimensionHeight];
    [self.actionsContainerView autoSetDimension:ALDimensionWidth toSize:self.revealWidth];
}

-(void)positionActionsContainerView
{
    CGRect actionsContainerViewFrame = self.actionsContainerView.frame;
    actionsContainerViewFrame.origin.x = self.innerContentView.frame.size.width - self.revealWidth + self.scrollView.contentOffset.x;
    self.scrollView.viewFrame = actionsContainerViewFrame;
    self.scrollView.viewToMove = self.actionsContainerView;
    CAShapeLayer *layer = (CAShapeLayer *)self.actionsContainerView.layer.mask;
    CGRect intersection = CGRectIntersection(self.actionsContainerView.frame, self.innerContentView.frame);
    CGRect intersectionTranslated = [self.actionsContainerView convertRect:intersection fromView:self.scrollView];
    CGRect maskRect = CGRectMake(intersectionTranslated.origin.x + intersectionTranslated.size.width,
                                 intersectionTranslated.origin.y,
                                 self.actionsContainerView.bounds.size.width - intersectionTranslated.size.width,
                                 self.actionsContainerView.bounds.size.height);
    if(maskRect.origin.x != INFINITY && maskRect.origin.y != INFINITY)
    {
        layer.path = [UIBezierPath bezierPathWithRect:maskRect].CGPath;
    }
}

-(void)closeCell:(NSNotification *)notification
{
    if(notification.object != self)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scrollView setContentOffset:CGPointZero animated:YES];
        });
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self positionActionsContainerView];
    
    if(scrollView.contentOffset.x >= self.revealWidth)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ActionCellDidOpenNotification" object:self];
        self.isOpen = YES;
    }
    else
    {
        self.isOpen = NO;
    }
    
    [self.scrollView setNeedsLayout];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                    withVelocity:(CGPoint)velocity
             targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.x > 0)
    {
        targetContentOffset->x = self.revealWidth;
    }
    else
    {
        targetContentOffset->x = 0;
    }
}

-(void)setActions:(NSArray *)actions withFonts:(NSArray *)fonts andColors:(NSArray *)colors
{
    NSAssert((actions.count == fonts.count) && (fonts.count == colors.count), @"actions fonts colors must have the same amount of elements");
    [self.actionsContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat buttonSize = self.revealWidth / actions.count;
    for(int index = 0; index < actions.count; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(actionReceived:) forControlEvents:UIControlEventTouchUpInside];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.frame = CGRectMake(index * buttonSize, 0, buttonSize, self.actionsContainerView.bounds.size.height);
        button.titleLabel.font = fonts[index];
        button.backgroundColor = colors[index];
        [button setTitle:actions[index] forState:UIControlStateNormal];
        [self.actionsContainerView addSubview:button];
    }
}

-(void)actionReceived:(UIButton *)button
{
    [self.delegate didSelectAction:button.titleLabel.text onCell:self atIndexPath:self.indexPath];
}

@end
