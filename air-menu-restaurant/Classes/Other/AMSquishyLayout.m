//
//  AMSqushyLayout.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 25/02/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMSquishyLayout.h"

@interface AMSquishyLayout()
@property CGFloat squishAmount;
@property BOOL applySquish;
@property BOOL isObservingContentOffset;
@property BOOL issTransitioning;
@end

@implementation AMSquishyLayout

-(void)prepareLayout
{
    if(!self.isObservingContentOffset)
    {
        [self.collectionView addObserver:self
                              forKeyPath:@"contentOffset"
                                 options:NSKeyValueObservingOptionNew context:NULL];
        
        self.isObservingContentOffset = YES;
    }
    
    [super prepareLayout];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return [self layoutAttributesForItemAtIndexPath:itemIndexPath];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        if([self isOffContentView])
        {
            CGFloat offset = (+self.squishAmount * attributes.indexPath.row) / 5;
            if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
            {
                attributes.center = CGPointMake(attributes.center.x + offset, attributes.center.y);
            }
            else
            {
                attributes.center = CGPointMake(attributes.center.x, attributes.center.y + offset);
            }
        }
    }];
    return attributes;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    return CGPointZero;
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"] && object == self.collectionView)
    {
        [self scrollViewDidScroll];
    }
}

-(void)scrollViewDidScroll
{
    if([self isOffContentView] && !self.isTransitoning)
    {
        CGFloat squish;
        if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        {
            if ([self isOverX])
            {
                squish = (self.collectionView.contentOffset.x + self.collectionView.bounds.size.width) - self.collectionView.contentSize.width;
            }
            else
            {
                squish = fabsf(self.collectionView.contentOffset.x);
            }
        }
        else
        {
            if([self isOverY])
            {
                squish = (self.collectionView.contentOffset.y + self.collectionView.bounds.size.height) - self.collectionView.contentSize.height;
            }
            else
            {
                squish = fabsf(self.collectionView.contentOffset.y);
            }
        }
        self.squishAmount = squish;
        [self invalidateLayout];
    }
    else
    {
        self.applySquish = NO;
    }
}

-(BOOL)isOffContentView
{
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        return [self isOverX] || [self isUnderX];
    }
    else
    {
        return [self isOverY] || [self isUnderY];
    }
}

-(BOOL)isOverX
{
    return self.collectionView.contentOffset.x + self.collectionView.bounds.size.width >= self.collectionView.contentSize.width;
}

-(BOOL)isUnderX
{
    return self.collectionView.contentOffset.x <= 0.0f;
}

-(BOOL)isOverY
{
    return self.collectionView.contentOffset.y + self.collectionView.bounds.size.height >= self.collectionView.contentSize.height;
}

-(BOOL)isUnderY
{
    return self.collectionView.contentOffset.y <= 0.0;
}

-(void)dealloc
{
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
}

@end
