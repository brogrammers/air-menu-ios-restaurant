//
//  UICollectionView+AMCollectionViewAdapter.m
//  Air Menu
//
//  Created by Robert Lis on 04/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <objc/runtime.h>
#import "UICollectionView+AMCollectionViewAdapter.h"

@implementation UICollectionView (AMCollectionViewAdapter)
-(void)setIdentifierToCellClass:(NSDictionary *)identifierToCellClass
{
    objc_setAssociatedObject(self, @selector(setIdentifierToCellClass:), identifierToCellClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSString *identifier = [[identifierToCellClass allKeys] firstObject];
    [self registerClass:identifierToCellClass[identifier] forCellWithReuseIdentifier:identifier];
}

-(NSDictionary *)identifierToCellClass
{
    return objc_getAssociatedObject(self, @selector(setIdentifierToCellClass:));
}

-(void)setIdentifierToHeaderClass:(NSDictionary *)identifierToHeaderClass
{
    objc_setAssociatedObject(self, @selector(setIdentifierToHeaderClass:), identifierToHeaderClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSString *identifier = [[identifierToHeaderClass allKeys] firstObject];
    [self registerClass:identifierToHeaderClass[identifier] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

-(NSDictionary *)identifierToHeaderClass
{
    return objc_getAssociatedObject(self, @selector(setIdentifierToHeaderClass:));
}

-(void)setIdentifierToFooterClass:(NSDictionary *)identifierToFooterClass
{
    objc_setAssociatedObject(self, @selector(setIdentifierToFooterClass:), identifierToFooterClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSString *identifier = [[identifierToFooterClass allKeys] firstObject];
    [self registerClass:identifierToFooterClass[identifier] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
}

-(NSDictionary *)identifierToFooterClass
{
    return objc_getAssociatedObject(self, @selector(setIdentifierToFooterClass:));
}

@end
