//
//  AMDeviceCell.h
//  Air Menu
//
//  Created by Robert Lis on 06/06/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMSlideCollectionViewCell.h"
#import "AMDataAwareReusableView.h"

@interface AMDeviceCell : AMSlideCollectionViewCell <AMDataAwareReusableView>
@property (nonatomic, readonly, weak) UILabel *name;
@property (nonatomic, readonly, weak) UILabel *platform;
@property (nonatomic, readonly, weak) UILabel *uuid;
@end
