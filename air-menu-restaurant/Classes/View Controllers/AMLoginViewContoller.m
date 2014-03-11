//
//  AMLoginViewContoller.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 07/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import <AirMenuKit/AMClient+User.h>
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import "AMLoginViewContoller.h"
#import "AMFormView.h"
#import "AMInputValidator.h"
#import "AMAppDelegate.h"

@interface AMLoginViewContoller()
@property (nonatomic, readwrite, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite, weak) UIView *firstPage;
@property (nonatomic, readwrite, weak) UIView *secondpage;
@property (nonatomic, readwrite, weak) UIView *pageSeparator;
@property (nonatomic, readwrite, weak) UIView *buttonSeparator;
@property (nonatomic, readwrite, weak) AMFormView *formView;
@property (nonatomic, readwrite, weak) UIImageView *logoImageView;
@property (nonatomic, readwrite, weak) UIButton *loginButton;
@property (nonatomic, readwrite, weak) UIButton *signupButton;
@property (nonatomic, readwrite, weak) UILabel *messageLabel;
@property (nonatomic, readwrite, strong) AMFormViewRowColumn *username;
@property (nonatomic, readwrite, strong) AMFormViewRowColumn *password;
@end

@implementation AMLoginViewContoller

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideEverything];
    self.logoImageView.alpha = 1.0;
}

-(void)hideEverything
{
    self.firstPage.alpha = 0.0;
    self.secondpage.alpha = 0.0;
    self.pageSeparator.alpha = 0.0;
}

-(void)revealEverything
{
    self.firstPage.alpha = 1.0;
    self.secondpage.alpha = 1.0;
    self.pageSeparator.alpha = 1.0;
    self.logoImageView.alpha = 0.8;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        self.logoImageView.layer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        self.logoImageView.layer.bounds = CGRectMake(0, 0, 300.0f, 300.0f);
    }
    else
    {
        self.logoImageView.layer.position = CGPointMake(CGRectGetMidX(self.firstPage.bounds), CGRectGetMidY(self.firstPage.bounds));
        self.logoImageView.layer.bounds = CGRectMake(0, 0, 150.0f, 150.0f);
    }
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self revealEverything];
                         
                         if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
                         {
                             [self.view setNeedsLayout];
                             [self.view layoutIfNeeded];
                         }
                         else
                         {
                             [self.firstPage setNeedsLayout];
                             [self.firstPage layoutIfNeeded];
                         }
                     }
                     completion:nil];
}

-(void)setup
{
    self.view.backgroundColor = [UIColor clearColor];
    [self createScrollView];
    [self createFirstPage];
    [self createSecondPage];
    [@[self.firstPage, self.secondpage] autoDistributeViewsAlongAxis:ALAxisHorizontal withFixedSpacing:0 alignment:NSLayoutFormatAlignAllBottom];
    [self createLoginForm];
    [self createLoginButton];
    [self createSignupButton];
    [self createButtonSeparator];
    [self createPageSeparator];
    [self createLogoImageView];
    [self createMessageLabel];
    [self.scrollView setNeedsLayout];
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    scrollViewContentSize.height = self.scrollView.bounds.size.height;
}

-(void)createScrollView
{
    UIScrollView *scrollView = [UIScrollView newAutoLayoutView];
    self.scrollView = scrollView;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView autoCenterInSuperview];
    [self.scrollView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [self.scrollView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self.scrollView autoSetDimension:ALDimensionHeight toSize:320.0f];
    }
    else
    {
        [self.scrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
        [self.scrollView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    }

}

-(void)createFirstPage
{
    UIView *firstPage = [UIView newAutoLayoutView];
    self.firstPage = firstPage;
    [self.scrollView addSubview:self.firstPage];
    [self.firstPage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.scrollView withOffset:0];
    [self.firstPage autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.scrollView withOffset:0];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self.firstPage autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:0.5];
    }
    else
    {
        [self.firstPage autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:1];
    }
    
    [self.firstPage autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView withMultiplier:1];
}

-(void)createSecondPage
{
    UIView *secondPage = [UIView newAutoLayoutView];
    self.secondpage = secondPage;
    [self.scrollView addSubview:self.secondpage];
    [self.secondpage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.scrollView withOffset:0];
    [self.secondpage autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.scrollView withOffset:0];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self.secondpage autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:0.5];
    }
    else
    {
        [self.secondpage autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:1];
    }
    
    [self.firstPage autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView withMultiplier:1];
}


-(void)createLoginForm
{    
    AMFormView *formView = [AMFormView newAutoLayoutView];
    self.formView = formView;
    [self.firstPage addSubview:self.formView];
    
    AMInputValidator *validator = [AMBlockInputValidator withBlock:^BOOL(NSString *input) {
        return input != nil;
    } next:[AMBlockInputValidator withBlock:^BOOL(NSString *input) {
        return input.length > 2;
    } next:[AMBlockInputValidator withBlock:^BOOL(NSString *input) {
        return input.length < 25;
    } next:nil]]];
    
    self.username = [AMFormViewRowColumn withName:@"username" validator:validator];
    self.password = [AMFormViewRowColumn withName:@"password" validator:validator];
    AMFormViewRow *row1 = [AMFormViewRow withColumns:@[self.username]];
    AMFormViewRow *row2 = [AMFormViewRow withColumns:@[self.password]];
    AMFormViewSection *section = [AMFormViewSection withRows:@[row1, row2]];
    [self.formView setSections:@[section]];
    
    
    [self.formView autoCenterInSuperview];
    [self.formView autoSetDimension:ALDimensionHeight toSize:60*2];
    [self.formView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.firstPage withOffset:35];
    [self.formView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.firstPage withOffset:-35];
}

-(void)createLogoImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"air_menu_logo.png"]];
    self.logoImageView = imageView;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self.view addSubview:self.logoImageView];
    }
    else
    {
        [self.firstPage addSubview:self.logoImageView];
    }
    self.logoImageView.alpha = 0.8;
    [self.logoImageView.layer setMinificationFilter:kCAFilterTrilinear];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.logoImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.logoImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:40];
    [self.logoImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.formView withOffset:-40];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self.logoImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.logoImageView withMultiplier:0.5];
    }
    else
    {
        [self.logoImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.logoImageView withMultiplier:1.0];
    }
}

-(void)createLoginButton
{
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton = loginButton;
    [self.firstPage addSubview:self.loginButton];
    [self.loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.loginButton.titleLabel.font = [UIFont fontWithName:MENSCH_THIN size:30];
    [self.loginButton setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"login" forState:UIControlStateNormal];
    [self.loginButton setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [@[self.loginButton, self.formView] autoAlignViewsToEdge:ALEdgeLeading];
    [self.loginButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.firstPage withOffset:-35];
    [self.loginButton addTarget:self action:@selector(didPressLogin:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75].CGColor;
    self.loginButton.layer.shadowOpacity = 1.0;
    self.loginButton.layer.shadowRadius = 2;
    self.loginButton.layer.shadowOffset = CGSizeMake(0.0f,2.0f);
}

-(void)createSignupButton
{
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.signupButton = loginButton;
    [self.signupButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.firstPage addSubview:self.signupButton];
    self.signupButton.titleLabel.font = [UIFont fontWithName:MENSCH_THIN size:30];
    [self.signupButton setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.signupButton setTitle:@"signup" forState:UIControlStateNormal];
    [self.signupButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.firstPage withOffset:-35];
    [@[self.signupButton, self.formView] autoAlignViewsToEdge:ALEdgeTrailing];
    [self.signupButton addTarget:self action:@selector(didPressSignup:) forControlEvents:UIControlEventTouchUpInside];
    self.signupButton.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75].CGColor;
    self.signupButton.layer.shadowOpacity = 1.0;
    self.signupButton.layer.shadowRadius = 2;
    self.signupButton.layer.shadowOffset = CGSizeMake(0.0f,2.0f);
}

-(void)createButtonSeparator
{
    UIView *separator = [UIView newAutoLayoutView];
    self.buttonSeparator = separator;
    [self.firstPage addSubview:self.buttonSeparator];
    self.buttonSeparator.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.buttonSeparator autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.loginButton];
    [self.buttonSeparator autoSetDimension:ALDimensionWidth toSize:1.0f];
    [self.buttonSeparator autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.buttonSeparator autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.firstPage withOffset:-35];
}

-(void)createPageSeparator
{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        UIView *pageSeparator = [UIView newAutoLayoutView];
        self.pageSeparator = pageSeparator;
        [self.view addSubview:self.pageSeparator];
        self.pageSeparator.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [self.pageSeparator autoSetDimension:ALDimensionWidth toSize:1.0f];
        [self.pageSeparator autoCenterInSuperview];
        [self.pageSeparator autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView];
    }
}

-(void)createMessageLabel
{
    UILabel *messageLabel = [UILabel newAutoLayoutView];
    self.messageLabel = messageLabel;
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.text = @"Please log in or sign up";
    UIView *container = [UIView newAutoLayoutView];
    container.backgroundColor = [UIColor clearColor];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self.view addSubview:container];
        [container autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scrollView];
        [container autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
        [container autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
        [container autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
        [container addSubview:messageLabel];
        self.messageLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:25];
        [self.messageLabel autoCenterInSuperview];
    }
    else
    {

        [self.firstPage addSubview:container];
        [container autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.formView];
        [container autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.firstPage];
        [container autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.firstPage];
        [container autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.buttonSeparator];
        self.messageLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:15];
        [container addSubview:messageLabel];
        [self.messageLabel autoCenterInSuperview];
        
    }
}

-(void)didPressSignup:(UIButton *)button
{
    if([self isInputValid])
    {
        
    }
    
    AMAppDelegate *delegate = (AMAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.self didLogin];
}

-(void)didPressLogin:(UIButton *)button
{
    if([self isInputValid])
    {
        [[AMClient sharedClient] authenticateWithClientID:@"1ea6342ac153d74ac305e04f949da93bad3eab7401d9160206e65288bfabee64"
                                             clientSecret:@"541b2f36d19a717077195286212aa1e1cea63faea4cfa22963475512704a2684"
                                                 username:self.username.userInput
                                                 password:self.password.userInput
                                                   scopes:AMOAuthScopeUser
                                               completion:^(AMOAuthToken *token, NSError *error) {
                                                   if(!error)
                                                   {
                                                       AMAppDelegate *delegate = (AMAppDelegate *)[UIApplication sharedApplication].delegate;
                                                       [delegate.self didLogin];
                                                   }
                                                   else
                                                   {
                                                       NSLog(@"Error %@", error);
                                                   }
                                               }];
    }
}

-(BOOL)isInputValid
{
    BOOL isValid = YES;
    
    if(![self.password isValid])
    {
        [self.password showError];
        isValid = NO;
    }
    
    if(![self.username isValid])
    {
        [self.username showError];
        isValid = NO;
    }
    
    return isValid;
}

@end
