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
#import <MZFormSheetController/MZFormSheetController.h>
#import "AMPagedViewController.h"
#import <MSDynamicsDrawerViewController.h>

typedef void (^Action)();

@interface AMAppDelegate() <AMLoginViewControllerDelegate, MSDynamicsDrawerViewControllerDelegate>
@property (nonatomic, readwrite,  weak) AMLoginViewContoller *loginViewController;
@end

@implementation AMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@", [[UIDevice currentDevice] identifierForVendor]);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|
                                                                           UIRemoteNotificationTypeBadge|
                                                                           UIRemoteNotificationTypeSound)];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:35.0];
    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    self.window.layer.contents = (id) [UIImage imageNamed:@"background_ipad"].CGImage;

    [[AMClient sharedClient] registerHadnler:^{
        [self logOut];
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

-(void)logOut
{
    [[AMClient sharedClient] logOut];
    [self didLogout];
}

-(void)didLogout
{
    [self animateApplicationDisapperiance:^{
        [self showLoginViewControllerAnimate:YES];
    }];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error %@", error);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [[AMClient sharedClient].requestSerializer setValue:[[UIDevice currentDevice].identifierForVendor UUIDString] forHTTPHeaderField:@"X-Device-UUID"];
//    [[AMClient sharedClient].requestSerializer setValue:deviceToken.description forHTTPHeaderField:@"X-Device-Token"];
}

-(void)didLogin
{
    [[AMClient sharedClient] findCurrentUser:^(AMUser *user, NSError *error) {
        UIViewController *viewController;
        if (user.type == AMUserTypeUser)
        {
            [self logOut];
        }
        else if(user.type == AMUserTypeOwner)
        {
            viewController = [[AMOwnerNavigationController alloc] initWithScopes:user.scopes user:user];
            [self regiterDeviceForCurrentUser];
        }
        else if(user.type == AMUserTypeStaffMember)
        {
            UIViewController *staffViewController = [[AMStaffMemberNavigationController alloc] initWithScopes:user.scopes user:user staffMember:user.staffMember];
            ((MSDynamicsDrawerViewController *)staffViewController).shouldAlignStatusBarToPaneView = NO;
            viewController = staffViewController;
            [self animateApplicationApperiance:nil];
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
    [[AMClient sharedClient] authenticateWithClientID:@"f7650ea676866b456667d1b390e69c3ac56489968b5556653b7af019cbd3af6f"
                                         clientSecret:@"77ab5a134c0688f9b322ebbb93275b78e31d7fb6f39a7b4b15dc2cd09c01f978"
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


-(void)registerCurrentDeviceForRestaurant:(AMRestaurant *)restaurant
{
    [[AMClient sharedClient] createDeviceOfRestaurant:restaurant
                                             withName:@"ios-device"
                                                 uuid:[[UIDevice currentDevice].identifierForVendor UUIDString]
                                                token:@"" 
                                             platform:@"ios"
                                           completion:^(AMDevice *device, NSError *error) {
                                               if(!error)
                                               {
                                                   NSLog(@"success");
                                               }
                                               else
                                               {
                                                   NSLog(@"%@", error);
                                               }
                                           }];
}

-(void)regiterDeviceForCurrentUser
{
    [[AMClient sharedClient] createDeviceOfCurrentUserWithName:@"iphone_device"
                                                          uuid:[[UIDevice currentDevice].identifierForVendor UUIDString]
                                                         token:@""   
                                                      platform:@"ios"
                                                    completion:^(AMDevice *device, NSError *error) {
                                                        if(!error)
                                                        {
                                                            NSLog(@"success");
                                                        }
                                                        else
                                                        {
                                                            NSLog(@"%@", error);
                                                        }
                                                    }];
}


@end





