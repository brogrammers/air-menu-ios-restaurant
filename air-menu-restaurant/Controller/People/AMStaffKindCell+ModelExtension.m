//
//  AMStaffKindCell+ModelExtension.m
//  Air Menu
//
//  Created by Robert Lis on 04/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMStaffKindCell+ModelExtension.h"
#import "UILabel+AttributesCopy.h"

@implementation AMStaffKindCell (ModelExtension)
-(void)displayData:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    AMStaffKind *staffKind = item;
    [self setNumberOfMembers:staffKind.members.count];
    [self setAcceptsItems:[staffKind.acceptsOrderItems boolValue]];
    [self setAcceptsOrders:[staffKind.acceptsOrders boolValue]];
    [self.staffKindLabel setTextWithExistingAttributes:[staffKind.name uppercaseString]];
}
@end
