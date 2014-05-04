//
//  AMCollectionView.m
//  Air Menu
//
//  Created by Robert Lis on 21/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMCollectionView.h"

@interface AMCollectionView()
@property (nonatomic, readwrite, weak) UIRefreshControl *refresh;
@end

@implementation AMCollectionView

+(AMCollectionView *)collectionViewWithLayoutClass:(Class)layoutClass
{
    AMCollectionView *collectionView = [[AMCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[layoutClass alloc] init]];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = YES;
    return collectionView;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self)
    {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self
                           action:@selector(startRefresh:)
                 forControlEvents:UIControlEventValueChanged];
        [self addSubview:refreshControl];
        self.alwaysBounceVertical = YES;
        self.refresh = refreshControl;
    }
    return self;
}

-(void)startRefresh:(UIRefreshControl *)refreshControl
{
    if(self.refreshBlock)
    {
        self.refreshBlock();
    }
}

-(void)didEndRefreshing
{
    [self.refresh endRefreshing];
}

-(void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    [self sendSubviewToBack:self.refresh];
}

-(void)setHeaderView:(UIView *)headerView
{
    [_headerView removeFromSuperview];
    _headerView = headerView;
    [self addSubview:headerView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect headerFrame = self.headerView.frame;
    headerFrame.origin.y = -50;
    self.headerView.frame = headerFrame;
    
    CGRect refreshControlFrame = self.refresh.frame;
    refreshControlFrame.origin.y += -30;
    self.refresh.frame = refreshControlFrame;
}

@end
