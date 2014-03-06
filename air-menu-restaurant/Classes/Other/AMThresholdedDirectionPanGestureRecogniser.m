//
//  AMThresholdedDirectionPanGestureRecogniser.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 05/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMThresholdedDirectionPanGestureRecogniser.h"

@implementation AMThresholdedDirectionPanGestureRecogniser
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    BOOL anyTouchBelowThreshold = NO;
    for(UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInView:self.view];
        
        if(self.direction == AMDirectionPanGestureRecognizerHorizontal)
        {
            if (touchLocation.x <= self.beginTreshold || touchLocation.x >= self.view.bounds.size.width - self.beginTreshold)
            {
                anyTouchBelowThreshold = YES;
            }
        }
        else if (self.direction == AMDirectionPangestureRecognizerVertical)
        {
            if(touchLocation.x <= self.beginTreshold || touchLocation.x >= self.view.bounds.size.height - self.beginTreshold)
            {
                anyTouchBelowThreshold = YES;
            }
        }
    }
    
    if (!anyTouchBelowThreshold)
    {
        self.state = UIGestureRecognizerStateFailed;
    }
}
@end
