//
//  AMOrderItemWithState.h
//  Air Menu
//
//  Created by Robert Lis on 03/06/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMScopeDrivenViewController.h"

@interface AMOrderItemWithStateViewController : AMScopeDrivenViewController
@property (nonatomic, readwrite) AMOrderItemState stateToShow;
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user requiredState:(AMOrderItemState)state;
@end
