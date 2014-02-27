//
//  UIViewController+AMTwinViewController.h
//  air-menu-restaurant
//
//  Created by Robert Lis on 26/02/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMTwinViewController.h"

@interface UIViewController (AMTwinViewController)
@property (nonatomic, weak, readonly) AMTwinViewController *twinViewController;
@end
