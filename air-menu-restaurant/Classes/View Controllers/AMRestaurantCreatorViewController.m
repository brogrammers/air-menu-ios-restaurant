//
//  AMRestaurantCreatorViewController.m
//  Air Menu
//
//  Created by Robert Lis on 12/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMRestaurantCreatorViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMFormView.h"

@interface AMRestaurantCreatorViewController ()
@property (nonatomic, readwrite, weak) UILabel *titleLabel;
@property (nonatomic, readwrite, weak) UIButton *button;
@property (nonatomic, readwrite, weak) AMFormView *formView;
@property (nonatomic, readwrite, strong) AMFormViewRowColumn *name;
@property (nonatomic, readwrite, strong) AMFormViewRowColumn *addressLine1;
@property (nonatomic, readwrite, strong) AMFormViewRowColumn *addressLine2;
@property (nonatomic, readwrite, strong) AMFormViewRowColumn *city;
@property (nonatomic, readwrite, strong) AMFormViewRowColumn *county;
@property (nonatomic, readwrite, strong) AMFormViewRowColumn *country;
@end

@implementation AMRestaurantCreatorViewController

-(instancetype)init
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
    [self createLabel];
    [self createButton];
    [self setupFormView];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)setupFormView
{
    AMFormView *formView = [AMFormView newAutoLayoutView];
    self.formView = formView;
    [self.view addSubview:self.formView];
    [self.formView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:20];
    [self.formView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.button withOffset:-20];
    [self.formView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view withOffset:35];
    [self.formView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view withOffset:-35];
    
    AMInputValidator *validator = [AMBlockInputValidator withBlock:^BOOL(NSString *input) {
        return input != nil;
    } next:nil];
    
    self.name = [AMFormViewRowColumn withName:@"name" validator:validator];
    self.addressLine1 = [AMFormViewRowColumn withName:@"address line one" validator:validator];
    self.addressLine2= [AMFormViewRowColumn withName:@"address line two" validator:validator];
    self.city = [AMFormViewRowColumn withName:@"city" validator:validator];
    self.county = [AMFormViewRowColumn withName:@"county" validator:validator];
    self.country = [AMFormViewRowColumn withName:@"country" validator:validator];
    AMFormViewSection *section = [AMFormViewSection withName:nil rows:@[[AMFormViewRow withColumns:@[self.name]],
                                                                        [AMFormViewRow withColumns:@[self.addressLine1]],
                                                                        [AMFormViewRow withColumns:@[self.addressLine2]],
                                                                        [AMFormViewRow withColumns:@[self.city]],
                                                                        [AMFormViewRow withColumns:@[self.county]],
                                                                        [AMFormViewRow withColumns:@[self.country]]]];
    [self.formView setSections:@[section]];
}

-(void)createLabel
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.titleLabel = label;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:20.0f];
    [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.titleLabel.text = @"create new restaurant";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:GOTHAM_LIGHT size:15];
}

-(void)createButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button = button;
    [self.view addSubview:self.button];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-20.0f];
    [self.button autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.button setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self.button setTitle:@"CREATE" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(didPressCreate:) forControlEvents:UIControlEventTouchUpInside];
    self.button.titleLabel.font = [UIFont fontWithName:MENSCH_THIN size:30];
    self.button.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.button.layer.shadowOpacity = 1.0;
    self.button.layer.shadowRadius = 1.0;
    self.button.layer.shadowOffset = CGSizeMake(0.0f,1.0f);
}

-(void)didPressCreate:(UIButton *)button
{
    if([self inputIsValid])
    {
        [[AMClient sharedClient] createRestaurantOfCompany:self.company
                                                  withName:self.name.userInput
                                                   loyalty:NO
                                               remoteOrder:NO
                                            conversionRate:@(0.0)
                                            addressLineOne:self.addressLine1.userInput
                                            addressLineTwo:self.addressLine2.userInput
                                                      city:self.city.userInput
                                                    county:self.county.userInput
                                                     state:@""
                                                   country:self.country.userInput
                                                completion:^(AMRestaurant *restaurant, NSError *error) {
                                                    if(!error)
                                                    {
                                                        [self.delegate restaurantCreatorViewController:self didCreateRestaurant:restaurant];
                                                    }
                                                    else
                                                    {
                                                        NSLog(@"Error %@", error);
                                                    }
                                                }];
    }
}

-(BOOL)inputIsValid
{
    return YES;
}

@end
