//
//  AMButton.h
//  Air Menu
//
//  Created by Robert Lis on 14/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "FlatPillButton.h"

@interface AMButton : FlatPillButton
@property (nonatomic, readwrite) CGFloat fontSize;
+ (AMButton *)button;
@end
