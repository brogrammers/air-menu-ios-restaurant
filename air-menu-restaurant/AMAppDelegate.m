//
//  AMAppDelegate.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 28/11/2013.
//  Copyright (c) 2013 Air-menu. All rights reserved.
//

#import "AMAppDelegate.h"
#import "AMTwinViewController.h"
#import "AMRestaurantCardsViewController.h"
#import "AMRestaurantQuickViewController.h"
#import "AMCompanyViewController.h"
#import "AMSidePanelViewContoller.h"
#import "AMLoginViewContoller.h"
#import <AirMenuKit/AMClient.h>

@implementation AMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    if([[AMClient sharedClient] isLoggedIn])
    {
        UIViewController *viewController = [self createViewController];
        window.rootViewController = viewController;
    }
    else
    {
        AMLoginViewContoller *loginViewController = [[AMLoginViewContoller alloc] init];
        window.rootViewController = loginViewController;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[self backgroundImage]];
    self.window.backgroundColor = background;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|
                                                                           UIRemoteNotificationTypeBadge|
                                                                           UIRemoteNotificationTypeSound)];
    
    [window makeKeyAndVisible];

    return YES;
}

-(void)didLogin
{
    CGPoint currentCenter = self.window.rootViewController.view.center;
    CGSize viewSize = self.window.rootViewController.view.bounds.size;
    CGPoint newCenter = CGPointApplyAffineTransform(currentCenter, CGAffineTransformMakeTranslation(0, viewSize.height));
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.window.rootViewController.view.center = newCenter;
                     }
                     completion:^(BOOL finished) {
                         self.window.rootViewController = [self createViewController];
                         self.window.rootViewController.view.center = newCenter;
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.window.rootViewController.view.center = currentCenter;
                                          }
                                          completion:nil];
                     }];
}

-(UIViewController *)createViewController
{
    AMTwinViewController *controller = [[AMTwinViewController alloc] init];
    AMSidePanelViewContoller *viewController = [[AMSidePanelViewContoller alloc] init];
    [viewController setSidePanelViewController:[[AMCompanyViewController alloc] init]];
    [viewController setContentViewController:controller];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [controller setViewController:[[AMRestaurantCardsViewController alloc] init] inPosition:AMTwinViewControllerPositionFirst];
        [controller setViewController:[[AMRestaurantQuickViewController alloc] init] inPosition:AMTwinViewControllerPositionSecond];
    }
    else
    {
        [controller setViewController:[[AMRestaurantQuickViewController alloc] init] inPosition:AMTwinViewControllerPositionFirst];
        [controller setViewController:[[AMRestaurantCardsViewController alloc] init] inPosition:AMTwinViewControllerPositionSecond];
    }
    
    return viewController;
}

-(void)didLogout
{
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
}

-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

-(UIImage *)backgroundImage
{
    CGSize size = self.window.bounds.size;
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





