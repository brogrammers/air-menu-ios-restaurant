//
//  AMStaffMemberCell.h
//  Air Menu
//
//  Created by Robert Lis on 30/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMSlideCollectionViewCell.h"

@interface AMStaffMemberCell : AMSlideCollectionViewCell
@property (nonatomic, readonly, weak) UIImageView *memberPhoto;
@property (nonatomic, readonly, weak) UILabel *memberName;
@end
