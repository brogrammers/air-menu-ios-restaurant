//
//  AMMeViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 17/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMeViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import <AirMenuKit/AMClient+User.h>
#import "AMDescribedLabel.h"
#import "AMUserView.h"
#import "AMDotSpacer.h"
#import <FlatPillButton/FlatPillButton.h>
#import "AMLineSpacer.h"
#import "AMButton.h"
#import "AMAppDelegate.h"
#import "AMFormViewController.h"

@interface AMMeViewController ()
@property (nonatomic, readwrite, weak) AMUserView *userView;
@property (nonatomic, readwrite, weak) AMDescribedLabel *usernameLabel;
@property (nonatomic, readwrite, weak) AMDescribedLabel *emailLabel;
@property (nonatomic, readwrite, weak) AMDescribedLabel *phoneLabel;
@property (nonatomic, readwrite, weak) AMDotSpacer *topSpacer;
@property (nonatomic, readwrite, weak) AMDotSpacer *bottomSpacer;
@property (nonatomic, readwrite, weak) AMButton *logoutButton;
@property (nonatomic, readwrite, strong) AMUser *currentUser;
@end

@implementation AMMeViewController

#pragma mark - Lifecycle

-(id)initWithUser:(AMUser *)user
{
    self = [super init];
    if(self)
    {
        [self setup];
        self.currentUser = user;
    }
    return self;
}

#pragma mark - Setup
-(void)setup
{
    [self createUserView];
    [self createTopSpacer];
    [self createUsernameLabel];
    [self createEmailLabel];
    [self createPhoneLabel];
    [self createLogoutButton];
    [self createBottomSpacer];
    [self createBackground];
    [self createUpdateButton];
    self.view.layer.contents = (id)[self backgroundImage].CGImage;
}

-(void)createUserView
{
    AMUserView *userView = [AMUserView newAutoLayoutView];
    self.userView = userView;
    [self.view addSubview:self.userView];
    [self.userView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:40.0f];
    [self.userView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:0.0];
    [self.userView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:0.0];
    [self.userView autoSetDimension:ALDimensionHeight toSize:95.0f];
    self.userView.nameLabel.text = @"Robert Lis";
    self.userView.typeLabel.text = @"USER";
    self.userView.userPicture.image = [UIImage imageNamed:@"sample_image.jpeg"];
    self.userView.userPicture.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)createTopSpacer
{
    AMDotSpacer *spacer = [AMDotSpacer newAutoLayoutView];
    self.topSpacer = spacer;
    self.topSpacer.alpha = 0;
    [self.view addSubview:self.topSpacer];
    [self.topSpacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userView withOffset:30.0f];
    [self.topSpacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:0];
    [self.topSpacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:0];
    [self.topSpacer autoSetDimension:ALDimensionHeight toSize:1.5f];
}

-(void)createUsernameLabel
{
    AMDescribedLabel *usernameLabel = [AMDescribedLabel newAutoLayoutView];
    self.usernameLabel = usernameLabel;
    [self.view addSubview:self.usernameLabel];
    [self.usernameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topSpacer withOffset:30.0f];
    [self.usernameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:20];
    [self.usernameLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [self.usernameLabel autoSetDimension:ALDimensionHeight toSize:60];
    self.usernameLabel.titleLabel.text = @"username :";
}

-(void)createEmailLabel
{
    AMDescribedLabel *emailLabel = [AMDescribedLabel newAutoLayoutView];
    self.emailLabel = emailLabel;
    [self.view addSubview:self.emailLabel];
    [self.emailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.usernameLabel withOffset:20.0];
    [self.emailLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:20.0];
    [self.emailLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:0];
    [self.emailLabel autoSetDimension:ALDimensionHeight toSize:60];
    self.emailLabel.titleLabel.text = @"email address :";
}

-(void)createPhoneLabel
{
    AMDescribedLabel *phoneLabel = [AMDescribedLabel newAutoLayoutView];
    self.phoneLabel = phoneLabel;
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.emailLabel withOffset:20];
    [self.phoneLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:20];
    [self.phoneLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:0];
    [self.phoneLabel autoSetDimension:ALDimensionHeight toSize:60];
    self.phoneLabel.titleLabel.text = @"phone number :";
    self.phoneLabel.textLabel.text = @"00353 879363860";
}

-(void)createBottomSpacer
{
    AMDotSpacer *spacer = [AMDotSpacer newAutoLayoutView];
    self.bottomSpacer = spacer;
    self.bottomSpacer.alpha = 0;
    [self.view addSubview:self.bottomSpacer];
    [self.bottomSpacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.phoneLabel withOffset:20.0f];
    [self.bottomSpacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:0.0f];
    [self.bottomSpacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:0.0f];
    [self.bottomSpacer autoSetDimension:ALDimensionHeight toSize:1.5f];
}

-(void)createLogoutButton
{
    AMButton *logoutButton = [AMButton button];
    self.logoutButton = logoutButton;
    [self.view addSubview:self.logoutButton];
    self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.logoutButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-20.0f];
    [self.logoutButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:20.0f];
    [self.logoutButton setTitle:@"logout" forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createUpdateButton
{
    AMButton *logoutButton = [AMButton button];
    self.logoutButton = logoutButton;
    [self.view addSubview:self.logoutButton];
    self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.logoutButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-20.0f];
    [self.logoutButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:-20.0f];
    [self.logoutButton setTitle:@"update" forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(didTapUpdate:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createBackground
{
    UIView *view = [UIView newAutoLayoutView];
    [self.view insertSubview:view atIndex:0];
    [view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.topSpacer];
    [view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bottomSpacer];
    [view autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [view autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
}

-(void)setCurrentUser:(AMUser *)currentUser
{
    _currentUser = currentUser;
    [self updateView];
}

-(void)updateView
{
    self.userView.nameLabel.text = self.currentUser.name;
    self.userView.typeLabel.text = (self.currentUser.type == AMUserTypeOwner) ? @"Owner" : @"User";
    self.emailLabel.textLabel.text = self.currentUser.email;
    self.usernameLabel.textLabel.text = self.currentUser.username;
    self.phoneLabel.textLabel.text = self.currentUser.phoneNumber;
}

-(void)didTapUpdate:(AMButton *)button
{
    
}

-(void)didTap:(AMButton *)button
{
    AMAppDelegate *deletage = (AMAppDelegate *) [UIApplication sharedApplication].delegate;
    [deletage logOut];
}

-(UIImage *)backgroundImage
{
    AMAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    CGSize size = delegate.window.bounds.size;
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
    NSArray *colors = @[(id)[UIColor colorWithRed:18/255.0f green:115/255.0f blue:160/255.0f alpha:1.0].CGColor,
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
