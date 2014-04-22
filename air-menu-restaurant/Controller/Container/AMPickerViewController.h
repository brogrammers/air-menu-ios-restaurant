//
//  UITableViewController+AMPickerViewController.h
//  Air Menu C
//
//  Created by Robert Lis on 13/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerStyler.h>
#import "AMScopeDrivenNavigationController.h"

@interface AMPickerViewController : AMScopeDrivenNavigationController
@property (nonatomic, readwrite, weak) MSDynamicsDrawerViewController *controller;
@property (nonatomic, readwrite, strong) NSArray *names;
@property (nonatomic, readwrite, strong) NSArray *icons;
@property (nonatomic, readwrite, strong) NSArray *controllers;
@property (nonatomic, readwrite) BOOL displayHeader;
@end
