//
//  AMDirectionPanGestureRecognizer.h
//  air-menu-restaurant
//
//  Created by Robert Lis on 02/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum
{
    AMDirectionPangestureRecognizerVertical,
    AMDirectionPanGestureRecognizerHorizontal
} AMDirectionPangestureRecognizerDirection;

@interface AMDirectionPanGestureRecognizer : UIPanGestureRecognizer
@property (readonly) BOOL drag;
@property (readonly) int moveX;
@property (readonly) int moveY;
@property (readwrite) AMDirectionPangestureRecognizerDirection direction;
@end