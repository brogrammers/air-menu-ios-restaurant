//
//  AMMenuViewController.h
//  Air Menu
//
//  Created by Robert Lis on 09/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPagedViewController.h"

@interface AMMenuViewController : AMPagedViewController
@property (nonatomic, readwrite, strong) AMMenu *menu;
@property (nonatomic, readwrite) NSArray *menuSections;
-(AMMenuSection *)currentlySelectedMenuSection;
-(id)initWithMenu:(AMMenu *)menu;
@end
