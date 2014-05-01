//
//  AMLoginViewContoller.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 07/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMLoginViewContoller.h"
#import "AMButton.h"
#import "AMFormViewController.h"
#import "AMAppDelegate.h"

@interface AMLoginViewContoller()
@property (nonatomic, readwrite, weak) AMFormViewController *controller;
@property (nonatomic, readwrite) BOOL isShowingEmailRow;
@property (nonatomic, readwrite, weak) UIImageView *logo;
@property (nonatomic, readwrite, weak) AMButton *loginButton;
@property (nonatomic, readwrite, weak) AMButton *registerButton;
@property (nonatomic, readwrite, weak) NSLayoutConstraint *formHeightContraint;
@end

@implementation AMLoginViewContoller

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self setupLogo];
    [self setupLoginButton];
    [self setupRegisterButton];
    [self setupForm];
}

-(void)setupLoginButton
{
    AMButton *button = [AMButton button];
    self.loginButton = button;
    [button addTarget:self action:@selector(didPressLogin:) forControlEvents:UIControlEventTouchUpInside];
    button.fontSize = 15.0f;
    [button setTitle:@"login" forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:button];
    [button autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:20.0f];
    [button autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-20.0f];
}

-(void)setupRegisterButton
{
    AMButton *button = [AMButton button];
    self.registerButton = button;
    [button addTarget:self action:@selector(didPressRegister:) forControlEvents:UIControlEventTouchUpInside];
    button.fontSize = 15.0f;
    [button setTitle:@"register" forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:button];
    [button autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:-20.0f];
    [button autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-20.0f];
}

-(void)setupForm
{
    AMFormViewController *loginViewController = [AMFormViewController loginViewController];
    self.controller = loginViewController;
    self.controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.controller];
    [self.view addSubview:self.controller.view];
    [self.controller.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.logo withOffset:-55.0f];
    [self.controller.view autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    self.formHeightContraint = [self.controller.view autoSetDimension:ALDimensionHeight toSize:self.controller.tableView.contentSize.height + 60];
    [self.controller.view autoSetDimension:ALDimensionWidth toSize:320];
    [self.controller didMoveToParentViewController:self];
}

-(void)setupLogo
{
    UIImageView *logo = [UIImageView newAutoLayoutView];
    self.logo = logo;
    self.logo.image = [UIImage imageNamed:@"air_menu_logo.png"];
    [self.view addSubview:self.logo];
    [self.logo autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:40.0f];
    [self.logo autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [self.logo autoSetDimensionsToSize:CGSizeMake(150, 150)];
    self.logo.contentMode = UIViewContentModeScaleAspectFill;
    [self.logo.layer setMinificationFilter:kCAFilterTrilinear];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.layer.contents = (id)[self backgroundImage].CGImage;
    [self animateApperiance];
}

-(void)animateApperiance
{
    CGPoint currentCenter = self.logo.layer.position;
    self.logo.layer.position = self.view.center;
    self.loginButton.alpha = 0.0;
    self.registerButton.alpha = 0.0;
    self.controller.view.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                          self.logo.layer.position = currentCenter;
                         self.loginButton.alpha = 1.0;
                         self.registerButton.alpha = 1.0;
                         self.controller.view.alpha = 1.0;
                     }
                     completion:nil];
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

-(void)didPressLogin:(UIButton *)button
{
    if([self isInputValid])
    {
        XLFormDescriptor *form = self.controller.form;
        [self.delegate didRequestLoginWithUsernane:[[form formRowWithTag:@"username"] value]
                                          password:[[form formRowWithTag:@"password"] value]];
    }
}

-(void)didPressRegister:(UIButton *)button
{
    if(!self.isShowingEmailRow)
    {
        XLFormRowDescriptor *emailRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"email address"
                                                                              rowType:XLFormRowDescriptorTypeText
                                                                                title:@"email address"];
        emailRow.required = YES;
        [self.controller.form addFormRow:emailRow afterRowTag:@"username"];
        self.isShowingEmailRow = YES;
        return;
    }
    
    if([self isInputValid])
    {
        XLFormDescriptor *form = self.controller.form;
        [self.delegate didRequestRegistrationWithUsernane:[[form formRowWithTag:@"username"] value]
                                                passsword:[[form formRowWithTag:@"password"] value]
                                                     email:[[form formRowWithTag:@"email"] value]];
    }
}

-(BOOL)isInputValid
{
    NSArray *errors = [self.controller formValidationErrors];
    if(errors.count > 0)
    {
        NSError *error = [errors firstObject];
        [self.controller showFormValidationError:error];
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
