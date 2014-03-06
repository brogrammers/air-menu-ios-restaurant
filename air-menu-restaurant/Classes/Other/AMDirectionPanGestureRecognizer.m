//
//  AMDirectionPanGestureRecognizer.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 02/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMDirectionPanGestureRecognizer.h"

int const static kDirectionPanThreshold = 5;
@interface AMDirectionPanGestureRecognizer ()
@property (readwrite) BOOL drag;
@property (readwrite) int moveX;
@property (readwrite) int moveY;
@end

@implementation AMDirectionPanGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    self.moveX += prevPoint.x - nowPoint.x;
    self.moveY += prevPoint.y - nowPoint.y;
    if (!self.drag)
    {
        if (abs(self.moveX) > kDirectionPanThreshold) {
            if (self.direction == AMDirectionPangestureRecognizerVertical)
            {
                self.state = UIGestureRecognizerStateFailed;
            }
            else
            {
                self.drag = YES;
            }
        }
        else if (abs(self.moveY) > kDirectionPanThreshold)
        {
            if (self.direction == AMDirectionPanGestureRecognizerHorizontal)
            {
                self.state = UIGestureRecognizerStateFailed;
            }
            else
            {
                self.drag = YES;
            }
        }
    }
}

- (void)reset
{
    [super reset];
    self.drag = NO;
    self.moveX = 0;
    self.moveY = 0;
}

@end