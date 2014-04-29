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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
    [self setNeedsDisplay];
}

-(void)setContentInset:(UIEdgeInsets)contentInset
{
    UIEdgeInsets insets =  UIEdgeInsetsMake(contentInset.top + self.headerView.bounds.size.height, contentInset.left, contentInset.bottom, contentInset.right);
    [super setContentInset:insets];
}

-(void)layoutSubviews
{
    self.headerView.frame = CGRectMake(0, 0, self.bounds.size.width, self.headerView.bounds.size.height);
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [super layoutSubviews];
}
@end
