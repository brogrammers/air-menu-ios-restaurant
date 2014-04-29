//
//  AMFormMapCell.m
//  Air Menu
//
//  Created by Robert Lis on 21/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMFormMapCell.h"
#import <CoreLocation/CoreLocation.h>

@interface AMFormMapCell() <MKMapViewDelegate>
@property (nonatomic, readwrite, strong) MKPointAnnotation *annotation;
@end

@implementation AMFormMapCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        MKMapView *mapView = [MKMapView newAutoLayoutView];
        self.mapView = mapView;
        self.mapView.delegate = self;
        [self.contentView addSubview:mapView];
        [mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 20, 0)];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
        longPress.minimumPressDuration = 1.0;
        [self.mapView addGestureRecognizer:longPress];
    }
    return self;
}

+(CGFloat)formDescriptorCellHeightForRowDescription:(XLFormRowDescriptor *)rowDescriptor
{
    return 360.0f;
}

-(void)didLongPress:(UILongPressGestureRecognizer *)recogniser
{
    if (recogniser.state != UIGestureRecognizerStateBegan)
        return;
 
    if(self.annotation)
    {
        [self.mapView removeAnnotation:self.annotation];
        self.annotation = nil;
    }
    
    CGPoint touchPoint = [recogniser locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    MKPointAnnotation *annototation = [[MKPointAnnotation alloc] init];
    annototation.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annototation];
    self.annotation = annototation;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    if(annotation!= mapView.userLocation)
    {
        static NSString *defaultPin = @"pinIdentifier";
        pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPin];
        if(pinView == nil)
        {
            pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPin];
        }
        
        pinView.pinColor = MKPinAnnotationColorPurple; //Optional
        pinView.animatesDrop = YES;
        pinView.draggable = YES;
    }

    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        self.annotation.coordinate = annotationView.annotation.coordinate;
    }
}

-(NSError *)formDescriptorCellLocalValidation
{
    if(self.annotation == nil)
    {
        return [[NSError alloc] initWithDomain:XLFormErrorDomain code:XLFormErrorCodeRequired userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"location must be specified", nil), self.rowDescriptor.title] }];
    }
    else
    {
        return nil;
    }
}

-(void)setAnnotation:(MKPointAnnotation *)annotation
{
    _annotation = annotation;
    if(!annotation)
    {
        self.rowDescriptor.value = nil;
    }
    else
    {
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        self.rowDescriptor.value = location;
    }
}

-(void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    [super setRowDescriptor:rowDescriptor];
    MKPointAnnotation *annototation = [[MKPointAnnotation alloc] init];
    annototation.coordinate = [[rowDescriptor value] coordinate] ;
    [self.mapView addAnnotation:annototation];
    self.annotation = annototation;
}
@end
