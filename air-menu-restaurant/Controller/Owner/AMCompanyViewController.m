//
//  AMCompanyViewController.m
//  Air Menu
//
//  Created by Robert Lis on 14/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMCompanyViewController.h"
#import "AMRestaurantCell.h"
#import "AMRestaurantViewPickerViewController.h"
#import "AMHeaderCellWithAdd.h"
#import "UILabel+AttributesCopy.h"
#import "AMRestaurantCreatorViewController.h"
#import "AMCollectionView.h"
#import "AMButton.h"
#import "AMFormViewController.h"
#import "AMAlertView.h"
#import "NSArray+Updates.h"
#import "CRToastManager+AMNotification.h"
#import "UIImage+TextDrawing.h"

@interface AMCompanyViewController () <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
@property (nonatomic, readwrite, strong) NSMutableArray *restaurants;
@property (nonatomic, readwrite, strong) AMCompany *company;
@property (nonatomic, readwrite, strong) AMRestaurantViewPickerViewController *pickerViewController;
@property (nonatomic, readwrite, strong) AMCollectionView *collectionView;
@end

@implementation AMCompanyViewController

-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user
{
    self = [super initWithScopes:scopes user:user];
    if(self)
    {
        [self fetchData];
        [self setup];
    }
    return self;
}

-(void)fetchData
{
    [[AMClient sharedClient] findRestaurantsOfCompany:self.user.company completion:^(NSArray *restaurants, NSError *error) {
        if(!error)
        {
            [self.collectionView performBatchUpdates:^{
                [[self.restaurants toRemove:restaurants] each:^(AMRestaurant *restaurant) {
                    NSUInteger index = [self.restaurants indexOfObject:restaurant];
                    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
                }];
                
                [[self.restaurants toUpdate:restaurants] each:^(AMRestaurant *restaurant) {
                    NSUInteger oldIndex = [self.restaurants indexOfObject:restaurant];
                    NSUInteger newIndex = [restaurants indexOfObject:restaurant];
                    [self.collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:oldIndex inSection:0]
                                                 toIndexPath:[NSIndexPath indexPathForItem:newIndex inSection:0]];
                }];
                
                [[self.restaurants toAdd:restaurants] each:^(AMRestaurant *restaurant) {
                    NSUInteger index = [restaurants indexOfObject:restaurant];
                    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
                }];
                
                self.restaurants = [restaurants mutableCopy];

            } completion:nil];
        }
        else
        {
            [CRToastManager showErrorWithMessage:[error localizedDescription]];
        }
        
        [self.collectionView didEndRefreshing];
    }];
}

-(void)setup
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    AMCollectionView *collectionView = [[AMCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.restaurants = [NSMutableArray array];
    collectionView.refreshBlock = ^{
        [self fetchData];
    };
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[AMRestaurantCell class] forCellWithReuseIdentifier:@"restaurant_cell"];
    self.pickerViewController = [[AMRestaurantViewPickerViewController alloc] initWithScopes:self.scopes user:self.user];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[AMHeaderCellWithAdd class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"add_company_header"];
    self.collectionView.bounces = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Gesture Recogniser Delegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return ![otherGestureRecognizer.view isKindOfClass:[UITableView class]];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.restaurants.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMRestaurantCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"restaurant_cell" forIndexPath:indexPath];
    AMRestaurant *restaurant = self.restaurants[indexPath.row];
    cell.textLabel.text = restaurant.name;
    cell.indexPath = indexPath;
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@, %@, %@", restaurant.address.addressLine1, restaurant.address.addressLine2, restaurant.address.city];
    cell.tapBlock = ^(NSIndexPath *indexPath){
        self.navigationController.delegate = self; 
        [self.navigationController pushViewController:self.pickerViewController animated:YES];
    };
    cell.leftBlock = ^{
        AMAlertView *altertView = [[AMAlertView alloc] initWithTitle:@"Delete Restaurant" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        altertView.objectOfConcern = restaurant;
        [altertView show];
    };
    
    cell.leftImage = [UIImage drawText:@"" inImageWithSize:CGSizeMake(30, 30) atPoint:CGPointZero withFont:[UIFont fontWithName:ICON_FONT size:30.0f]];
    cell.rightImage = [UIImage drawText:@"" inImageWithSize:CGSizeMake(30, 30) atPoint:CGPointZero withFont:[UIFont fontWithName:ICON_FONT size:30.0f]];
    
    cell.rightBlock = ^{
        [self updateRestaurant:restaurant];
    };
    return cell;
}

-(void)updateRestaurant:(AMRestaurant *)restaurant
{
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:[self restaurantUpdateInputViewController:restaurant] animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    AMHeaderCellWithAdd *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"add_company_header" forIndexPath:indexPath];
    [header.titleLabel setTextWithExistingAttributes:@"Restaurants"];
    header.tapBlock = ^{
        self.navigationController.delegate = self;
        [self.navigationController pushViewController:[self restaurantInputViewController] animated:YES];
    };
    return header;
}

-(UIViewController *)restaurantUpdateInputViewController:(AMRestaurant *)restaurant
{
    return [[UIViewController alloc] init];
}

-(UIViewController *)restaurantInputViewController
{
    AMFormViewController *controller = [AMFormViewController restaurantInputViewController];
    __weak AMFormViewController *_controller = controller;
    [controller setAction:^{
        CLLocation *region = [[_controller.form formRowWithTag:@"map"] value];
        [[AMClient sharedClient] createRestaurantOfCompany:self.user.company
                                                  withName:[[_controller.form formRowWithTag:@"name"] value]
                                                   loyalty:YES
                                               remoteOrder:YES
                                            conversionRate:@2.5
                                            addressLineOne:[[_controller.form formRowWithTag:@"address line 1"] value]
                                            addressLineTwo:[[_controller.form formRowWithTag:@"address line 2"] value]
                                                      city:[[_controller.form formRowWithTag:@"city"] value]
                                                    county:[[_controller.form formRowWithTag:@"county"] value]
                                                     state:[[_controller.form formRowWithTag:@"state"] value]
                                                   country:[[_controller.form formRowWithTag:@"country"] value]
                                                  latitude:region.coordinate.latitude
                                                 longitude:region.coordinate.longitude
                                                completion:^(AMRestaurant *restaurant, NSError *error) {
                                                    if(!error)
                                                    {
                                                        [_controller.navigationController popViewControllerAnimated:YES];
                                                        [self.collectionView performBatchUpdates:^{
                                                            [self.restaurants addObject:restaurant];
                                                            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.restaurants.count - 1 inSection:1]]];
                                                        } completion:nil];
                                                    }
                                                    else
                                                    {
                                                        [CRToastManager showErrorWithMessage:[error localizedDescription]];
                                                    }
                                                }];
    } forTitle:@"create"];
    return controller;
}

#pragma mark - Collection View Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width, 70);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsZero;
}

#pragma mark - Navigation Controller Delegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if(viewController == self)
        {
            self.view.alpha = 1.0;
        }
        else
        {
            self.view.alpha = 0.0;
        }
    } completion:nil];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - Alert View Delegate

- (void)alertView:(AMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && [self.restaurants containsObject:alertView.objectOfConcern])
    {
        [[AMClient sharedClient] deleteRestaurant:alertView.objectOfConcern completion:^(AMRestaurant *restaurant, NSError *error) {
            if(!error)
            {
                NSUInteger index = [self.restaurants indexOfObject:restaurant];
                if(index != NSNotFound)
                {
                    [self.collectionView performBatchUpdates:^{
                        [self.restaurants removeObjectAtIndex:index];
                        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:1]]];
                    } completion:nil];
                }
            }
            else
            {
                [CRToastManager showErrorWithMessage:[error localizedDescription]];
            }
        }];
    }
}

@end
