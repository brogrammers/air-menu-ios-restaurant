//
//  AMHeaderAddTableHeaderView.h
//  Air Menu
//
//  Created by Robert Lis on 11/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FRDLivelyButton/FRDLivelyButton.h>


@protocol AMAddTableHeaderViewDelegate;

@interface AMAddTableHeaderView : UITableViewHeaderFooterView
@property (nonatomic, readonly, weak) UILabel *label;
@property (nonatomic, readonly, weak) FRDLivelyButton *button;
@property (nonatomic, readwrite) NSUInteger sectionIndex;
@property (nonatomic, readwrite, weak) id <AMAddTableHeaderViewDelegate> delegate;
@end

@protocol AMAddTableHeaderViewDelegate <NSObject>
-(void)sectionAtIndex:(NSUInteger)index didPressButton:(FRDLivelyButton *)button;
@end
