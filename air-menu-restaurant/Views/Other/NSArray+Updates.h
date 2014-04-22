//
//  NSArray+Updates.h
//  Air Menu
//
//  Created by Robert Lis on 21/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Updates)
-(NSSet *)toRemove:(NSArray *)otherArray;
-(NSSet *)toUpdate:(NSArray *)otherArray;
-(NSSet *)toAdd:(NSArray *)otherArray;
@end
