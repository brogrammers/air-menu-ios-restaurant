//
//  AMMenuCell+ModelExtension.m
//  Air Menu
//
//  Created by Robert Lis on 10/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuCell+ModelExtension.h"

@implementation AMMenuCell (ModelExtension)
-(void)displayData:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    AMMenu *menu = item;
    [self setName:menu.name];
}
@end
