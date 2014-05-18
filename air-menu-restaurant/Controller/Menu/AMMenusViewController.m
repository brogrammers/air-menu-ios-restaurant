//
//  AMMenuViewController.m
//  Air Menu
//
//  Created by Robert Lis on 16/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenusViewController.h"
#import "AMMenuViewController.h"
#import <pop/POP.h>
#import "UIImage+TextDrawing.h"
#import "AMAlertView.h"

@interface AMMenusViewController () <UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>
@property (nonatomic, readwrite, weak) AMCollectionView *menusCollectionView;
@property (nonatomic, readwrite, strong) AMFormViewController *form;
@property (nonatomic, readwrite, strong) AMDataSource *source;
@property (nonatomic, readwrite, strong) NSMutableArray *menuViewControllers;
@property (nonatomic, readwrite, strong) NSIndexPath *expandedCell;
@property (nonatomic, readwrite, strong) NSIndexPath *previouslyExpandedCell;
@property (nonatomic, readwrite) CGPoint previousOffset;
@property (nonatomic, readwrite) BOOL isResizing;
@property (nonatomic, readwrite) NSArray *staffKinds;
@end

@implementation AMMenusViewController

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
}

-(void)setupCollectionView
{
    AMCollectionView *menusCollectionView = [AMCollectionView collectionViewWithLayoutClass:[UICollectionViewFlowLayout class]];
    self.menusCollectionView = menusCollectionView;
    [self.view addSubview:self.menusCollectionView];
    [self.menusCollectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.menusCollectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    self.menusCollectionView.identifierToCellClass = @{@"menuCell" : [AMMenuCell class]};
    self.menusCollectionView.identifierToHeaderClass = @{@"headerCell" : [AMHeaderCellWithAdd class]};
    self.menusCollectionView.delegate = self;
    [(UICollectionViewFlowLayout *)self.menusCollectionView.collectionViewLayout setSectionInset:UIEdgeInsetsMake(25, 0, 0, 0)];
    self.menuViewControllers = [NSMutableArray array];
    self.menusCollectionView.refreshBlock = ^{
        [self.source refresh];
    };
}

-(void)setRestaurant:(AMRestaurant *)restaurant
{
    [super setRestaurant:restaurant];
    if(restaurant)
    {
        self.source = [AMDataSource withBlock:^(Done block) {
            [[AMClient sharedClient] findMenusOfRestaurant:restaurant
                                                completion:^(NSArray *menus, NSError *error) {
                                                    if(error)
                                                    {
                                                        [CRToastManager showErrorWithMessage:[error localizedDescription]];
                                                        return;
                                                    }
                                                    
                                                    [self setupMenuViewControllersForMenus:menus];
                                                    [self.menusCollectionView didEndRefreshing];
                                                    block(menus);
                                                }];
        } destination:self.menusCollectionView adapter:[self createAdapter]];
    }
}

-(AMCollectionViewAdapter *)createAdapter
{
    AMCollectionViewAdapter *adapter = [AMCollectionViewAdapter new];
    
    adapter.headerBlock = ^(UICollectionReusableView *heaeder, NSIndexPath *indexPath) {
        AMHeaderCellWithAdd *header = (AMHeaderCellWithAdd *) heaeder;
        [header.titleLabel setTextWithExistingAttributes:@"Menus"];
        header.tapBlock = ^{ [self showInputForNewMenu]; };
    };
    
    adapter.cellBlock = ^(UICollectionViewCell *cell, NSIndexPath *indexPath){
        AMMenuCell *menuCell = (AMMenuCell *)cell;
        
        //cleanup
        if([menuCell.indexPath isEqual:self.previouslyExpandedCell])
        {
            UIViewController *oldVC = self.menuViewControllers[menuCell.indexPath.row];
            [oldVC willMoveToParentViewController:nil];
            [menuCell setViewToContain:nil];
            [oldVC removeFromParentViewController];
            self.previouslyExpandedCell = nil;
        }
        
        //vc
        if([indexPath isEqual:self.expandedCell])
        {
            UIViewController *newVC = self.menuViewControllers[indexPath.row];
            [self addChildViewController:newVC];
            [menuCell setViewToContain:newVC.view];
            [newVC didMoveToParentViewController:self];
        }
        
        //actions
        menuCell.tapBlock = ^(NSIndexPath *indexPath){
            [self resizeCellAt:indexPath];
        };

        if([indexPath isEqual:self.expandedCell])
        {
            menuCell.leftBlock = ^(){
                [self showDeleteMenuSectionAlertOfMenuAtIndexPath:indexPath];
            };
            
            menuCell.rightBlock = ^(){
                [self showUpdateMenuSectionFormOfMenuAtIndexPath:indexPath];
            };
            
            menuCell.addBlock = ^(NSIndexPath *index) {
                [self createMenuItemForSectionAtIndexPath:indexPath];
            };
            
            [menuCell.addButton setTitle:@"add item" forState:UIControlStateNormal];
        }
        else
        {
            menuCell.leftBlock = ^(){
                [self deleteMenuAtIndexPath:indexPath];
            };
            
            menuCell.rightBlock = ^(){
                [self updateMenuAtIndexPath:indexPath];
            };
            
            menuCell.addBlock = ^(NSIndexPath *indexPath) {
                [self showInputForMenuSection:indexPath];
            };

            [menuCell.addButton setTitle:@"add section" forState:UIControlStateNormal];
        }
        
        [menuCell setNeedsLayout];
        [menuCell setNeedsDisplay];
        menuCell.indexPath = indexPath;
        menuCell.leftImage = [UIImage drawText:@"" inImageWithSize:CGSizeMake(30, 30) atPoint:CGPointZero withFont:[UIFont fontWithName:ICON_FONT size:30.0f]];
        menuCell.rightImage = [UIImage drawText:@"" inImageWithSize:CGSizeMake(25, 25) atPoint:CGPointZero withFont:[UIFont fontWithName:ICON_FONT size:25.0f]];
    };
    return adapter;
}

-(void)setupMenuViewControllersForMenus:(NSArray *)menus
{
    [self.menuViewControllers each:^(UIViewController *controller) {
        [controller willMoveToParentViewController:nil];
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
    }];
    
    [self.menuViewControllers removeAllObjects];
    
    [menus each:^(AMMenu *menu) {
        AMMenuViewController *vc = [[AMMenuViewController alloc] initWithMenu:menu];
        [self.menuViewControllers addObject:vc];
    }];
}

#pragma mark - Collection View Flow Layout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath isEqual:self.expandedCell])
    {
        return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - 20);
    }
    else
    {
        return CGSizeMake(self.view.bounds.size.width, 60);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return CGSizeMake(self.view.bounds.size.width, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 23.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 23.0f;
}

#pragma mark - Other

-(void)resizeCellAt:(NSIndexPath *)indexPath
{
    if(!self.isResizing)
    {
        [self.menusCollectionView performBatchUpdates:^{
            self.isResizing = YES;
            if([self.expandedCell isEqual:indexPath])
            {
                self.previouslyExpandedCell = self.expandedCell;
                [self.menusCollectionView reloadItemsAtIndexPaths:@[self.expandedCell]];
                self.expandedCell = nil;
                self.menusCollectionView.scrollEnabled = YES;
            }
            else
            {
                [self.menusCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                self.expandedCell = indexPath;
                self.previousOffset = self.menusCollectionView.contentOffset;
                self.menusCollectionView.scrollEnabled = NO;
            }
        } completion:^(BOOL finished) {
            self.isResizing = NO;
        }];
        
        if(self.expandedCell)
        {
            UICollectionViewLayoutAttributes *attr = [self.menusCollectionView layoutAttributesForItemAtIndexPath:self.expandedCell];
            [self.menusCollectionView setContentOffset:CGPointMake(0, attr.frame.origin.y - 20) animated:YES];
            [self.menusCollectionView.collectionViewLayout invalidateLayout];
        }
        else
        {
            [self.menusCollectionView setContentOffset:self.previousOffset animated:YES];
            [self.menusCollectionView.collectionViewLayout invalidateLayout];
        }
    }
}

#pragma mark - INPUT / OUTPUT

-(void)showInputForNewMenu
{
    AMFormViewController *menuForm = [AMFormViewController createMenuViewController];
    [menuForm setAction:^{[self createMenuFromInput];} forTitle:@"create"];
    self.form = menuForm;
    MZFormSheetController *transitionController = [MZFormSheetController withSize:self.view.bounds.size controller:menuForm];
    [self mz_presentFormSheetController:transitionController animated:YES completionHandler:nil];
}

-(void)createMenuFromInput
{
    if(self.restaurant)
    {
        XLFormDescriptor *formDescriptor = self.form.form;
        [[AMClient sharedClient] createMenuOfRestaurant:self.restaurant
                                               withName:[[formDescriptor formRowWithTag:@"name"] value]
                                                 active:[[[formDescriptor formRowWithTag:@"active"] value] boolValue]
                                             completion:^(AMMenu *menu, NSError *error) {
                                                 if(error)
                                                 {
                                                     [CRToastManager showErrorWithMessage:[error localizedDescription]];
                                                     return;
                                                 }
                                                 [self.source refresh];
                                             }];
    }
    self.form = nil;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

-(void)showInputForMenuSection:(NSIndexPath *)indexPath
{
    AMMenu *menu = [self.source.data objectAtIndex:indexPath.row];
    AMFormViewController *sectionForm = [AMFormViewController createSectionViewController];
    [sectionForm setAction:^{ [self createSectionFromInputForMen:menu]; } forTitle:@"create"];
    self.form = sectionForm;
    MZFormSheetController *controller = [MZFormSheetController withSize:self.view.bounds.size controller:sectionForm];
    [self mz_presentFormSheetController:controller animated:YES completionHandler:nil];
}


-(void)createSectionFromInputForMen:(AMMenu *)menu
{
    XLFormDescriptor *formDescriptor = self.form.form;
    [[AMClient sharedClient] createSectionOfMenu:menu
                                        withName:[[formDescriptor formRowWithTag:@"name"] value]
                                     description:[[formDescriptor formRowWithTag:@"description"] value]
                                     staffKindId:@"1"
                                      completion:^(AMMenuSection *section, NSError *error) {
                                          [self.source refresh];
                                      }];

    self.form = nil;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

-(void)deleteMenuAtIndexPath:(NSIndexPath *)indexPath
{
    AMAlertView *altertView = [[AMAlertView alloc] initWithTitle:@"Delete Menu" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    altertView.objectOfConcern = [self.source.data objectAtIndex:indexPath.row];
    [altertView show];
}

- (void)alertView:(AMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if([self.source.data containsObject:alertView.objectOfConcern] && [alertView.title isEqualToString:@"Delete Menu"])
        {
            [[AMClient sharedClient] deleteMenu:alertView.objectOfConcern completion:^(AMMenu *menu, NSError *error) {
                if(error)
                {
                    [CRToastManager showErrorWithMessage:[error localizedDescription]];
                    return;
                }
                [self.source refresh];
            }];
        }
        else if ([self.source.data containsObject:alertView.objectOfConcern] && [alertView.title isEqualToString:@"Delete Section"])
        {
            [[AMClient sharedClient] deleteMenuSection:alertView.objectOfConcern completion:^(AMMenuSection *section, NSError *error) {
                if(error)
                {
                    [CRToastManager showErrorWithMessage:[error localizedDescription]];
                    return;
                }
                [self.source refresh];
            }];
        }
    }
}

-(void)updateMenuAtIndexPath:(NSIndexPath *)indexPath
{
    AMMenu *menu = [self.source.data objectAtIndex:indexPath.row];
    AMFormViewController *menuUpdateForm = [AMFormViewController updateMenuViewController:menu];
    [menuUpdateForm setAction:^{ [self updateMenuFromInputForMenu:menu]; } forTitle:@"update"];
    self.form = menuUpdateForm;
    MZFormSheetController *controller = [MZFormSheetController withSize:self.view.bounds.size controller:menuUpdateForm];
    [self mz_presentFormSheetController:controller animated:YES completionHandler:nil];
}

-(void)updateMenuFromInputForMenu:(AMMenu *)menu
{
    XLFormDescriptor *form = self.form.form;
    [[AMClient sharedClient] updateMenu:menu
                              newActive:[[[form formRowWithTag:@"active"] value] boolValue]
                                newName:[[form formRowWithTag:@"name"] value]
                             completion:^(AMMenu *menu, NSError *error) {
                                 if(error)
                                 {
                                     [CRToastManager showErrorWithMessage:[error localizedDescription]];
                                     return;
                                 }
                                 [self.source refresh];
                             }];
    
    self.form = nil;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

-(void)showDeleteMenuSectionAlertOfMenuAtIndexPath:(NSIndexPath *)indexPath
{
    AMMenuViewController *vc = self.menuViewControllers[indexPath.row];
    AMMenuSection *section = [vc currentlySelectedMenuSection];
    AMAlertView *altertView = [[AMAlertView alloc] initWithTitle:@"Delete Menu Section" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    altertView.objectOfConcern = section;
    [altertView show];
}

-(void)showUpdateMenuSectionFormOfMenuAtIndexPath:(NSIndexPath *)indexPath
{
    AMMenuViewController *vc = self.menuViewControllers[indexPath.row];
    AMMenuSection *section = [vc currentlySelectedMenuSection];
    if(section)
    {
        AMFormViewController *sectionUpdateForm = [AMFormViewController updateSectionViewController:section];
        self.form = sectionUpdateForm;
        [sectionUpdateForm setAction:^{
            [self updateMenuSectionFromInput:section];
        } forTitle:@"update"];
        MZFormSheetController *controller = [MZFormSheetController withSize:self.view.bounds.size controller:sectionUpdateForm];
        [self mz_presentFormSheetController:controller animated:YES completionHandler:nil];
    }
}

-(void)updateMenuSectionFromInput:(AMMenuSection *)menuSection
{
    XLFormDescriptor *form = self.form.form;
    
    [[AMClient sharedClient] updateMenuSection:menuSection
                                   withNewName:[[form formRowWithTag:@"name"] value]
                                newDescription:[[form formRowWithTag:@"description"] value]
                        newStaffKindIdentifier:@"1"
                                    completion:^(AMMenuSection *section, NSError *error) {
                                        if(error)
                                        {
                                            [CRToastManager showErrorWithMessage:[error localizedDescription]];
                                            return;
                                        }
                                        [self.source refresh];
                                    }];
    
    self.form = nil;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

-(void)createMenuItemForSectionAtIndexPath:(NSIndexPath *)indexPath
{
    AMMenuViewController *vc = self.menuViewControllers[indexPath.row];
    AMMenuSection *section = [vc currentlySelectedMenuSection];
    if(section)
    {
        AMFormViewController *menuItemForm = [AMFormViewController createMenuItemViewController];
        self.form = menuItemForm;
        [menuItemForm setAction:^{
            [self createMenuItemFromInput:section];
        } forTitle:@"create"];
        MZFormSheetController *controller = [MZFormSheetController withSize:self.view.bounds.size controller:menuItemForm];
        [self mz_presentFormSheetController:controller animated:YES completionHandler:nil];
    }
}

-(void)createMenuItemFromInput:(AMMenuSection *)section
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.00"];
    
    XLFormDescriptor *form = self.form.form;
    [[AMClient sharedClient] createItemOfSection:section
                                        withName:[[form formRowWithTag:@"name"] value]
                                     description:[[form formRowWithTag:@"description"] value]
                                           price:[[numberFormatter stringFromNumber:[[form formRowWithTag:@"price"] value]] uppercaseString]
                                        currency:[[form formRowWithTag:@"currency"] value]
                                     staffKindId:@"1"
                                          avatar:nil
                                      completion:^(AMMenuItem *item, NSError *error) {
                                          if(error)
                                          {
                                              [CRToastManager showErrorWithMessage:[error localizedDescription]];
                                              return;
                                          }
                                          [self.source refresh];
                                      }];
    self.form = nil;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

@end
