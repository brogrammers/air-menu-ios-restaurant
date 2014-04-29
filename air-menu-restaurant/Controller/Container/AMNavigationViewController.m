//
//  AMNavigationViewController.m
//  Air Menu
//
//  Created by Robert Lis on 29/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMNavigationViewController.h"

typedef enum TransitonState {TransitionStatePop, TransitionStatePush} TransitionState;

@interface AMNavigationViewController () <UINavigationControllerDelegate>
@property (nonatomic, readwrite) TransitionState state;
@end

@implementation AMNavigationViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.state = TransitionStatePush;
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.state = TransitionStatePop;
    return [super popViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        // disable interactivePopGestureRecognizer in the rootViewController of navigationController
        if ([[navigationController.viewControllers firstObject] isEqual:viewController]) {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            // enable interactivePopGestureRecognizer
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

#pragma mark - Navigation Controller Delegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.transitionCoordinator)
    {
        viewController.view.alpha = 0.0;
    }
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [context viewControllerForKey:UITransitionContextFromViewControllerKey].view.alpha = 0.0;
        [context viewControllerForKey:UITransitionContextToViewControllerKey].view.alpha = 1.0;
    } completion:nil];
}
@end
