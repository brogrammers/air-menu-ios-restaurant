//
//  AMFormViewController.h
//  Air Menu
//
//  Created by Robert Lis on 21/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "XLFormViewController.h"

typedef void (^FormAction)();

@interface AMFormViewController : XLFormViewController
+(AMFormViewController *)restaurantInputViewController;
+(AMFormViewController *)restaurantUpdateViewController:(AMRestaurant *)restaurant;
+(AMFormViewController *)staffKindCreateViewController;
+(AMFormViewController *)loginViewController;
+(AMFormViewController *)createStaffMemberViewController;
-(void)setAction:(FormAction)action forTitle:(NSString *)title;
@end
