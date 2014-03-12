//
//  AMRestaurantCreatorViewController.h
//  Air Menu
//
//  Created by Robert Lis on 12/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AirMenuKit/AMClient+Company.h>

@class AMRestaurantCreatorViewController;
@protocol AMRestaurantCreatorViewControllerDelegate <NSObject>
-(void)restaurantCreatorViewController:(AMRestaurantCreatorViewController *)controller didCreateCompany:(AMCompany *)company;
@end

@interface AMRestaurantCreatorViewController : UIViewController
@property (nonatomic, readwrite, weak) id <AMRestaurantCreatorViewControllerDelegate> delegate;
@property (nonatomic, readwrite, weak) UILabel *titleLabel;
@property (nonatomic, readwrite, weak) UIButton *button;
@end
