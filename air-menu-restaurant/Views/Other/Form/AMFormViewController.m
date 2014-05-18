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
#import "AMFormSwitchCell.h"
#import "AMSecureTextFieldCell.h"
#import <MZFormSheetController/MZFormSheetController.h>
#import "AMDecimalFieldCell.h"

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
                                                   XLFormRowDescriptorTypeNumber: [AMDecimalFieldCell class],
                                                   XLFormRowDescriptorTypeInteger: [AMFormTextFieldCell class],
                                                   @"AMFormRowDescriptorTypeMap" : [AMFormMapCell class],
                                                   XLFormRowDescriptorTypeBooleanCheck : [AMFormSwitchCell class],
                                                   XLFormRowDescriptorTypePassword : [AMSecureTextFieldCell class],
                                                   } mutableCopy];
        self.tableView.separatorColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.seenCells = [NSMutableSet set];
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground:)]];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView setContentOffset:CGPointMake(0, -40)];
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 40, 0);
}

-(void)didTapBackground:(UIGestureRecognizer *)recgoniser
{
    if(recgoniser.state == UIGestureRecognizerStateEnded)
    {
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    }
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
    [@[@"description", @"name", @"category"] each:^(NSString *title) {
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

+(AMFormViewController *)restaurantUpdateViewController:(AMRestaurant *)restaurant
{
    AMFormViewController *controller = [self restaurantInputViewController];
    XLFormDescriptor *form = controller.form;
    [controller setTitle:@"Update Restaurant"];
    [[form formRowWithTag:@"name"] setValue:restaurant.name];
    [[form formRowWithTag:@"category"] setValue:restaurant.category];
    [[form formRowWithTag:@"address line 1"] setValue:restaurant.address.addressLine1];
    [[form formRowWithTag:@"address line 2"] setValue:restaurant.address.addressLine2];
    [[form formRowWithTag:@"city"] setValue:restaurant.address.city];
    [[form formRowWithTag:@"county"] setValue:restaurant.address.country];
    [[form formRowWithTag:@"state"] setValue:@"N/A"];
    [[form formRowWithTag:@"country"] setValue:restaurant.address.country];
    [[form formRowWithTag:@"description"] setValue:@"Great food every day!"];
    [[form formRowWithTag:@"map"] setValue:restaurant.location];
    return controller;
}

+(AMFormViewController *)staffKindCreateViewController
{
    XLFormDescriptor *staffKindForm = [XLFormDescriptor formDescriptorWithTitle:@"New staff kind"];
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:@"About staff kind"];
    XLFormSectionDescriptor *staffKindPrivlidges = [XLFormSectionDescriptor formSectionWithTitle:@"Privlidges"];

    [@[@"name", @"handles orders ?", @"handles items ?"] each:^(NSString *title) {
        XLFormRowDescriptor *row;
        if ([title characterAtIndex:title.length - 1] == '?')
        {
            row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeBooleanCheck title:title];
        }
        else
        {
            row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeText title:title];
        }
        
        row.required = YES;
        [section addFormRow:row];
    }];
    
    [[AMOAuthToken scopesStrings] each:^(id scope) {
        NSString *scopeName = [scope stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:scope rowType:XLFormRowDescriptorTypeBooleanCheck title:scopeName];
        [staffKindPrivlidges addFormRow:row];
    }];
    
    [staffKindForm addFormSection:section];
    [staffKindForm addFormSection:staffKindPrivlidges];
    AMFormViewController *controller = [[AMFormViewController alloc] initWithForm:staffKindForm
                                                                         formMode:XLFormModeCreate
                                                                 showCancelButton:YES
                                                                   showSaveButton:YES
                                                                 showDeleteButton:NO
                                                              deleteButtonCaption:@""
                                                                       tableStyle:UITableViewStyleGrouped];
    return controller;
}

+(AMFormViewController *)loginViewController
{
    XLFormDescriptor *loginForm = [XLFormDescriptor formDescriptorWithTitle:@""];
    XLFormSectionDescriptor *loginSection = [XLFormSectionDescriptor formSectionWithTitle:@"Your details"];
    [@[@"username", @"password"] each:^(NSString *title) {
        XLFormRowDescriptor *row;
        if([title isEqualToString:@"password"])
        {
            row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypePassword title:title];
        }
        else
        {
            row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeText title:title];
        }
        
        row.required = YES;
        [loginSection addFormRow:row];
    }];
    
    [loginForm addFormSection:loginSection];
    AMFormViewController *controller = [[AMFormViewController alloc] initWithForm:loginForm
                                                                         formMode:XLFormModeCreate
                                                                 showCancelButton:YES
                                                                   showSaveButton:YES
                                                                 showDeleteButton:NO
                                                              deleteButtonCaption:@""
                                                                       tableStyle:UITableViewStyleGrouped];
    return controller;
}

+(AMFormViewController *)createStaffMemberViewController
{
    XLFormDescriptor *staffMemberSectionForm = [XLFormDescriptor formDescriptorWithTitle:@"New staff member"];
    XLFormSectionDescriptor *staffMemberSection = [XLFormSectionDescriptor formSectionWithTitle:@"About staff member"];
    [@[@"name", @"username", @"email", @"password"] each:^(NSString *title) {
        XLFormRowDescriptor *row;
        if ([title isEqualToString:@"password"])
        {
            row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypePassword title:title];
        }
        else
        {
            row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeText title:title];
        }
        
        row.required = YES;
        [staffMemberSection addFormRow:row];
    }];
    
    XLFormSectionDescriptor *staffMemberPrivlidges = [XLFormSectionDescriptor formSectionWithTitle:@"Privlidges"];
    
    
    [[AMOAuthToken scopesStrings] each:^(id scope) {
        NSString *scopeName = [scope stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:scope rowType:XLFormRowDescriptorTypeBooleanCheck title:scopeName];
        [staffMemberPrivlidges addFormRow:row];
    }];
    
    
    [staffMemberSectionForm addFormSection:staffMemberSection];
    [staffMemberSectionForm addFormSection:staffMemberPrivlidges];
    AMFormViewController *controller = [[AMFormViewController alloc] initWithForm:staffMemberSectionForm
                                                                         formMode:XLFormModeCreate
                                                                 showCancelButton:YES
                                                                   showSaveButton:YES
                                                                 showDeleteButton:NO
                                                              deleteButtonCaption:@""
                                                                       tableStyle:UITableViewStyleGrouped];
    return controller;
}

+(AMFormViewController *)createMenuViewController
{
    XLFormDescriptor *menuFormDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"New Menu"];
    XLFormSectionDescriptor *menuSection = [XLFormSectionDescriptor formSectionWithTitle:@"About menu"];
    [@{@"name" : XLFormRowDescriptorTypeText, @"active" : XLFormRowDescriptorTypeBooleanCheck} each:^(NSString *name, NSString *type) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:name rowType:type title:name];
        row.required = YES;
        [menuSection addFormRow:row];
    }];
    
    [menuFormDescriptor addFormSection:menuSection];
    AMFormViewController *controller = [[AMFormViewController alloc] initWithForm:menuFormDescriptor
                                                                         formMode:XLFormModeCreate
                                                                 showCancelButton:YES
                                                                   showSaveButton:YES
                                                                 showDeleteButton:NO
                                                              deleteButtonCaption:@""
                                                                       tableStyle:UITableViewStyleGrouped];
    return controller;
}

+(AMFormViewController *)updateMenuViewController:(AMMenu *)menu
{
    XLFormDescriptor *menuFormDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Update Menu"];
    XLFormSectionDescriptor *menuSection = [XLFormSectionDescriptor formSectionWithTitle:@"About menu"];
    [@{@"name" : XLFormRowDescriptorTypeText, @"active" : XLFormRowDescriptorTypeBooleanCheck} each:^(NSString *name, NSString *type) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:name rowType:type title:name];
        row.required = YES;
        [menuSection addFormRow:row];
    }];
    
    [menuFormDescriptor addFormSection:menuSection];
    AMFormViewController *controller = [[AMFormViewController alloc] initWithForm:menuFormDescriptor
                                                                         formMode:XLFormModeCreate
                                                                 showCancelButton:YES
                                                                   showSaveButton:YES
                                                                 showDeleteButton:NO
                                                              deleteButtonCaption:@""
                                                                       tableStyle:UITableViewStyleGrouped];
    [[menuFormDescriptor formRowWithTag:@"name"] setValue:menu.name];
    [[menuFormDescriptor formRowWithTag:@"active"] setValue:menu.isActive];
    return controller;
}

+(AMFormViewController *)createSectionViewController
{
    XLFormDescriptor *sectionFormDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"New Menu Section"];
    XLFormSectionDescriptor *menuSectionSection = [XLFormSectionDescriptor formSectionWithTitle:@"About menu section"];
    [@[@"name",@"description"] each:^(NSString *name) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:name rowType:XLFormRowDescriptorTypeText title:name];
        row.required = YES;
        [menuSectionSection addFormRow:row];
    }];
    
    [sectionFormDescriptor addFormSection:menuSectionSection];
    AMFormViewController *controller = [[AMFormViewController alloc] initWithForm:sectionFormDescriptor
                                                                         formMode:XLFormModeCreate
                                                                 showCancelButton:YES
                                                                   showSaveButton:YES
                                                                 showDeleteButton:NO
                                                              deleteButtonCaption:@""
                                                                       tableStyle:UITableViewStyleGrouped];
    return controller;
}

+(AMFormViewController *)updateSectionViewController:(AMMenuSection *)section
{
    XLFormDescriptor *sectionFormDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Update Menu Section"];
    XLFormSectionDescriptor *menuSectionSection = [XLFormSectionDescriptor formSectionWithTitle:@"About menu section"];
    [@[@"name",@"description"] each:^(NSString *name) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:name rowType:XLFormRowDescriptorTypeText title:name];
        row.required = YES;
        [menuSectionSection addFormRow:row];
    }];
    
    [sectionFormDescriptor addFormSection:menuSectionSection];
    AMFormViewController *controller = [[AMFormViewController alloc] initWithForm:sectionFormDescriptor
                                                                         formMode:XLFormModeCreate
                                                                 showCancelButton:YES
                                                                   showSaveButton:YES
                                                                 showDeleteButton:NO
                                                              deleteButtonCaption:@""
                                                                       tableStyle:UITableViewStyleGrouped];
    [[sectionFormDescriptor formRowWithTag:@"name"] setValue:section.name];
    [[sectionFormDescriptor formRowWithTag:@"description"] setValue:section.details];
    return controller;
}

+(AMFormViewController *)createMenuItemViewController
{
    XLFormDescriptor *itemFormDecriptor =  [XLFormDescriptor formDescriptorWithTitle:@"New Menu Item"];
    XLFormSectionDescriptor *itemFormSection = [XLFormSectionDescriptor formSectionWithTitle:@"About item"];
    [@[@"name", @"description", @"currency"] each:^(NSString *name) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:name rowType:XLFormRowDescriptorTypeText title:name];
        row.required = YES;
        [itemFormSection addFormRow:row];
    }];

    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:@"price" rowType:XLFormRowDescriptorTypeNumber title:@"price"];
    row.required = YES;
    [itemFormSection addFormRow:row];
    [itemFormDecriptor addFormSection:itemFormSection];
    AMFormViewController *controller = [[AMFormViewController alloc] initWithForm:itemFormDecriptor
                                                                         formMode:XLFormModeEdit
                                                                 showCancelButton:NO
                                                                   showSaveButton:NO
                                                                 showDeleteButton:NO
                                                              deleteButtonCaption:@""
                                                                       tableStyle:UITableViewStyleGrouped];
    return controller;
}

+(AMFormViewController *)updateMenuItemViewController:(AMMenuItem *)item
{
    XLFormDescriptor *itemFormDecriptor =  [XLFormDescriptor formDescriptorWithTitle:@"Update Menu Item"];
    XLFormSectionDescriptor *itemFormSection = [XLFormSectionDescriptor formSectionWithTitle:@"About item"];
    [@[@"name", @"description", @"currency"] each:^(NSString *name) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:name rowType:XLFormRowDescriptorTypeText title:name];
        row.required = YES;
        [itemFormSection addFormRow:row];
    }];
    
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:@"price" rowType:XLFormRowDescriptorTypeNumber title:@"price"];
    row.required = YES;
    [itemFormSection addFormRow:row];
    [itemFormDecriptor addFormSection:itemFormSection];
    AMFormViewController *controller = [[AMFormViewController alloc] initWithForm:itemFormDecriptor
                                                                         formMode:XLFormModeEdit
                                                                 showCancelButton:NO
                                                                   showSaveButton:NO
                                                                 showDeleteButton:NO
                                                              deleteButtonCaption:@""
                                                                       tableStyle:UITableViewStyleGrouped];
    [[itemFormDecriptor formRowWithTag:@"name"] setValue:item.name];
    [[itemFormDecriptor formRowWithTag:@"description"] setValue:item.details];
    [[itemFormDecriptor formRowWithTag:@"currency"] setValue:item.currency];
    [[itemFormDecriptor formRowWithTag:@"price"] setValue:item.price];
    
    return controller;
}
@end
