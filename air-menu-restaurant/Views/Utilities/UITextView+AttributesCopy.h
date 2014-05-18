//
//  UITextView+AttributesCopy.h
//  Air Menu C
//
//  Created by Robert Lis on 23/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (AttributesCopy)
- (void)setTextWithExistingAttributes:(NSString *)text;
@property (nonatomic, readwrite) NSDictionary *attributes;
@end
