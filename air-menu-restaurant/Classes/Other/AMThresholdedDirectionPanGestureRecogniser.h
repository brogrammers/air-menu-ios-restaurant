//
//  AMThresholdedDirectionPanGestureRecogniser.h
//  air-menu-restaurant
//
//  Created by Robert Lis on 05/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMDirectionPanGestureRecognizer.h"

@interface AMThresholdedDirectionPanGestureRecogniser : AMDirectionPanGestureRecognizer
@property (nonatomic, readwrite) CGFloat beginTreshold;
@end
