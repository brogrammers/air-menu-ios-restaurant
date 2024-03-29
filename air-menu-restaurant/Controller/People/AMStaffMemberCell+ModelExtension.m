//
//  AMStaffMemberCell+ModelExtension.m
//  Air Menu
//
//  Created by Robert Lis on 04/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMStaffMemberCell+ModelExtension.h"
#import "UILabel+AttributesCopy.h"

@implementation AMStaffMemberCell (ModelExtension)
-(void)displayData:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    AMStaffMember *member = item;
    [self.memberName setTextWithExistingAttributes:member.name];
}
@end
