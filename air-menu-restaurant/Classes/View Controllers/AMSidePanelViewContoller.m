//
//  AMSidePanelViewContoller.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 04/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import <TDMScreenEdgePanGestureRecognizer/TDMScreenEdgePanGestureRecognizer.h>
#import "AMSidePanelViewContoller.h"
#import "AMThresholdedDirectionPanGestureRecogniser.h"

@interface AMSidePanelViewContoller()
@property (nonatomic, readwrite, weak) UIView *contentView;
@property (nonatomic, readwrite) CATransform3D contentViewRotation;
@property (nonatomic, readwrite, weak) UIView *sidePanel;
@property (nonatomic, readwrite, weak) NSLayoutConstraint *sidePanelTrailingEdge;
@property (nonatomic, readwrite) BOOL sidePanelOpened;
@property (nonatomic, readwrite) TDMScreenEdgePanGestureRecognizer *recogniser;
@end

@implementation AMSidePanelViewContoller

-(id)init
{
    self = [super init];
    if(self)
    {
        [self createContentView];
        [self createSideMenu];
        self.view.backgroundColor = [UIColor clearColor];
//        AMThresholdedDirectionPanGestureRecogniser *recogniser = [[AMThresholdedDirectionPanGestureRecogniser alloc] initWithTarget:self action:@selector(didPan:)];
//        recogniser.direction = AMDirectionPanGestureRecognizerHorizontal;
//        recogniser.minimumNumberOfTouches = 2;
//        recogniser.beginTreshold = 10;
//        self.sidePanelOpened = NO;
        TDMScreenEdgePanGestureRecognizer *recogniser = [[TDMScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        [recogniser requireToFailSubScrollViewsPanGestures];
        recogniser.edges = UIRectEdgeLeft;
        self.recogniser = recogniser;
        self.view.clipsToBounds = NO;
        [self.view addGestureRecognizer:recogniser];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.recogniser requireToFailSubScrollViewsPanGestures];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.contentView.layer.position = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height / 2);
}

-(void)createContentView
{
    UIView *contentView = [UIView newAutoLayoutView];
    self.contentView = contentView;
    self.contentView.clipsToBounds = NO;
    self.contentViewRotation = CATransform3DIdentity;
    self.contentView.layer.anchorPoint = CGPointMake(1.0, 0.5);
    [self.view addSubview:self.contentView];
    [self.contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}


-(void)createSideMenu
{
    UIView *sidePanel = [UIView newAutoLayoutView];
    self.sidePanel = sidePanel;
    [self.view addSubview:self.sidePanel];
    [self.sidePanel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:0];
    [self.sidePanel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0];
    self.sidePanelTrailingEdge = [self.sidePanel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.view withOffset:0];
    [self.sidePanel autoSetDimension:ALDimensionWidth toSize:320.0f];
}

-(void)didPan:(AMDirectionPanGestureRecognizer *)recogniser
{
    static CGPoint initialPoint;
    
    if (recogniser.state == UIGestureRecognizerStateBegan)
    {
        initialPoint = [recogniser locationInView:self.view];
//        if(self.sidePanelOpened)
//        {
//            CGFloat xDeltaNormalised = initialPoint.x / 320;
//            CATransform3D transform = CATransform3DIdentity;
//            transform.m34 = 1.0 / -1500;
//            
//            self.sidePanelTrailingEdge.constant = initialPoint.x;
//            [UIView animateWithDuration:0.25
//                                  delay:0.9
//                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
//                             animations:^{
//                                 self.contentView.layer.transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-40 * xDeltaNormalised) , 0.0, 1.0, 0.0);
//                                 [self.view layoutIfNeeded];
//                             }
//                             completion:nil];
//        }
    }
    else if(recogniser.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentPoint = [recogniser locationInView:self.view];
        CGFloat xDelta = currentPoint.x - initialPoint.x;

        if(currentPoint.x >= initialPoint.x && xDelta <= 320)
        {
            CGFloat xDeltaNormalised = xDelta / 320.0f;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / -1500;
            self.contentView.layer.transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-40 * xDeltaNormalised) , 0.0, 1.0, 0.0);
            self.contentView.alpha = 1.0 - xDeltaNormalised;
            self.sidePanelTrailingEdge.constant = xDelta;
        }
        else if(xDelta <= 320)
        {
            self.contentView.layer.transform = CATransform3DIdentity;
            self.sidePanelTrailingEdge.constant = 320;
            self.contentView.alpha = 1.0;
        }
        
        [self.view layoutIfNeeded];

    }
    else if(recogniser.state == UIGestureRecognizerStateEnded)
    {
        CGPoint currentPoint = [recogniser locationInView:self.view];
        CGFloat xDelta = currentPoint.x - initialPoint.x;

        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 1.0 / -1500;
        
        if(xDelta >= 320 / 2)
        {
            self.sidePanelTrailingEdge.constant = 320;
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.contentView.layer.transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-40) , 0.0, 1.0, 0.0);
                                 self.contentView.alpha = 0.05;
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 self.sidePanelOpened = YES;
                             }];
        }
        else
        {
            self.sidePanelTrailingEdge.constant = 0;
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.contentView.layer.transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(0) , 0.0, 1.0, 0.0);
                                 self.contentView.alpha = 1.0;
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                self.sidePanelOpened = NO;
                             }];
        }
        
    }
}

-(void)setSidePanelViewController:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [self.sidePanel addSubview:viewController.view];
    [viewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [viewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [viewController didMoveToParentViewController:self];
}

-(void)setContentViewController:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [self.contentView addSubview:viewController.view];
    [viewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [viewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [viewController didMoveToParentViewController:self];
}
@end
