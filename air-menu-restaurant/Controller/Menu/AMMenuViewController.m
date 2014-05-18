//
//  AMMenuViewController.m
//  Air Menu
//
//  Created by Robert Lis on 09/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuViewController.h"
#import "AMMenuSectionViewController.h"
#import "AMDataSource.h"
#import "CRToastManager+AMNotification.h"

@interface AMMenuViewController ()
@end

@implementation AMMenuViewController
-(id)initWithMenu:(AMMenu *)menu
{
    self = [super init];
    if(self)
    {
        self.menu = menu;
    }
    return self;
}

-(void)setMenu:(AMMenu *)menu
{
    _menu = menu;
    [self getOrShowSections];
}

-(void)getOrShowSections
{
    if(!self.menu.menuSections)
    {
        [self getSectionsOfMenu];
    }
    else
    {
        [self showSections:self.menu.menuSections];
    }
}

-(void)getSectionsOfMenu
{
    [[AMClient sharedClient] findSectionsOfMenu:self.menu completion:^(NSArray *sections, NSError *error) {
        if(error)
        {
            [CRToastManager showErrorWithMessage:[error localizedDescription]];
            return;
        }
        self.menuSections = sections;
        [self showSections:sections];
    }];
}

-(void)showSections:(NSArray *)sections
{
    if(sections)
    {
        [self removeAllViewControllers];
    }
    
    [sections each:^(AMMenuSection *section) {
        AMMenuSectionViewController *sectionViewController = [[AMMenuSectionViewController alloc] initWithSection:section];
        [self addViewController:sectionViewController forLabelWithText:section.name];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setNeedsLayout];
}

-(AMMenuSection *)currentlySelectedMenuSection
{
    //fixme
    return self.menuSections.count > 0 ? self.menuSections[[self.viewControllers indexOfObject:self.currentlySelectedViewController]] : nil;
}
@end
