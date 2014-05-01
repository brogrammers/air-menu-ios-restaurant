//
//  AMSlideCollectionViewCell.m
//  Air Menu
//
//  Created by Robert Lis on 30/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMSlideCollectionViewCell.h"

@interface JCRSlideCollectionViewCell() <UIScrollViewDelegate>
@end

@implementation AMSlideCollectionViewCell

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    CGFloat xOffset = [scrollView contentOffset].x;
    CGFloat alpha = xOffset / (320 / 2);
    if (xOffset < 0)
    {
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:fabs(alpha)];
    }
    else if (xOffset > 0)
    {
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:fabsf(alpha)];
    }
}

-(void)restoreState
{
    self.backgroundColor = [UIColor clearColor];
    [[self valueForKey:@"rightImageView"] setAlpha:0.0];
}

@end
