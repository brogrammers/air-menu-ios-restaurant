//
//  NSArray+Updates.m
//  Air Menu
//
//  Created by Robert Lis on 21/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "NSArray+Updates.h"

@implementation NSArray (Updates)
-(NSSet *)toRemove:(NSArray *)otherArray
{
    NSMutableSet *thisSet = [NSMutableSet setWithArray:self];
    NSMutableSet *otherSet = [NSMutableSet setWithArray:otherArray];
    [thisSet minusSet:otherSet];
    return thisSet;
}

-(NSSet *)toUpdate:(NSArray *)otherArray
{
    NSMutableSet *thisSet = [NSMutableSet setWithArray:self];
    NSMutableSet *otherSet = [NSMutableSet setWithArray:otherArray];
    
    NSMutableSet *toUpdate = [NSMutableSet set];
    [thisSet intersectSet:otherSet];
    [thisSet each:^(id object) {
        if([self indexOfObject:object] != [otherArray indexOfObject:object])
        {
            [toUpdate addObject:object];
        }
    }];
    
    return toUpdate;
}

-(NSSet *)toAdd:(NSArray *)otherArray
{
    NSMutableSet *thisSet = [NSMutableSet setWithArray:self];
    NSMutableSet *otherSet = [NSMutableSet setWithArray:otherArray];
    [otherSet minusSet:thisSet];
    return otherSet;
}
@end
