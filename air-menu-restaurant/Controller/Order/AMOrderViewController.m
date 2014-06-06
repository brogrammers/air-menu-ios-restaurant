//
//  AMOrderViewController.m
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMOrderViewController.h"
#import "AMPagedViewController.h"
#import "AMOrderWithStateViewController.h"
#import "AMOrderItemWithStateViewController.h"
#import "AMAppDelegate.h"

@interface AMOrderViewController ()
@property (nonatomic, strong) AMPagedViewController *ordersViewController;
@end

@implementation AMOrderViewController
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user
{
    self = [super initWithScopes:scopes user:user];
    if(self)
    {
        [self configure];
    }
    return self;
}

-(void)configure
{
    AMPagedViewController *viewController = [[AMPagedViewController alloc] init];
    self.ordersViewController = viewController;
    [self addChildViewController:viewController];
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:viewController.view];
    [self.ordersViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.ordersViewController didMoveToParentViewController:self];
    
    AMOrderWithStateViewController *openOrder = [[AMOrderWithStateViewController alloc] initWithScopes:self.scopes user:self.user requiredState:AMOrderStateOpen];
    AMOrderWithStateViewController *approvedOrders = [[AMOrderWithStateViewController alloc] initWithScopes:self.scopes user:self.user requiredState:AMOrderStateApproved];
    AMOrderItemWithStateViewController *preparedOrderItems = [[AMOrderItemWithStateViewController alloc] initWithScopes:self.scopes user:self.user requiredState:AMOrderItemStatePrepared];
    [viewController addViewController:openOrder forLabelWithText:@"AWAITING ORDERS"];
    [viewController addViewController:approvedOrders forLabelWithText:@"YOUR ORDERS"];
    [viewController addViewController:preparedOrderItems forLabelWithText:@"PREPARED ITEMS"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.layer.contents = (id) [self backgroundImage].CGImage;
}

-(UIImage *)backgroundImage
{
    AMAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    CGSize size = delegate.window.bounds.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBackgroundImageInContext:context withSize:size];
    UIImage *background =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return background;
}

-(void)drawBackgroundImageInContext:(CGContextRef)context withSize:(CGSize)size
{
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[2] = { 0.0, 1.0 };
    NSArray *colors = @[(id)[UIColor colorWithRed:18/255.0f green:115/255.0f blue:160/255.0f alpha:1.0].CGColor,
                        (id)[UIColor colorWithRed:203/255.0f green:177/255.0f blue:153/255.0f alpha:1.0].CGColor];
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    CGPoint startPoint, endPoint;
    startPoint.x = 0.0;
    startPoint.y = 0.0;
    endPoint.x = size.width;
    endPoint.y = size.height;
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}

@end
