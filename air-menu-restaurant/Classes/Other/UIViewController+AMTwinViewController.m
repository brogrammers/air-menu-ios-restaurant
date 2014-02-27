//
//  UIViewController+AMTwinViewController.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 26/02/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+AMTwinViewController.h"

@implementation UIViewController (AMTwinViewController)

-(void)setTwinViewController:(AMTwinViewController *)twinViewController
{
    objc_setAssociatedObject(self, @selector(twinViewController), twinViewController, OBJC_ASSOCIATION_ASSIGN);
}

-(AMTwinViewController *)twinViewController
{
    return objc_getAssociatedObject(self, @selector(twinViewController));
}

@end
