//
//  AMFormMapCell.h
//  Air Menu
//
//  Created by Robert Lis on 21/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "XLFormBaseCell.h"
#import <MapKit/MapKit.h>

@interface AMFormMapCell : XLFormBaseCell
@property (nonatomic, readwrite, weak) MKMapView *mapView;
@property (nonatomic, readonly, strong) MKPointAnnotation *annotation;
@end
