//
//  AMAppDelegate.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 28/11/2013.
//  Copyright (c) 2013 Air-menu. All rights reserved.
//

#import "AMAppDelegate.h"
#import "AMTwinViewController.h"
#import "AMRestaurantViewController.h"
@implementation AMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AMTwinViewController *controller = (AMTwinViewController *) self.window.rootViewController;
    [controller setViewController:[[AMRestaurantViewController alloc] init] inPosition:AMTwinViewControllerPositionFirst];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[self backgroundImage]];
    self.window.backgroundColor = background;
    return YES;
}

-(UIImage *)backgroundImage
{
    CGSize size = self.window.bounds.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBackgroundImageInContext:context withSize:size];
    UIImage *background =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return background;
}

-(void)drawBackgroundImageInContext:(CGContextRef)context withSize:(CGSize)size
{
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[2] = { 0.0, 1.0 };

    NSArray *colors = @[(id)[UIColor colorWithRed:129/255.0f green:152/255.0f blue:168/255.0f alpha:1.0].CGColor,
                        (id)[UIColor colorWithRed:203/255.0f green:177/255.0f blue:153/255.0f alpha:1.0].CGColor];
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    CGPoint startPoint, endPoint;
    startPoint.x = 0.0;
    startPoint.y = 0.0;
    endPoint.x = size.width;
    endPoint.y = size.height;
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}

@end
