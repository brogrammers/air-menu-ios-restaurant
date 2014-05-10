//
//  MZFormSheetController+AMTransitionStyle.m
//  Air Menu
//
//  Created by Robert Lis on 06/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "MZFormSheetController+AMTransitionStyle.h"

@implementation MZFormSheetController (AMTransitionStyle)
+(MZFormSheetController *)withSize:(CGSize)size controller:(UIViewController *)controller
{
    MZFormSheetController *transitionController = [[MZFormSheetController alloc] initWithSize:size
                                                                               viewController:controller];
    transitionController.portraitTopInset = 0;
    [transitionController setTransitionStyle:MZFormSheetTransitionStyleDropDown];
    transitionController.didTapOnBackgroundViewCompletionHandler = ^(CGPoint point){
        [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    
    return transitionController;
}
@end
