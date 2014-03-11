//
//  AMCompanyViewController.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 06/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMCompanyViewController.h"
#import "AMRestaurantCell.h"
#import "AMActionCell.h"
#import "AMAddTableHeaderView.h"

@interface AMCompanyViewController() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak, readwrite) UITableView *tableView;
@end

@implementation AMCompanyViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createTableView];
}

-(void)createTableView
{
    UITableView *tableView = [UITableView newAutoLayoutView];
    self.tableView = tableView;
    [self.tableView registerClass:[AMRestaurantCell class] forCellReuseIdentifier:@"restaurant_cell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMRestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restaurant_cell" forIndexPath:indexPath];
    [cell setActions:@[@"Edit", @"Delete"]
           withFonts:@[[UIFont fontWithName:GOTHAM_BOOK size:20], [UIFont fontWithName:GOTHAM_BOOK size:20]]
           andColors:@[[UIColor colorWithRed:119.0f/255.0f green:207.0f/255.0f blue:71.0f/255.0f alpha:1.0], [UIColor colorWithRed:208.0f/255.0f green:2.0f/255.0f blue:27.0f/255.0f alpha:1.0]]];
    cell.restaurantNameLabel.text = @"A Restaurant Name";
    return cell;;
}

#pragma mark - Table View delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Restaurants";
    label.font = [UIFont fontWithName:GOTHAM_BOOK size:25];
    label.textColor = [UIColor whiteColor];
    return label;
}


@end
