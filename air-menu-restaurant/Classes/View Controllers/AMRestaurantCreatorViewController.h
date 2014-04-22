//
//  AMRestaurantCreatorViewController.h
//  Air Menu
//
//  Created by Robert Lis on 12/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AirMenuKit/AMClient+Company.h>
#import "AMFormView.h"

@class AMRestaurantCreatorViewController;
@protocol AMRestaurantCreatorViewControllerDelegate <NSObject>
-(void)restaurantCreatorViewController:(AMRestaurantCreatorViewController *)controller didCreateRestaurant:(AMRestaurant *)restaurant;
@end

@interface AMRestaurantCreatorViewController : UIViewController
@property (nonatomic, readwrite, weak) id <AMRestaurantCreatorViewControllerDelegate> delegate;
@property (nonatomic, readonly, weak) UILabel *titleLabel;
@property (nonatomic, readonly, weak) UIButton *button;
@property (nonatomic, readonly, weak) AMFormView *formView;
@property (nonatomic, readwrite, strong) AMCompany *company;
@end
