//
//  AMRestaurantPickerViewController.h
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPickerViewController.h"

@interface AMRestaurantViewPickerViewController : AMPickerViewController
@property (nonatomic, readwrite) AMRestaurant *restaurant;
@property (nonatomic, readwrite) AMStaffMember *member;
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user staffMember:(AMStaffMember *)member;
@end
