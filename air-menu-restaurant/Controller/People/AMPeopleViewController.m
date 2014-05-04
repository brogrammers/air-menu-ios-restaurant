//
//  AMPeopleViewController.m
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPeopleViewController.h"
#import "AMCollectionView.h"
#import "AMHeaderCellWithAdd.h"
#import "UILabel+AttributesCopy.h"
#import "AMReorderableLayout.h"
#import "AMFormViewController.h"
#import <MZFormSheetController/MZFormSheetController.h>
#import "AMBackgroundDecorationView.h"
#import "AMStaffKindCell.h"
#import "AMStaffMemberCell.h"
#import "AMDataSource.h"
#import "UICollectionView+AMCollectionViewAdapter.h"
#import "AMPeopleCollectionViewAdapter.h"

@interface AMPeopleViewController () <UICollectionViewDelegate, LXReorderableCollectionViewDataSource>
@property (nonatomic, readwrite, weak) AMCollectionView *collectionView;
@property (nonatomic, readwrite, strong) AMDataSource *source;
@property (nonatomic, readwrite, strong) AMFormViewController *formViewController;
@end

@implementation AMPeopleViewController

-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user restaurant:(AMRestaurant *)restaurant
{
    self = [super initWithScopes:scopes user:user restaurant:restaurant];
    if(self)
    {
        [self setup];
        [self.source refresh];
    }
    return self;
}

-(void)setup
{
    [self setupCollectionView];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)setupCollectionView
{
    AMCollectionView *collectionView = [AMCollectionView collectionViewWithLayoutClass:[AMReorderableLayout class]];
    collectionView.refreshBlock = ^{
        [self.source refresh];
    };
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    self.collectionView.identifierToCellClass = @{@"member_cell" : [AMStaffMemberCell class]};
    self.collectionView.identifierToHeaderClass = @{@"staff_kind_header" : [AMStaffKindCell class]};
    self.collectionView.identifierToFooterClass = @{@"staff_kind_footer" : [UICollectionReusableView class]};
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.collectionView.collectionViewLayout registerClass:[AMBackgroundDecorationView class] forDecorationViewOfKind:@"background"];
    self.collectionView.delegate = self;
    
    AMHeaderCellWithAdd *header = [[AMHeaderCellWithAdd alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [header.titleLabel setTextWithExistingAttributes:@"Staff Kinds"];
    header.tapBlock = ^{
        [self showInputForNewStaffKind];
    };
    self.collectionView.refreshBlock = ^{
        [self.collectionView didEndRefreshing];
    };
    self.collectionView.headerView = header;
    self.collectionView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
}

-(void)setRestaurant:(AMRestaurant *)restaurant
{
    [super setRestaurant:restaurant];
    if(restaurant)
    {
        AMPeopleCollectionViewAdapter *adapter = [AMPeopleCollectionViewAdapter new];
        adapter.headerBlock = ^(UICollectionReusableView *header, NSIndexPath *indexPath){
            AMStaffKindCell *staffKindCell = (AMStaffKindCell *) header;
            staffKindCell.addAction = ^{[self showInputForNewStaffMemberOfStaffKind:[self.source.data objectAtIndex:indexPath.item]];};
        };
        AMDataSource *source = [AMDataSource withBlock:^(Done block) {
            [[AMClient sharedClient] findStaffKindsOfRestaurant:restaurant
                                                     completion:^(NSArray *staffKinds, NSError *error) {
                                                        block(staffKinds);
                                                     }];
        } destination:self.collectionView adapter:adapter];
        self.source = source;
    }
}

#pragma mark - Collection View Delegate Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 70);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 160);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(320, 20);
}

#pragma mark - Collection View Reoardable Flow Layout Data Source

-(void)showInputForNewStaffMemberOfStaffKind:(AMStaffKind *)staffKind
{
    AMFormViewController *controller = [AMFormViewController createStaffMemberViewController];
    self.formViewController = controller;
    [controller setAction:^{
        [self createStaffMemberFromInputOfStaffKind:staffKind];
    } forTitle:@"create"];
    controller.tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    MZFormSheetController *transitionController = [[MZFormSheetController alloc] initWithSize:CGSizeMake(self.view.bounds.size.width - 10, self.view.bounds.size.height)
                                                                               viewController:controller];
    [transitionController setTransitionStyle:MZFormSheetTransitionStyleDropDown];
    transitionController.didTapOnBackgroundViewCompletionHandler = ^(CGPoint point){
        [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    [self mz_presentFormSheetController:transitionController animated:YES completionHandler:nil];
}

-(void)showInputForNewStaffKind
{
    AMFormViewController *controller = [AMFormViewController staffKindCreateViewController];
    self.formViewController = controller;
    [controller setAction:^{
        [self createStaffKindFromInput];
    } forTitle:@"create"];
    MZFormSheetController *transitionController = [[MZFormSheetController alloc] initWithSize:CGSizeMake(self.view.bounds.size.width - 10, self.view.bounds.size.height * 0.75)
                                                                               viewController:controller];
    [transitionController setTransitionStyle:MZFormSheetTransitionStyleDropDown];
    transitionController.didTapOnBackgroundViewCompletionHandler = ^(CGPoint point){
        [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    [self mz_presentFormSheetController:transitionController animated:YES completionHandler:nil];
}

-(void)createStaffMemberFromInputOfStaffKind:(AMStaffKind *)staffKind
{
    if (self.restaurant.identifier && staffKind.identifier)
    {
        XLFormDescriptor *form = self.formViewController.form;
        [[AMClient sharedClient] createStaffMemberOfResstaurant:self.restaurant
                                                       withName:[[form formRowWithTag:@"name"] value]
                                                       username:[[form formRowWithTag:@"username"] value]
                                                       password:[[form formRowWithTag:@"password"] value]
                                                          email:[[form formRowWithTag:@"email"] value]
                                                      staffKind:staffKind.identifier.stringValue
                                                     completion:^(AMStaffMember *staffMember, NSError *error) {
                                                         [self.source refresh];
                                                     }];
    }
    [self dismissForm];
}

-(void)createStaffKindFromInput
{
    
    if(self.restaurant)
    {
        XLFormDescriptor *form = self.formViewController.form;
        [[AMClient sharedClient] createStaffKindOfRestaurant:self.restaurant
                                                    withName:[[form formRowWithTag:@"name"] value]
                                                acceptOrders:[[[form formRowWithTag:@"handles orders ?"] value] boolValue]
                                           acceptsOrderItems:[[[form formRowWithTag:@"handles items ?"] value] boolValue]
                                                  completion:^(AMStaffKind *staffKind, NSError *error) {
                                                      [self.source refresh];
                                                  }];
    }
    [self dismissForm];
}

-(void)dismissForm
{
    [self.formSheetController mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    self.formViewController = nil;
}

@end
