//
//  AMMenuItemCell+ModelExtension.m
//  Air Menu
//
//  Created by Robert Lis on 10/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuItemCell+ModelExtension.h"

@implementation AMMenuItemCell (ModelExtension)
-(void)displayData:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    AMMenuItem *menuItem = item;
    [self setName:menuItem.name];
    [self setDescription:menuItem.details];
    [self setPrice:[[menuItem.price.description stringByAppendingString:@" " ]stringByAppendingString:menuItem.currency]];
}
@end
