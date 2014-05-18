//
//  UITableViewController+AMPickerViewController.m
//  Air Menu C
//
//  Created by Robert Lis on 13/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPickerViewController.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "UILabel+AttributesCopy.h"
@interface AMPickerCell : UITableViewCell
@property (nonatomic, readwrite, weak) UILabel *rowTextLabel;
@property (nonatomic, readwrite, weak) UILabel *rowIconLabel;
@end

@implementation AMPickerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self setupRowIconLabel];
    [self setupRowTextLabel];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
}

-(void)setupRowTextLabel
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.rowTextLabel = label;
    [self.contentView addSubview:self.rowTextLabel];
    [self.rowTextLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.rowTextLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:60.0f];
    [self.rowTextLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    self.rowTextLabel.attributes = @{ NSFontAttributeName : [UIFont fontWithName:GOTHAM_LIGHT size:20.0f],
                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                      NSKernAttributeName : @1.0};
    self.rowTextLabel.textAlignment = NSTextAlignmentLeft;
}

-(void)setupRowIconLabel
{
    UILabel *label = [UILabel newAutoLayoutView];
    self.rowIconLabel = label;
    [self.contentView addSubview:self.rowIconLabel];
    [self.rowIconLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.rowIconLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    self.rowIconLabel.font = [UIFont fontWithName:ICON_FONT size:25.0f];
    self.rowIconLabel.textColor = [UIColor colorWithRed:30.0/255.0f green:209.0/255.0f blue:241.0/255.0f alpha:1.0];
    [self.rowIconLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

@end

#define ROW_HEIGHT 80.0f

@interface AMPickerViewController() <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, readwrite, strong) NSDictionary *managedViewControllersClasses;
@property (nonatomic, readwrite, weak) UITableView *tableView;
@end

@implementation AMPickerViewController

-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user
{
    self = [super initWithScopes:scopes user:user];
    if(self)
    {
        UITableView *table = [[UITableView alloc] init];
        self.tableView = table;
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.tableView];
        [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[AMPickerCell class] forCellReuseIdentifier:@"row_cell"];
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        if(self.displayHeader)
        {
            UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
            container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.text = @"Airmenu";
            label.font = [UIFont fontWithName:IDLEWILD_BOOK size:30];
            label.center = CGPointMake(320 / 2, CGRectGetMidY(container.bounds));
            [container addSubview:label];
            [label sizeToFit];
            self.tableView.tableHeaderView = container;
        }
    }
    return self;
}

-(void)setControllers:(NSArray *)controllers
{
    _controllers = controllers;
    [self.tableView reloadData];
}

-(void)setController:(MSDynamicsDrawerViewController *)controller
{
    _controller = controller;
    if(self.controllers > 0)
    {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.names.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"row_cell"];
    [cell.rowTextLabel setTextWithExistingAttributes:self.names[indexPath.row]];
    cell.rowIconLabel.text = self.icons[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = self.controllers[indexPath.row];
    if(viewController != self.controller.paneViewController)
    {
        if(self.controller.paneState == MSDynamicsDrawerPaneStateOpen)
        {
            [self.controller setPaneViewController:viewController animated:YES completion:nil];
        }
        else
        {
            [self.controller setPaneViewController:viewController animated:NO completion:nil];
        }
    }
    else
    {
        [self.controller setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:nil];
    }
}

@end
