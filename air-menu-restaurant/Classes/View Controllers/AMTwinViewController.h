//
//  AMTwinViewController.h
//  air-menu-restaurant
//
//  Created by Robert Lis on 26/02/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AMTwinViewControllerPosition) {
    AMTwinViewControllerPositionFirst,
    AMTwinViewControllerPositionSecond
};

typedef void (^Completion)();
typedef void (^Animation)();

@interface AMTwinViewController : UIViewController
-(void)setViewController:(UIViewController *)controller inPosition:(AMTwinViewControllerPosition)position;
-(void)expandFirstViewControllerWithAnimationBlock:(Animation)animation completion:(Completion)completion;
-(void)shrinkFirstViewControllerWithAnimationBlock:(Animation)animation completion:(Completion)completion;
@end
