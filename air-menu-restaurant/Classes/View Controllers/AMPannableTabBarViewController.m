//
//  AMPannableTabBarViewController.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 02/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPannableTabBarViewController.h"
#import "AMDirectionPanGestureRecognizer.h"

NSString * kAMPannableTabBarViewControllerDidPan = @"kAMPannableTabBarViewControllerDidPan";
NSString * kAMPannableTabBarViewControllerDidMoveToIndex = @"kAMPannableTabBarViewControllerDidPan";

@interface AMPannableTabBarViewController () <UITabBarControllerDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@end

@implementation AMPannableTabBarViewController

-(void)viewDidLoad
{
    AMDirectionPanGestureRecognizer *recgonsier = [[AMDirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    recgonsier.direction = AMDirectionPanGestureRecognizerHorizontal;
    [self.view addGestureRecognizer:recgonsier];
    self.delegate = self;
}

-(void)didPan:(AMDirectionPanGestureRecognizer *)recogniser
{
    static CGPoint initialLocation;
    static CGPoint lastLocation;
    
    if(recogniser.state == UIGestureRecognizerStateBegan)
    {
        initialLocation = [recogniser locationInView:self.view];
        lastLocation = [recogniser locationInView:self.view];
    }
    else if(recogniser.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentLocation = [recogniser locationInView:self.view];
        
        if(!self.interactiveTransition)
        {
            if(currentLocation.x > initialLocation.x && self.selectedIndex != 0)
            {
                self.selectedIndex = self.selectedIndex - 1;
            }
            else if(currentLocation.x < initialLocation.x && self.selectedIndex != self.viewControllers.count - 1)
            {
                self.selectedIndex = self.selectedIndex + 1;
            }
        }
        else
        {
            CGFloat distance = fabsf(currentLocation.x - initialLocation.x);
            CGFloat percentDistance = distance / self.view.bounds.size.width;
            NSLog(@"%f", percentDistance);
            [self.interactiveTransition updateInteractiveTransition:percentDistance];
        }
        
        lastLocation = currentLocation;
    }
    else if(recogniser.state == UIGestureRecognizerStateEnded)
    {
        CGPoint currentLocation = [recogniser locationInView:self.view];
        CGFloat distance = fabsf(currentLocation.x - initialLocation.x);
        CGFloat percentDistance = distance / self.view.bounds.size.width;
        if(percentDistance > 0.3)
        {
            [self.interactiveTransition finishInteractiveTransition];
        }
        else
        {
            [self.interactiveTransition cancelInteractiveTransition];
        }
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NSUInteger fromViewConrollerIndex = [self.viewControllers indexOfObject:fromViewController];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSUInteger toViewControllerIndex = [self.viewControllers indexOfObject:toViewController];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    UIView *containerView = [transitionContext containerView];
    [[transitionContext containerView] addSubview:toView];
    
    if(toViewControllerIndex > fromViewConrollerIndex)
    {
        toView.frame = CGRectMake(containerView.bounds.size.width, 0, toView.frame.size.width, toView.frame.size.height);
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             toView.frame = CGRectApplyAffineTransform(toView.frame, CGAffineTransformMakeTranslation(-containerView.bounds.size.width, 0));
                             fromView.frame = CGRectApplyAffineTransform(toView.frame, CGAffineTransformMakeTranslation(-containerView.bounds.size.width, 0));
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
    else
    {
        toView.frame = CGRectMake(-containerView.bounds.size.width, 0, toView.frame.size.width, toView.frame.size.height);
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             toView.frame = CGRectApplyAffineTransform(toView.frame, CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0));
                             fromView.frame = CGRectApplyAffineTransform(toView.frame, CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0));
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
    
}

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC
{
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                      interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController
{
    self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
    return self.interactiveTransition;
}

-(void)animationEnded:(BOOL)transitionCompleted
{
    self.interactiveTransition = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kAMPannableTabBarViewControllerDidMoveToIndex
                                                        object:self
                                                      userInfo:@{@"currentIndex" : @(self.selectedIndex)}];
}

@end
