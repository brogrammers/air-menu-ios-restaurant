//
//  AMFadingSpacer.h
//  Air Menu C
//
//  Created by Robert Lis on 19/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMFadingSpacer : UIView
@property (nonatomic, readwrite) BOOL shouldFade;
@property (nonatomic, readwrite) CGFloat fadePercentage;
@end
