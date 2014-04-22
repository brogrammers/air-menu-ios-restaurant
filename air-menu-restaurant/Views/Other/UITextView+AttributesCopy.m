//
//  UITextView+AttributesCopy.m
//  Air Menu C
//
//  Created by Robert Lis on 23/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "UITextView+AttributesCopy.h"
#import <objc/runtime.h>

@implementation UITextView (AttributesCopy)
@dynamic attributes;

-(void)setAttributes:(NSDictionary *)attributes
{
    objc_setAssociatedObject(self, @selector(setTextWithExistingAttributes:), attributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSDictionary *)attributes
{
    return objc_getAssociatedObject(self, @selector(setTextWithExistingAttributes:));
}

- (void)setTextWithExistingAttributes:(NSString *)text
{
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.attributes];
}
@end
