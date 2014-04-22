//
//  AMScopeDrivenNavigationController.h
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "MSDynamicsDrawerViewController.h"

@interface AMScopeDrivenNavigationController : MSDynamicsDrawerViewController
@property (nonatomic, readwrite, strong) NSArray *scopes;
@property (nonatomic, readwrite, strong) AMUser *user;
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user;
@end
