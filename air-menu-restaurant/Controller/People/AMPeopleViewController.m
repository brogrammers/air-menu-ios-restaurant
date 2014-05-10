//
//  AMPeopleViewController.m
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPeopleViewController.h"

@interface AMPeopleViewController () <UICollectionViewDelegate>
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
   //    [self.source refresh];
    }
    return self;
}

-(void)setup
{
    [self setupCollectionView];
    [self configureCollectionviewLayout];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)setupCollectionView
{
    AMCollectionView *collectionView = [AMCollectionView collectionViewWithLayoutClass:[AMReorderableLayout class]];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.collectionView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0);
    self.collectionView.identifierToCellClass = @{@"member_cell" : [AMStaffMemberCell class]};
    self.collectionView.identifierToHeaderClass = @{@"staff_kind_header" : [AMStaffKindCell class]};
    self.collectionView.identifierToFooterClass = @{@"staff_kind_footer" : [UICollectionReusableView class]};
    self.collectionView.refreshBlock = ^{ [self.source refresh]; };
    self.collectionView.delegate = self;
    AMHeaderCellWithAdd *header = [[AMHeaderCellWithAdd alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    [header.titleLabel setTextWithExistingAttributes:@"Staff Kinds"];
    header.tapBlock = ^{ [self showInputForNewStaffKind]; };
    self.collectionView.headerView = header;
}

-(void)configureCollectionviewLayout
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [self.collectionView.collectionViewLayout registerClass:[AMBackgroundDecorationView class] forDecorationViewOfKind:@"background"];
    flowLayout.itemSize = CGSizeMake(320, 70);
    flowLayout.headerReferenceSize = CGSizeMake(320, 160);
    flowLayout.footerReferenceSize = CGSizeMake(320, 20);
}

-(void)setRestaurant:(AMRestaurant *)restaurant
{
    [super setRestaurant:restaurant];
    if(restaurant)
    {
        AMDataSource *source = [AMDataSource withBlock:^(Done block) {
            [[AMClient sharedClient] findStaffKindsOfRestaurant:restaurant
                                                     completion:^(NSArray *staffKinds, NSError *error) {
                                                         [self.collectionView didEndRefreshing];
                                                         if(error)
                                                         {
                                                            [CRToastManager showErrorWithMessage:[error localizedDescription]];
                                                            return;
                                                         }
                                                         block(staffKinds);
                                                     }];
        } destination:self.collectionView adapter:[self createAdapter]];
        self.source = source;
    }
}

-(AMPeopleCollectionViewAdapter *)createAdapter
{
    AMPeopleCollectionViewAdapter *adapter = [AMPeopleCollectionViewAdapter new];
    adapter.headerBlock = ^(UICollectionReusableView *header, NSIndexPath *indexPath){
        AMStaffKindCell *staffKindCell = (AMStaffKindCell *) header;
        staffKindCell.addAction = ^{[self showInputForNewStaffMemberOfStaffKind:[self.source.data objectAtIndex:indexPath.item]];};
        staffKindCell.leftImage = [UIImage drawText:@"" inImageWithSize:CGSizeMake(35, 35) atPoint:CGPointZero withFont:[UIFont fontWithName:ICON_FONT size:35.0f]];
        staffKindCell.rightImage = [UIImage drawText:@"" inImageWithSize:CGSizeMake(30, 30) atPoint:CGPointZero withFont:[UIFont fontWithName:ICON_FONT size:30.0f]];
    };
    adapter.cellBlock = ^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
        
    };
    return adapter;
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
