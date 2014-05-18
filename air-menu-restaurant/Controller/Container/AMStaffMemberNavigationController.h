//
//  AMStaffMemberNavigationController.h
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMScopeDrivenNavigationController.h"

@interface AMStaffMemberNavigationController : AMScopeDrivenNavigationController
@property (nonatomic, readwrite, strong) AMStaffMember *staffMember;
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user staffMember:(AMStaffMember *)member;
@end
