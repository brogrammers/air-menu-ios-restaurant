//
//  AMResizingView.m
//  Air Menu
//
//  Created by Robert Lis on 15/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMResizingView.h"

@implementation AMResizingView

-(CGSize)intrinsicContentSize
{
    __block CGRect rect = CGRectZero;
    [self.subviews each:^(UIView *view) {
        rect = CGRectUnion(rect, view.frame);
    }];
    return CGSizeMake(rect.size.width, rect.size.height);
}

@end
