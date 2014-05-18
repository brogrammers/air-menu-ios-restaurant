//
//  UIImage+TextDrawing.h
//  Air Menu
//
//  Created by Robert Lis on 22/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TextDrawing)
+(UIImage*) drawText:(NSString*)text inImageWithSize:(CGSize)size atPoint:(CGPoint)point withFont:(UIFont *)font;
@end
