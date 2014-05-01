//
//  AMAppDelegate.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 28/11/2013.
//  Copyright (c) 2013 Air-menu. All rights reserved.
//

#import "AMAppDelegate.h"
#import <AirMenuKit/AirMenuKit.h>
#import "AMInitialViewController.h"
#import "AMLoginViewContoller.h"
#import "UIColor+AirMenuColor.h"
#import "AMOwnerNavigationController.h"
#import "AMStaffMemberNavigationController.h"
#import "AMLoginViewContoller.h"

typedef void (^Action)();

@interface AMAppDelegate() <AMLoginViewControllerDelegate>
@property (nonatomic, readwrite, weak) AMLoginViewContoller *loginViewController;
@end

@implementation AMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|
                                                                           UIRemoteNotificationTypeBadge|
                                                                           UIRemoteNotificationTypeSound)];
    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    self.window.layer.contents = (id) [UIImage imageNamed:@"background_ipad"].CGImage;

    [[AMClient sharedClient] registerHadnler:^{
        [self didLogout];
    } forErrorCode:@"401"];
    
    if([[AMClient sharedClient] isLoggedIn])
    {
        [self didLogin];
    }
    else
    {
        [self showLoginViewControllerAnimate:NO];
    }
    
    [window makeKeyAndVisible];
    return YES;
}

-(void)didLogin
{
    [[AMClient sharedClient] findCurrentUser:^(AMUser *user, NSError *error) {
        UIViewController *viewController;
        if (user.type == AMUserTypeUser)
        {
            return;
        }
        else if(user.type == AMUserTypeOwner)
        {
            viewController = [[AMOwnerNavigationController alloc] initWithScopes:user.scopes user:user];
        }
        else if(user.type == AMUserTypeStaffMember)
        {
            viewController = [[AMStaffMemberNavigationController alloc] initWithScopes:user.scopes user:user];
        }
        self.window.rootViewController = viewController;
        [self animateApplicationApperiance:nil];
    }];
}

-(void)showLoginViewControllerAnimate:(BOOL)shouldAnimate
{
    AMLoginViewContoller *loginViewController = [[AMLoginViewContoller alloc] init];
    loginViewController.delegate = self;
    self.loginViewController = loginViewController;
    self.window.rootViewController = loginViewController;
    if(shouldAnimate)
    {
        [self animateApplicationApperiance:nil];
    }
}

-(void)didRequestLoginWithUsernane:(NSString *)username password:(NSString *)password
{
    [self loginWithUserName:username password:password];
}

-(void)didRequestRegistrationWithUsernane:(NSString *)username passsword:(NSString *)password email:(NSString *)email
{
    
}

-(void)loginWithUserName:(NSString *)userName password:(NSString *)password
{
    [[AMClient sharedClient] authenticateWithClientID:@"3449f5bc12a194ad021950970326e2e13d75fe246ad006aaed792f870cc3aaee"
                                         clientSecret:@"7b7d80d9a048a774e1e58104d01a6d393ed7702a9203afdc0b8e44a614b2db6f"
                                             username:userName
                                             password:password
                                               scopes:[AMOAuthToken allScopes]
                                           completion:^(AMOAuthToken *token, NSError *error) {
                                               if(!error)
                                               {
                                                   [self animateApplicationDisapperiance:^{
                                                       [self didLogin];
                                                   }];
                                               }
                                           }];
}

-(void)animateApplicationApperiance:(Action)block
{
    self.window.rootViewController.view.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.window.rootViewController.view.alpha = 1.0;
                         if(block) block();
                     }
                     completion:nil];
}

-(void)animateApplicationDisapperiance:(Action)block
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.window.rootViewController.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         self.window.rootViewController = nil;
                         if(block) block();
                     }];
}

-(void)didLogout
{
    [self animateApplicationDisapperiance:^{
        [self showLoginViewControllerAnimate:YES];
    }];
}

@end





