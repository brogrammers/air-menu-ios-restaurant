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
@property CGFloat headerViewHeight;
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
    [self.backgroundView removeFromSuperview];
    _headerView = headerView;
    self.headerViewHeight = headerView.frame.size.height;
    self.backgroundView = headerView;
    [self setContentInset:self.contentInset];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(self.headerView)
    {
        self.headerView.frame = CGRectMake(0, -self.headerViewHeight, self.bounds.size.width, self.headerViewHeight);
        self.refresh.frame = CGRectMake(0, -(self.headerViewHeight * 2 + 20), self.refresh.frame.size.width, self.refresh.frame.size.height);
    }
}

-(void)setContentInset:(UIEdgeInsets)contentInset
{
    if (self.headerView)
    {
        if(self.contentOffset.y >= 0 && self.contentOffset.x >= 0)
        {
            contentInset.top += self.headerViewHeight;
        }
    }

    [super setContentInset:contentInset];
}
@end
