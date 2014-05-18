//
//  AMReorderableLayout.m
//  Air Menu
//
//  Created by Robert Lis on 04/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMReorderableLayout.h"

@implementation AMReorderableLayout

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableArray *decorationAttributesToAdd = [NSMutableArray array];
    NSMutableSet *sectionsDecorated = [NSMutableSet set];
    [layoutAttributes each:^(UICollectionViewLayoutAttributes *attribute) {
        if(![sectionsDecorated containsObject:@(attribute.indexPath.section)])
        {
            [decorationAttributesToAdd addObject:[self layoutAttributesForDecorationViewOfKind:@"background" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:attribute.indexPath.section]]];
            [sectionsDecorated addObject:@(attribute.indexPath.section)];
        }
    }];
    
    [layoutAttributes addObjectsFromArray:decorationAttributesToAdd];
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:indexPath.section];
    __block CGRect decorationViewFrame = CGRectZero;
    [@(0) upto:(int)numberOfItems - 1 do:^(NSInteger cellNumber) {
        UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:cellNumber inSection:indexPath.section]];
        CGRect cellFrame = cellAttributes.frame;
        if(CGRectEqualToRect(decorationViewFrame, CGRectZero))
        {
            decorationViewFrame = cellFrame;
        }
        else
        {
            decorationViewFrame = CGRectUnion(cellFrame, decorationViewFrame);
        }
    }];
    
    attributes.frame = decorationViewFrame;
    if(CGRectEqualToRect(attributes.frame, CGRectZero))
    {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        attributes.frame = attr.frame;
    }
    else
    {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        attributes.frame = CGRectUnion(attributes.frame, attr.frame);

    }
    
    attributes.zIndex = -1000;
    return attributes;
}

@end
