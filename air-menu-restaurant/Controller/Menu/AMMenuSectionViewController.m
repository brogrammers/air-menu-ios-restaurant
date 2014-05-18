//
//  AMMenuSectionViewController.m
//  Air Menu
//
//  Created by Robert Lis on 09/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuSectionViewController.h"
#import "AMDataSource.h"
#import "UICollectionView+AMCollectionViewAdapter.h"
#import "AMCollectionViewAdapter.h"
#import "CRToastManager+AMNotification.h"
#import "AMMenuItemCell.h"
#import "UILabel+AttributesCopy.h"
#import "UITextView+AttributesCopy.h"
#import "UIImage+TextDrawing.h"
#import "AMAlertView.h"
#import "AMFormViewController.h"
#import "MZFormSheetController+AMTransitionStyle.h"

@interface AMMenuSectionViewController () <UICollectionViewDelegate, UIAlertViewDelegate>
@property (nonatomic, readwrite, strong) NSNumberFormatter *formatter;
@property (nonatomic, weak, readwrite) UICollectionView *menuItemsCollectionView;
@property (nonatomic, strong) AMDataSource *source;
@property (nonatomic, readwrite, strong) AMMenuItemCell *sampleCell;
@property (nonatomic, readwrite, strong) AMFormViewController *form;
@end

@implementation AMMenuSectionViewController

-(id)initWithSection:(AMMenuSection *)menuSection
{
    self = [super init];
    if(self)
    {
        [self setupCollectionView];
        [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [self.formatter setPositiveFormat:@"##0.00"];
        self.sampleCell = [[AMMenuItemCell alloc] initWithFrame:CGRectZero];
        self.section = menuSection;
    }
    return self;
}

-(void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *menuItemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    menuItemsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuItemsCollectionView = menuItemsCollectionView;
    [self.view addSubview:self.menuItemsCollectionView];
    [self.menuItemsCollectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.menuItemsCollectionView.identifierToCellClass = @{@"menuItemCell" : [AMMenuItemCell class]};
    self.menuItemsCollectionView.delegate = self;
    self.menuItemsCollectionView.backgroundColor = [UIColor clearColor];
}

-(void)setSection:(AMMenuSection *)section
{
    _section = section;
    if(_section)
    {
        self.source = [[AMDataSource alloc] initWithBlock:^(Done block) {
            [[AMClient sharedClient] findItemsOfSection:_section completion:^(NSArray *items, NSError *error) {
                if(error)
                {
                    [CRToastManager showErrorWithMessage:[error localizedDescription]];
                    return;
                }
                
                block(items);
            }];
        } destination:self.menuItemsCollectionView adapter:[self createAdapter]];
    }
}

-(AMCollectionViewAdapter *)createAdapter
{
    AMCollectionViewAdapter *adapter = [[AMCollectionViewAdapter alloc] init];
    adapter.cellBlock = ^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
        AMMenuItemCell *itemCell = (AMMenuItemCell *)cell;
        itemCell.leftBlock = ^() { [self deleteItemAtIndexPath:indexPath];};
        itemCell.rightBlock = ^() { [self updateItemAtIndexPath:indexPath];};
        itemCell.indexPath = indexPath;
        itemCell.leftImage = [UIImage drawText:@"" inImageWithSize:CGSizeMake(30, 30) atPoint:CGPointZero withFont:[UIFont fontWithName:ICON_FONT size:30.0f]];
        itemCell.rightImage = [UIImage drawText:@"" inImageWithSize:CGSizeMake(25, 25) atPoint:CGPointZero withFont:[UIFont fontWithName:ICON_FONT size:25.0f]];
    };
    return adapter;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMMenuItem *item = [self.source.data objectAtIndex:indexPath.row];
    CGFloat nameHeight = [self nameFieldHeightForString:item.name
                                              withWidth:280
                                              withPrice:[[[self.formatter stringFromNumber:item.price] stringByAppendingString:@" "] stringByAppendingString:item.currency]];
    CGFloat descriptionHeight = [self sizeOfDescriptionLabelWithString:item.details].height;
    if(item.details && ![item.details isEqualToString:@""])
    {
        descriptionHeight += 20.0f;
    }
    else
    {
        descriptionHeight -= 20.0f;
    }
    
    return CGSizeMake(self.view.bounds.size.width, ceilf(nameHeight) + ceilf(descriptionHeight) + 40.0f);
}

-(CGFloat)nameFieldHeightForString:(NSString *)name withWidth:(CGFloat)width withPrice:(NSString *)price
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:name attributes:self.sampleCell.itemNameLabel.attributes];
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(width, CGFLOAT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    layoutManager.textStorage = textStorage;
    CGRect exclusionRect = CGRectMake(width - [self sizeOfPriceFieldWithString:price].width,
                                      0,
                                      [self sizeOfPriceFieldWithString:price].width,
                                      [self sizeOfPriceFieldWithString:price].height);
    container.exclusionPaths = @[[UIBezierPath bezierPathWithRect:exclusionRect]];
    [layoutManager addTextContainer:container];
    CGRect rect = [layoutManager boundingRectForGlyphRange:NSMakeRange(0, [textStorage length]) inTextContainer:container];
    return rect.size.height;
}

-(CGSize)sizeOfPriceFieldWithString:(NSString *)price
{
    return [price sizeWithAttributes:self.sampleCell.itemPriceLabel.attributes];
}

-(CGSize)sizeOfDescriptionLabelWithString:(NSString *)description
{
    return [description boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:self.sampleCell.itemDescriptionLabel.attributes
                                     context:nil].size;
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(!self.view.layer.mask)
    {
        CGColorRef transparent = [UIColor colorWithWhite:0 alpha:0].CGColor;
        CGColorRef opaque =  [UIColor colorWithWhite:0 alpha:1].CGColor;
        CALayer * maskLayer = [CALayer layer];
        maskLayer.frame = self.view.bounds;
        
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(self.view.bounds.origin.x, 0,
                                         self.view.bounds.size.width, self.view.bounds.size.height);
        
        gradientLayer.locations = @[[NSNumber numberWithFloat:0],
                                    [NSNumber numberWithFloat:0.97],
                                    [NSNumber numberWithFloat:1.0]];
        gradientLayer.colors = @[(__bridge id) opaque, (__bridge id) opaque, (__bridge id) transparent];
        [maskLayer addSublayer:gradientLayer];
        self.view.layer.mask = maskLayer;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

#pragma mark - I/O

-(void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMMenuItem *item = [self.source.data objectAtIndex:indexPath.row];
    AMAlertView *altertView = [[AMAlertView alloc] initWithTitle:@"Delete Menu Item" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    altertView.objectOfConcern = item;
    altertView.delegate = self;
    [altertView show];
}

- (void)alertView:(AMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && [self.source.data containsObject:alertView.objectOfConcern])
    {
        [[AMClient sharedClient] deleteMenuItem:alertView.objectOfConcern completion:^(AMMenuItem *item, NSError *error) {
            if(error)
            {
                [CRToastManager showErrorWithMessage:[error localizedDescription]];
                return ;
            }
            [self.source refresh];
        }];
    }
}


-(void)updateItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMMenuItem *item = [self.source.data objectAtIndex:indexPath.row];
    AMFormViewController *controller = [AMFormViewController updateMenuItemViewController:item];
    [controller setAction:^{
        [self updateMenuItemFromInput:item];
    } forTitle:@"item"];
    
    self.form = controller;
    MZFormSheetController *transitionController = [MZFormSheetController withSize:self.view.bounds.size controller:controller];
    [self mz_presentFormSheetController:transitionController animated:YES completionHandler:nil];
}

-(void)updateMenuItemFromInput:(AMMenuItem *)item
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.00"];
    
    XLFormDescriptor *form = self.form.form;
    
    [[AMClient sharedClient] updateMenuItem:item
                                withNewName:[[form formRowWithTag:@"name"] value]
                             newDescription:[[form formRowWithTag:@"description"] value]
                                   newPrice:[[numberFormatter stringFromNumber:[[form formRowWithTag:@"price"] value]] uppercaseString]
                                newCurrency:[[form formRowWithTag:@"currency"] value]
                             newStaffKindId:@"1"
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
