//
//  CRToastManager+AMNotification.m
//  Air Menu
//
//  Created by Robert Lis on 22/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "CRToastManager+AMNotification.h"
#import "UIImage+TextDrawing.h"

@implementation CRToastManager (AMNotification)
+(void)showErrorWithMessage:(NSString *)message
{
    NSDictionary *options = @{kCRToastTextKey : @"There is a problem.",
                              kCRToastSubtitleTextKey : [message stringByAppendingString:@".."],
                              kCRToastFontKey : [UIFont fontWithName:GOTHAM_BOOK size:18],
                              kCRToastSubtitleFontKey : [UIFont fontWithName:GOTHAM_BOOK_ITALIC size:13],
                              kCRToastImageKey : [UIImage drawText:@"" inImageWithSize:CGSizeMake(30, 30) atPoint:CGPointMake(0, 0) withFont:[UIFont fontWithName:ICON_FONT size:30]],
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastSubtitleTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastBackgroundColorKey : [UIColor colorWithRed:232.0f/255.0f green:25.0f/255.0f blue:70.0f/255.0f alpha:1.0],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop)};
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:nil];
}

@end
