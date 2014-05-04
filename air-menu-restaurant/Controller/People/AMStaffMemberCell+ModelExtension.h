//
//  AMStaffMemberCell+ModelExtension.h
//  Air Menu
//
//  Created by Robert Lis on 04/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMStaffMemberCell.h"
#import "AMDataAwareReusableView.h"

@interface AMStaffMemberCell (ModelExtension) <AMDataAwareReusableView>
-(void)displayData:(id)item atIndexPath:(NSIndexPath *)indexPath;
@end
