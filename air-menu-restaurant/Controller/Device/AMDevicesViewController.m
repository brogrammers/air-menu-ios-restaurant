//
//  AMDevicesViewController.m
//  Air Menu
//
//  Created by Robert Lis on 20/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMDevicesViewController.h"


@interface AMDevicesViewController () <UICollectionViewDelegate>
@property (nonatomic, readwrite, weak) AMCollectionView *collectionView;
@property (nonatomic, readwrite, strong) AMDataSource *source;
@property (nonatomic, readwrite, strong) NSArray *devices;
@property (nonatomic, readwrite, strong) AMFormViewController *form;
@end

@implementation AMDevicesViewController

-(id)initWithScopes:(NSArray *)scopes user:(AMUser *)user restaurant:(AMRestaurant *)restaurant
{
    self = [super initWithScopes:scopes user:user restaurant:restaurant];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    AMCollectionView *collectionView = [[AMCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.collectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    self.collectionView.identifierToCellClass = @{@"menuCell" : [AMDeviceCell class]};
    self.collectionView.identifierToHeaderClass = @{@"headerCell" : [AMHeaderCellWithAdd class]};
    self.collectionView.delegate = self;
    layout.itemSize = CGSizeMake(320, 75);
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.devices = [NSMutableArray array];
    self.collectionView.refreshBlock = ^{
        [self.source refresh];
    };
    self.source = [[AMDataSource alloc] initWithBlock:^(Done block) {
        if(self.restaurant)
        {
            [[AMClient sharedClient] findDevicesOfRestaurant:self.restaurant completion:^(NSArray *devices, NSError *error) {
                if(!error)
                {
                    block(devices);
                }
                [self.collectionView didEndRefreshing];
            }];
        }
    } destination:self.collectionView adapter:[self adapter]];
    
    [self.source refresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

-(AMCollectionViewAdapter *)adapter
{
    AMCollectionViewAdapter *adapter = [[AMCollectionViewAdapter alloc] init];
    adapter.headerBlock = ^(UICollectionReusableView *heaeder, NSIndexPath *indexPath) {
        AMHeaderCellWithAdd *header = (AMHeaderCellWithAdd *) heaeder;
        [header.titleLabel setTextWithExistingAttributes:@"Devices"];
        header.tapBlock = ^{ [self createDevice]; };
    };
    
    adapter.cellBlock = ^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
        AMDeviceCell *deviceCell = (AMDeviceCell *) cell;
        deviceCell.leftBlock = ^{[self removeDevice:self.source.data[indexPath.row]];};
        deviceCell.rightBlock = ^{[self updateDevice:self.source.data[indexPath.row]];};
        deviceCell.leftImage = [UIImage drawText:@"" inImageWithSize:CGSizeMake(30, 30) atPoint:CGPointZero withFont:[UIFont fontWithName:ICON_FONT size:30.0f]];
        deviceCell.rightImage = [UIImage drawText:@"" inImageWithSize:CGSizeMake(25, 25) atPoint:CGPointZero withFont:[UIFont fontWithName:ICON_FONT size:25.0f]];
    };
    return adapter;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return CGSizeMake(self.view.bounds.size.width, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(void)updateDevice:(AMDevice *)device
{
    AMFormViewController *form = [AMFormViewController updateDeviceViewController:device];
    self.form = form;
    [form setAction:^{
        [self updateDeviceFomForm:device];
    } forTitle:@"update"];
    MZFormSheetController *controller = [MZFormSheetController withSize:self.view.bounds.size controller:form];
    [self mz_presentFormSheetController:controller animated:YES completionHandler:nil];
}

-(void)updateDeviceFomForm:(AMDevice *)device
{
    [[AMClient sharedClient] updateDevice:device
                              withNewName:[self.form.form formRowWithTag:@"name"].value
                                  newUUID:[self.form.form formRowWithTag:@"uuid"].value
                                 newToken:[self.form.form formRowWithTag:@"token"].value
                              newPlatform:[self.form.form formRowWithTag:@"platform"].value
                               completion:^(AMDevice *device, NSError *error) {
                                   [self.source refresh];
                               }];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    self.form = nil;
}

-(void)removeDevice:(AMDevice *)device
{
    AMAlertView *altertView = [[AMAlertView alloc] initWithTitle:@"Delete Menu" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    altertView.objectOfConcern = device;
    [altertView show];
}
                                   
-(void)createDevice
{
    AMFormViewController *form = [AMFormViewController createDeviceViewController];
    self.form = form;
    [form setAction:^{
        [self createDeviceFromForm];
    } forTitle:@"create"];
    MZFormSheetController *controller = [MZFormSheetController withSize:self.view.bounds.size controller:form];
    [self mz_presentFormSheetController:controller animated:YES completionHandler:nil];
}

- (void)alertView:(AMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if([self.source.data containsObject:alertView.objectOfConcern] && [alertView.title isEqualToString:@"Delete Menu"])
        {
            [[AMClient sharedClient] deleteDevice:alertView.objectOfConcern completion:^(AMDevice *device, NSError *error) {
                [self.source refresh];
            }];
        }
    }
}

-(void)createDeviceFromForm
{
    [[AMClient sharedClient] createDeviceOfRestaurant:self.restaurant
                                             withName:[self.form.form formRowWithTag:@"name"].value
                                                 uuid:[self.form.form formRowWithTag:@"uuid"].value
                                                token:[self.form.form formRowWithTag:@"token"].value
                                             platform:[self.form.form formRowWithTag:@"platform"].value
                                           completion:^(AMDevice *device, NSError *error) {
                                               [self.source refresh];
                                           }];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    self.form = nil;
}
@end
