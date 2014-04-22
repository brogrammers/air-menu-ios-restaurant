//
//  AMScopeDrivenViewController.h
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMScopeDrivenViewController : UIViewController
@property (nonatomic, readwrite, strong) NSArray *scopes;
@property (nonatomic, readwrite, strong) AMUser *user;
-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user;
@end
