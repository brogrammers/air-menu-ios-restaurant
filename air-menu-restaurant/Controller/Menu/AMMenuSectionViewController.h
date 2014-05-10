//
//  AMMenuSectionViewController.h
//  Air Menu
//
//  Created by Robert Lis on 09/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMMenuSectionViewController : UIViewController
@property (nonatomic, readwrite, strong) AMMenuSection *section;
-(id)initWithSection:(AMMenuSection *)menuSection;
@end
