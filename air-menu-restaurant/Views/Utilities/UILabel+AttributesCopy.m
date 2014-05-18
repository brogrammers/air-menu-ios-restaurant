//
//  UILabel+AttributesCopy.m
//  Air Menu C
//
//  Created by Robert Lis on 23/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "UILabel+AttributesCopy.h"
#import <objc/runtime.h>

@implementation UILabel (AttributesCopy)
@dynamic attributes;

-(void)setAttributes:(NSDictionary *)attributes
{
    objc_setAssociatedObject(self, @selector(attributes), attributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSDictionary *)attributes
{
    return objc_getAssociatedObject(self, @selector(attributes));
}

- (void)setTextWithExistingAttributes:(NSString *)text
{
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.attributes];
}
@end
