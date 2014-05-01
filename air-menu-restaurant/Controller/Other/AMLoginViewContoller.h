//
//  AMLoginViewContoller.h
//  air-menu-restaurant
//
//  Created by Robert Lis on 07/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMLoginViewControllerDelegate <NSObject>
-(void)didRequestLoginWithUsernane:(NSString *)username password:(NSString *)password;
-(void)didRequestRegistrationWithUsernane:(NSString *)username passsword:(NSString *)password email:(NSString *)email;
@end

@interface AMLoginViewContoller : UIViewController
@property (nonatomic, readwrite, weak) id <AMLoginViewControllerDelegate> delegate;
@end
