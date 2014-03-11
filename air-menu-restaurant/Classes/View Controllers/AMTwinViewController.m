//
//  AMTwinViewController.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 26/02/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMTwinViewController.h"
#import "UIViewController+AMTwinViewController.h"

@interface UIViewController (AMTwinViewControllerPrivateExtension)
@property (nonatomic, weak, readwrite) AMTwinViewController *twinViewController;
@end

@implementation UIViewController (AMTwinViewControllerPrivateExtension)
@dynamic twinViewController;
@end

@interface AMTwinViewController () <UIScrollViewDelegate>
@property (nonatomic, weak, readwrite) UIScrollView *scrollViewInnerContainer;
@property (nonatomic, weak, readwrite) UIView *firstContainer;
@property (nonatomic, weak, readwrite) UIView *secondContainer;
@property (nonatomic, weak, readwrite) NSLayoutConstraint *firstContainerWidthConstraint;
@property (nonatomic, weak, readwrite) UIViewController *firstViewController;
@property (nonatomic, weak, readwrite) UIViewController *secondViewController;
@property BOOL expanded;
@end

@implementation AMTwinViewController

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = NO;
    [self setupScrollView];
    [self setupFirstContainer];
    [self setupSecondContainer];
}

-(void)setupScrollView
{
    UIScrollView *scrollViewInnerContainer = [UIScrollView newAutoLayoutView];
    self.scrollViewInnerContainer = scrollViewInnerContainer;
    [self.view addSubview:self.scrollViewInnerContainer];
    [self.scrollViewInnerContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.scrollViewInnerContainer.pagingEnabled = YES;
}

-(void)setupFirstContainer
{
    UIView *firstContainer = [UIView newAutoLayoutView];
    self.firstContainer = firstContainer;
    self.firstContainer.clipsToBounds = NO;
    [self.scrollViewInnerContainer addSubview:self.firstContainer];
    self.firstContainerWidthConstraint = [self.firstContainer autoSetDimension:ALDimensionWidth toSize:320];
    [self.firstContainer autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollViewInnerContainer withOffset:0];
    [self.firstContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.scrollViewInnerContainer];
    [self.firstContainer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.scrollViewInnerContainer];

    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self.firstContainer autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.scrollViewInnerContainer];
    }
    else
    {
        [self.firstContainer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.scrollViewInnerContainer];
    }
}

-(void)setupSecondContainer
{
    UIView *secondContainer = [UIView newAutoLayoutView];
    self.secondContainer = secondContainer;
    [self.scrollViewInnerContainer addSubview:self.secondContainer];
    [self.secondContainer autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.scrollViewInnerContainer];
    [self.secondContainer autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollViewInnerContainer withOffset:0];

    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self setupSecondContainerForiPad];
    }
    else
    {
        [self setupSecondContainerForiPhone];
    }
}

-(void)setupSecondContainerForiPad
{
    [self.secondContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.scrollViewInnerContainer];
    [self.secondContainer autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.firstContainer];
    [self.secondContainer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.scrollViewInnerContainer];
    [self.secondContainer autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withOffset:-320];
}

-(void)setupSecondContainerForiPhone
{
    [self.secondContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.firstContainer];
    [self.secondContainer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.scrollViewInnerContainer];
    [self.secondContainer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.scrollViewInnerContainer];
    [self.secondContainer autoSetDimension:ALDimensionWidth toSize:320];
}

-(void)setViewController:(UIViewController *)controller inPosition:(AMTwinViewControllerPosition)position
{
    [self addChildViewController:controller];

    if(position == AMTwinViewControllerPositionFirst)
    {
        self.firstViewController = controller;
        [self.firstContainer addSubview:controller.view];
    }
    else
    {
        self.secondViewController = controller;
        [self.secondContainer addSubview:controller.view];
    }
    
    [controller.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [controller.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    controller.twinViewController = self;
    [controller didMoveToParentViewController:self];
}


-(void)expandFirstViewControllerWithAnimationBlock:(Animation)animation completion:(Completion)completion
{
    self.expanded = YES;
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if(animation) animation();
                         self.firstContainerWidthConstraint.constant = 320 + (self.view.bounds.size.width - 320);
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if(completion) completion();
                     }
     ];
}

-(void)shrinkFirstViewControllerWithAnimationBlock:(Animation)animation completion:(Completion)completion
{
    self.expanded = NO;
    [UIView animateWithDuration:0.3
                          delay:0.15
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if(animation) animation();
                         self.firstContainerWidthConstraint.constant = 320;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if(completion) completion();
                     }
     ];
}

@end
