//
//  AMScopeDrivenViewController.m
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMScopeDrivenViewController.h"

@implementation AMScopeDrivenViewController
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user
{
    self = [super init];
    if(self)
    {
        self.scopes = scopes;
        self.user = user;
    }
    return self;
}
@end
