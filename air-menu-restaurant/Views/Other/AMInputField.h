//
//  AMInputField.h
//  Air Menu
//
//  Created by Robert Lis on 15/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMResizingView.h"

@interface AMInputField : AMResizingView
@property (nonatomic, readwrite, strong) NSDictionary *fields;
@property (nonatomic, readwrite, strong) NSString *title;
@end
