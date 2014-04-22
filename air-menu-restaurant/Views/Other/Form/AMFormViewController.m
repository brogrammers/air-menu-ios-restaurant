//
//  AMFormViewController.m
//  Air Menu
//
//  Created by Robert Lis on 21/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMFormViewController.h"
#import "AMLineSpacer.h"
#import "AMFormTextFieldCell.h"
#import "UILabel+AttributesCopy.h"
#import "AMFormMapCell.h"
#import "AMButton.h"

@interface AMFormViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) FormAction action;
@property (nonatomic, readwrite, strong) NSMutableSet *seenCells;
@end

@implementation AMFormViewController

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    label.text = title;
    label.attributes = @{NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:26],
                         NSForegroundColorAttributeName : [UIColor whiteColor],
                         NSKernAttributeName : @1.0};
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    [label setTextWithExistingAttributes:title];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    
    UILabel *label = [UILabel newAutoLayoutView];
    label.text = [self tableView:self.tableView titleForHeaderInSection:section];
    label.font = [UIFont fontWithName:GOTHAM_LIGHT size:24];
    label.textColor = [UIColor whiteColor];
    [container addSubview:label];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:container withOffset:20.0];
    [label autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:container withOffset:20.0];
    [label autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:container withOffset:0.0];
    
    AMLineSpacer *spacer = [AMLineSpacer newAutoLayoutView];
    [container addSubview:spacer];
    [spacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:10.0];
    [spacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:container withOffset:20.0];
    [spacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:container withOffset:0];
    [spacer autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:container];
    [spacer autoSetDimension:ALDimensionHeight toSize:1.0];
    spacer.shouldFade = NO;
    return container;
}

-(id)initWithForm:(XLFormDescriptor *)form
         formMode:(XLFormMode)mode
 showCancelButton:(BOOL)showCancelButton
   showSaveButton:(BOOL)showSaveButton
 showDeleteButton:(BOOL)showDeleteButton
deleteButtonCaption:(NSString *)deleteButtonCaption
       tableStyle:(UITableViewStyle)style
{
    self = [super initWithForm:form
                      formMode:mode
              showCancelButton:showCancelButton
                showSaveButton:showSaveButton
              showDeleteButton:showDeleteButton
           deleteButtonCaption:deleteButtonCaption
                    tableStyle:style];
    if (self)
    {
        self.cellClassesForRowDescriptorTypes = [@{XLFormRowDescriptorTypeText:[AMFormTextFieldCell class],
                                                   XLFormRowDescriptorTypeName: [AMFormTextFieldCell class],
                                                   XLFormRowDescriptorTypePhone:[AMFormTextFieldCell class],
                                                   XLFormRowDescriptorTypeURL:[AMFormTextFieldCell class],
                                                   XLFormRowDescriptorTypeEmail: [AMFormTextFieldCell class],
                                                   XLFormRowDescriptorTypeTwitter: [AMFormTextFieldCell class],
                                                   XLFormRowDescriptorTypeAccount: [AMFormTextFieldCell class],
                                                   XLFormRowDescriptorTypePassword: [AMFormTextFieldCell class],
                                                   XLFormRowDescriptorTypeNumber: [AMFormTextFieldCell class],
                                                   XLFormRowDescriptorTypeInteger: [AMFormTextFieldCell class],
                                                   @"AMFormRowDescriptorTypeMap" : [AMFormMapCell class]
                                                   } mutableCopy];
        self.tableView.separatorColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.seenCells = [NSMutableSet set];
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 40, 0);
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if(![self.seenCells containsObject:indexPath])
    {
        cell.contentView.transform = CGAffineTransformMakeTranslation(320 + (arc4random() % 320), 0);
        cell.alpha = 0.0;
        
        [UIView animateWithDuration:0.5
                              delay:0.1
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.contentView.transform = CGAffineTransformIdentity;
                         }
                         completion:nil];
        
        [UIView animateWithDuration:0.4
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.alpha = 1.0;
                         } completion:nil];
        [self.seenCells addObject:indexPath];
    }
}

-(void)setAction:(FormAction)action forTitle:(NSString *)title
{
    AMButton *button = [AMButton button];
    [button setTitle:title forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    [container addSubview:button];
    [button autoCenterInSuperview];
    self.action = action;
    self.tableView.tableFooterView = container;
    [button addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)didTap:(UIButton *)button
{
    NSArray *errors = [self formValidationErrors];
    if(errors.count > 0)
    {
        NSError *error = [errors firstObject];
        [self showFormValidationError:error];
    }
    
    if(errors.count == 0 && self.action)
    {
        self.action();
    }
}

-(void)showFormValidationError:(NSError *)error
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"There is a problem" message:error.localizedDescription delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

+(AMFormViewController *)restaurantInputViewController
{
    XLFormDescriptor *restaurantForm = [XLFormDescriptor formDescriptorWithTitle:@"New Restaurant"];
    
    XLFormSectionDescriptor *aboutSection = [XLFormSectionDescriptor formSectionWithTitle:@"About"];
    [@[@"description", @"name", @"kind"] each:^(NSString *title) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeText title:title];
        row.required = YES;
        [aboutSection addFormRow:row];
    }];
    
    XLFormSectionDescriptor *addressSection = [XLFormSectionDescriptor formSectionWithTitle:@"Address"];
    [@[@"address line 1", @"address line 2", @"city", @"county", @"state", @"country"] each:^(NSString *title) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeText title:title];
        row.required = YES;
        [addressSection addFormRow:row];
    }];

    XLFormSectionDescriptor *locationSection = [XLFormSectionDescriptor formSectionWithTitle:@"Location"];
    XLFormRowDescriptor *locationRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"map" rowType:@"AMFormRowDescriptorTypeMap" title:@"map"];
    [locationSection addFormRow:locationRow];
    

    [restaurantForm addFormSection:aboutSection];
    [restaurantForm addFormSection:addressSection];
    [restaurantForm addFormSection:locationSection];
    
    AMFormViewController *controller = [[AMFormViewController alloc] initWithForm:restaurantForm
                                                                         formMode:XLFormModeCreate
                                                                 showCancelButton:YES
                                                                   showSaveButton:YES
                                                                 showDeleteButton:NO
                                                              deleteButtonCaption:@"remove"
                                                                       tableStyle:UITableViewStyleGrouped];
    return controller;
}

@end
