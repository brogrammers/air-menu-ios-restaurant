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
#import "AMBackgroundDecorationView.h"
#import "AMStaffKindCell.h"
#import "AMStaffMemberCell.h"

@interface AMReorderableLayout : LXReorderableCollectionViewFlowLayout
@end

@implementation AMReorderableLayout

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableArray *decorationAttributesToAdd = [NSMutableArray array];
    NSMutableSet *sectionsDecorated = [NSMutableSet set];
    [layoutAttributes each:^(UICollectionViewLayoutAttributes *attribute) {
        if(![sectionsDecorated containsObject:@(attribute.indexPath.section)])
        {
            [decorationAttributesToAdd addObject:[self layoutAttributesForDecorationViewOfKind:@"background" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:attribute.indexPath.section]]];
            [sectionsDecorated addObject:@(attribute.indexPath.section)];
        }
    }];
    
    [layoutAttributes addObjectsFromArray:decorationAttributesToAdd];
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:indexPath.section];
    __block CGRect decorationViewFrame = CGRectZero;
    [@(0) upto:(int)numberOfItems - 1 do:^(NSInteger cellNumber) {
        UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:cellNumber inSection:indexPath.section]];
        CGRect cellFrame = cellAttributes.frame;
        if(CGRectEqualToRect(decorationViewFrame, CGRectZero))
        {
            decorationViewFrame = cellFrame;
        }
        else
        {
            decorationViewFrame = CGRectUnion(cellFrame, decorationViewFrame);
        }
    }];

    attributes.frame = decorationViewFrame;
    if(CGRectEqualToRect(attributes.frame, CGRectZero))
    {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        CGRect attrFrame = attr.frame;
        attrFrame.origin.y = attrFrame.size.height;
        attrFrame.size.height = 0;
        attributes.frame = attrFrame;
    }
    
    attributes.zIndex = -1000;
    return attributes;
}
@end


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
    UICollectionViewFlowLayout *layout = [[AMReorderableLayout alloc] init];
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
    [self.collectionView registerClass:[AMStaffMemberCell class] forCellWithReuseIdentifier:@"a_cell"];
    [self.collectionView registerClass:[AMStaffKindCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"staff_kind_cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer_view"];
    [layout registerClass:[AMBackgroundDecorationView class] forDecorationViewOfKind:@"background"];
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
    AMStaffMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"a_cell" forIndexPath:indexPath];
    //  NSArray *staffMembers = self.staffKindsToStaffMembers[self.staffKinds[indexPath.section]];
    //    AMStaffMember *staffMember = staffMembers[indexPath.item];
    [cell.memberName setTextWithExistingAttributes:@"Becky Murphy"];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionHeader)
    {
        AMStaffKindCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"staff_kind_cell" forIndexPath:indexPath];
      //  AMStaffKind *staffKind = self.staffKinds[indexPath.row];
        [cell.staffKindLabel setTextWithExistingAttributes:@"WAITRESSES"];
        [cell setAcceptsItems:YES];
        [cell setAcceptsOrders:NO];
        [cell setNumberOfMembers:5];
        cell.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        cell.addAction = ^{
            [self createStaffMember];
        };
        return cell;
    }
    else
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer_view" forIndexPath:indexPath];
        return view;
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
    return CGSizeMake(320, 70);
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

-(void)createStaffMember
{
    AMFormViewController *controller = [AMFormViewController createStaffMemberViewController];
    __weak AMFormViewController *weakController;
    [controller setAction:^{
        [self createStaffKindFromInput:(weakController)];
    } forTitle:@"create"];
    controller.tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:35.0];
    MZFormSheetController *transitionController = [[MZFormSheetController alloc] initWithSize:CGSizeMake(self.view.bounds.size.width - 10, self.view.bounds.size.height) viewController:controller];
    [transitionController setTransitionStyle:MZFormSheetTransitionStyleDropDown];
    transitionController.didTapOnBackgroundViewCompletionHandler = ^(CGPoint point){
        [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    [self mz_presentFormSheetController:transitionController animated:YES completionHandler:nil];
}

-(void)showInputForNewStaffKind
{
    AMFormViewController *controller = [AMFormViewController staffKindCreateViewController];
    __weak AMFormViewController *weakController;
    [controller setAction:^{
        [self createStaffKindFromInput:(weakController)];
    } forTitle:@"create"];
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:35.0];
    MZFormSheetController *transitionController = [[MZFormSheetController alloc] initWithSize:CGSizeMake(self.view.bounds.size.width - 10, self.view.bounds.size.height * 0.75) viewController:controller];
    [transitionController setTransitionStyle:MZFormSheetTransitionStyleDropDown];
    transitionController.didTapOnBackgroundViewCompletionHandler = ^(CGPoint point){
        [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    };
    [self mz_presentFormSheetController:transitionController animated:YES completionHandler:nil];
}

-(void)createStaffKindFromInput:(AMFormViewController *)viewController
{
    [viewController mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    return;
    [[AMClient sharedClient] createStaffKindOfRestaurant:self.restaurant
                                                withName:@""
                                            acceptOrders:YES
                                       acceptsOrderItems:YES
                                              completion:^(AMStaffKind *staffKind, NSError *error) {
                                                  
                                              }];

}

@end
