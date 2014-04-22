//
//  UIImage+TextDrawing.m
//  Air Menu
//
//  Created by Robert Lis on 22/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "UIImage+TextDrawing.h"

@implementation UIImage (TextDrawing)
+(UIImage*) drawText:(NSString*)text inImageWithSize:(CGSize)size atPoint:(CGPoint)point withFont:(UIFont *)font
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGRect rect = CGRectMake(point.x, point.y, size.width, size.height);
    [[UIColor whiteColor] set];
    NSDictionary *att = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName : [UIColor whiteColor]};
    [text drawInRect:rect withAttributes:att];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
