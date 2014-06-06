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
    if(!self.leftBlock && scrollView.contentOffset.x < 0.0)
    {
        CGRect bounds = scrollView.bounds;
        bounds.origin = CGPointMake(0, 0);
        scrollView.bounds = bounds;
    }
    else if (!self.rightBlock && scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.size.width)
    {
        CGRect bounds = scrollView.bounds;
        bounds.origin = CGPointMake(MAX(0, scrollView.contentSize.width - scrollView.bounds.size.width), 0);
        scrollView.bounds = bounds;
    }
    else
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
}

-(void)restoreState
{
    self.backgroundColor = [UIColor clearColor];
    [[self valueForKey:@"rightImageView"] setAlpha:0.0];
}

@end
