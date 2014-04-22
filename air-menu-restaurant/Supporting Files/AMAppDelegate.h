//
//  AMAppDelegate.h
//  air-menu-restaurant
//
//  Created by Robert Lis on 28/11/2013.
//  Copyright (c) 2013 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(void)didLogin;
-(void)didLogout;
@end
