//
//  AMRestaurantCreatorInputView.m
//  Air Menu
//
//  Created by Robert Lis on 15/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMRestaurantCreatorInputView.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMInputField.h"
#import <MapKit/MapKit.h>
#import "AMButton.h"
#import "UILabel+AttributesCopy.h"
#import "AMLineSpacer.h"

@interface AMRestaurantCreatorInputView() <UITextFieldDelegate>
@property (nonatomic, readwrite, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite, weak) AMInputField *about;
@property (nonatomic, readwrite, weak) AMInputField *address;
@property (nonatomic, readwrite, weak) MKMapView *mapView;
@property (nonatomic, readwrite, weak) UILabel *title;
@property (nonatomic, readwrite, weak) UILabel *locationHeader;
@end

@implementation AMRestaurantCreatorInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    UIScrollView *scrollView = [UIScrollView newAutoLayoutView];
    self.scrollView = scrollView;
    [self addSubview:self.scrollView];
    [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self setupTitle];
    [self setupAboutInput];
    [self setupAddressInput];
    [self setupLocationInputHeader];
    [self setupLocationInput];
    [self setupButton];
}

-(void)setupTitle
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.title = label;
    [self.scrollView addSubview:label];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.scrollView withOffset:20];
    [label autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20];
    [label autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-20];
    label.attributes = @{NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:25],
                                   NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSKernAttributeName : @1.0};
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextWithExistingAttributes:@"New Restaurant"];
}

-(void)setupAboutInput
{
    AMInputField *inputField = [AMInputField newAutoLayoutView];
    self.about = inputField;
    [self.scrollView addSubview:inputField];
    [inputField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.title withOffset:60];
    [inputField autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20];
    [inputField autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-20];
    inputField.title = @"About";
    inputField.fields = @{@"name" : @"name",
                          @"kind" : @"kind",
                          @"description" : @"description"};
}

-(void)setupLocationInputHeader
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.locationHeader = label;
    label.text = @"Location";
    label.font = [UIFont fontWithName:GOTHAM_LIGHT size:24];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.address withOffset:60];
    [label autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20];
    [label autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-20];
    
    AMLineSpacer *spacer = [AMLineSpacer newAutoLayoutView];
    [self addSubview:spacer];
    [spacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20];
    [spacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:20];
    [spacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:10.0];
    [spacer autoSetDimension:ALDimensionHeight toSize:1.0];
    spacer.shouldFade = NO;
}

-(void)setupAddressInput
{
    AMInputField *inputField = [AMInputField newAutoLayoutView];
    self.address = inputField;
    [self.scrollView addSubview:inputField];
    [inputField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.about withOffset:60];
    [inputField autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20];
    [inputField autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-20];

    inputField.title = @"Address";
    inputField.fields = @{@"address_1" : @"address line 1",
                          @"address_2" : @"address line 2",
                          @"city" : @"city",
                          @"country" : @"country",
                          @"state" : @"state"};
}

-(void)setupButton
{
    AMButton *button = [AMButton button];
    button.tintColor = [UIColor whiteColor];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"create" forState:UIControlStateNormal];
    [self.scrollView addSubview:button];
    [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mapView withOffset:40];
    [button autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [button autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.scrollView withOffset:-40];
}

-(void)setupLocationInput
{
    MKMapView *mapView = [MKMapView newAutoLayoutView];
    self.mapView = mapView;
    [self.scrollView addSubview:mapView];
    [mapView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.locationHeader withOffset:60];
    [mapView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20];
    [mapView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-20];
    [mapView autoSetDimension:ALDimensionHeight toSize:400];
    mapView.layer.cornerRadius = 15.0;
}
@end
