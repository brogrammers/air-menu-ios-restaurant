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

@interface AMMenuSectionViewController ()
@property (nonatomic, weak, readwrite) UICollectionView *menuItemsCollectionView;
@property (nonatomic, strong) AMDataSource *source;
@end

@implementation AMMenuSectionViewController

-(id)initWithSection:(AMMenuSection *)menuSection
{
    self = [super init];
    if(self)
    {
        self.section = menuSection;
        [self setupCollectionView];
    }
    return self;
}

-(void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *menuItemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.menuItemsCollectionView = menuItemsCollectionView;
    self.menuItemsCollectionView.identifierToCellClass = @{@"menuItemCell" : [AMMenuItemCell class]};
    [self.view addSubview:self.menuItemsCollectionView];
}

-(void)setSection:(AMMenuSection *)section
{
    _section = section;
//    if(_section)
//    {
//        self.source = [[AMDataSource alloc] initWithBlock:^(Done block) {
//            [[AMClient sharedClient] findItemsOfSection:_section completion:^(NSArray *items, NSError *error) {
//                if(error)
//                {
//                    [CRToastManager showErrorWithMessage:[error localizedDescription]];
//                    return;
//                }
//                [self.source refresh];
//                
//                block(items);
//            }];
//        } destination:self.menuItemsCollectionView adapter:[self createAdapter]];
//    }
}

-(AMCollectionViewAdapter *)createAdapter
{
    AMCollectionViewAdapter *adapter = [[AMCollectionViewAdapter alloc] init];
    return adapter;
}

@end
