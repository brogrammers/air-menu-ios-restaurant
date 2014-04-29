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
#import "LXReorderableCollectionViewFlowLayout.h"
#import "AMFormViewController.h"
#import <MZFormSheetController/MZFormSheetController.h>

@interface AMPeopleViewController () <UICollectionViewDelegate, UICollectionViewDataSource, LXReorderableCollectionViewDataSource>
@property (nonatomic, readwrite, weak) AMCollectionView *collectionView;
@property (nonatomic, readwrite, strong) NSArray *staffKinds;
@property (nonatomic, readwrite, strong) NSDictionary *staffKindsToStaffMembers;
@end

@implementation AMPeopleViewController

-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user restaurant:(AMRestaurant *)restaurant
{
    self = [super initWithScopes:scopes user:user restaurant:restaurant];
    if(self)
    {
        [self setup];
        [self fetchData];
    }
    return self;
}

-(void)setup
{
    UICollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    AMCollectionView *collectionView = [[AMCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.refreshBlock = ^{
        [self fetchData];
    };
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.bounces = YES;
    [self.collectionView reloadData];
    [self.collectionView registerClass:[AMHeaderCellWithAdd class] forCellWithReuseIdentifier:@"a_cell"];
    AMHeaderCellWithAdd *header = [[AMHeaderCellWithAdd alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 25)];
    [header.titleLabel setTextWithExistingAttributes:@"Staff Kinds"];
    header.tapBlock = ^{
        [self createStaffKind];
    };
    self.collectionView.headerView = header;
}

-(void)fetchData
{
    AMStaffKind *staffKind1 = [[AMStaffKind alloc] initWithDictionary:@{@"identifier" : @1, @"name" : @"a staff kind"} error:nil];
    AMStaffKind *staffKind2 = [[AMStaffKind alloc] initWithDictionary:@{@"identifier" : @2, @"name" : @"a staff kind"} error:nil];
    AMStaffKind *staffKind3 = [[AMStaffKind alloc] initWithDictionary:@{@"identifier" : @3, @"name" : @"a staff kind"} error:nil];

    AMStaffMember *member  = [[AMStaffMember alloc] initWithDictionary:@{@"name" : @"Robert Lis"} error:nil];
    
    self.staffKinds = @[staffKind1, staffKind2, staffKind3];
    self.staffKindsToStaffMembers = @{staffKind1 : [@[member] mutableCopy],
                                      staffKind2 : [@[member] mutableCopy],
                                      staffKind3 : [@[member] mutableCopy]};
}

#pragma mark - Collection View Data Source


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.staffKinds.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    NSArray *staffMembers = self.staffKindsToStaffMembers[self.staffKinds[section]];
    return staffMembers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMHeaderCellWithAdd *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"a_cell" forIndexPath:indexPath];
    [cell.titleLabel setTextWithExistingAttributes:[NSString stringWithFormat:@"section: %d item: %d", indexPath.section, indexPath.item]];
    cell.backgroundColor = [UIColor redColor] ;
    return cell;
}

#pragma mark - Collection View Delegate Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width - 200, 70);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width - 200, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - Collection View Reoardable Flow Layout Data Source

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    AMStaffKind *fromStaffKind = self.staffKinds[fromIndexPath.section];
    AMStaffKind *toStaffKind = self.staffKinds[toIndexPath.section];
    NSMutableArray *fromStaffMembers = self.staffKindsToStaffMembers[fromStaffKind];
    NSMutableArray *toStaffMembers = self.staffKindsToStaffMembers[toStaffKind];
    AMStaffMember *member = fromStaffMembers[fromIndexPath.item];
    [fromStaffMembers removeObjectAtIndex:fromIndexPath.item];
    [toStaffMembers insertObject:member atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}

-(void)createStaffKind
{
    AMFormViewController *controller = [AMFormViewController staffKindCreateViewController];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:50.0];
    MZFormSheetController *transitionController = [[MZFormSheetController alloc] initWithViewController:controller];
    [transitionController setTransitionStyle:MZFormSheetTransitionStyleDropDown];
    transitionController.didTapOnBackgroundViewCompletionHandler = ^(CGPoint point){
        [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    [self mz_presentFormSheetController:transitionController animated:YES completionHandler:nil];

//    [[AMClient sharedClient] createStaffKindOfRestaurant:self.restaurant
//                                                withName:@""
//                                            acceptOrders:YES
//                                       acceptsOrderItems:YES
//                                              completion:^(AMStaffKind *staffKind, NSError *error) {
//                                                  
//                                              }];
}

@end
