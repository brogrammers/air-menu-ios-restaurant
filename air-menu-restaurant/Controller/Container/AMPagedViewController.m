//
//  AMPagedViewController.m
//  Air Menu
//
//  Created by Robert Lis on 06/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMPagedViewController.h"
#import "UILabel+AttributesCopy.h"
#import <pop/POP.h>

#define SPACING 10.0f

@implementation AMPagedViewControllerCell
@synthesize titleLabel = _titleLabel;

+(NSDictionary *)textAttributes
{
    return  @{NSForegroundColorAttributeName : [UIColor whiteColor],
                         NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:12]};
}

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        UILabel *titleLabel = [UILabel newAutoLayoutView];
        [self.contentView addSubview:titleLabel];
        [titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        titleLabel.attributes = [AMPagedViewControllerCell textAttributes];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel = titleLabel;
        
    }
    return _titleLabel;
}

-(void)setTitleLabelText:(NSString *)text
{
    [self.titleLabel setTextWithExistingAttributes:text];
}
@end


@implementation AMPagedViewControllerContainerCell
@end


typedef enum {ScrollDirectionLeft, ScrollDirectionRight, ScrollDirectionNone} ScrollDirection;

@interface AMPagedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, readwrite) CGFloat lastContentOffset;
@property (nonatomic, readwrite) NSInteger visibleViewController;
@property (nonatomic, readwrite, strong) UIViewController *currentlySelectedViewController;
@property (nonatomic, readwrite, weak) UIView *indicator;
@end

@implementation AMPagedViewController
@synthesize labels = _labels, contents = _contents, viewControllers = _viewControllers, viewControllersLabelsText = _viewControllersLabelsText;

#pragma mark - Getter Overrides;

-(UICollectionView *)labels
{
    if(!_labels)
    {
        UICollectionViewFlowLayout *centeringLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *labels = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:centeringLayout];
        labels.translatesAutoresizingMaskIntoConstraints = NO;
        labels.dataSource = self;
        labels.delegate = self;
        _labels = labels;
    }
    
    return _labels;
}

-(UICollectionView *)contents
{
    if(!_contents)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *contents = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        contents.translatesAutoresizingMaskIntoConstraints = NO;
        contents.dataSource = self;
        contents.delegate = self;
        _contents = contents;
    }
    return _contents;
}

-(NSArray *)viewControllers
{
    return [_viewControllers copy];
}

-(NSArray *)viewControllersLabelsText
{
    return [_viewControllersLabelsText copy];
}

#pragma mark - View Controller Lifecycle

-(id)init
{
    self = [super init];
    if(self)
    {
        _labelsHeightInPrecent = 0.1;
        _viewControllers = [NSMutableArray array];
        _viewControllersLabelsText = [NSMutableArray array];
        _visibleViewController = 0;
        [self setupCollectionViews];
        [self setupIndicator];
    }
    return self;
}

-(void)setupCollectionViews
{
    [self.view addSubview:self.labels];
    [self.view addSubview:self.contents];
    self.labels.scrollEnabled = NO;
    [self.labels autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [self.labels autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [self.labels autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [self.labels autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view withMultiplier:self.labelsHeightInPrecent];
    [self.contents autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [self.contents autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [self.contents autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [self.contents autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [self.contents registerClass:[AMPagedViewControllerContainerCell class] forCellWithReuseIdentifier:@"container_cell"];
    [self.labels registerClass:[AMPagedViewControllerCell class] forCellWithReuseIdentifier:@"label_cell"];
    [(UICollectionViewFlowLayout *)self.contents.collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [(UICollectionViewFlowLayout *)self.labels.collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.contents.showsHorizontalScrollIndicator = NO;
    self.labels.showsHorizontalScrollIndicator = NO;
    self.labels.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.contents.backgroundColor = [UIColor clearColor];
    self.contents.pagingEnabled = YES;
    self.labels.decelerationRate = UIScrollViewDecelerationRateFast;
    self.contents.exclusiveTouch = YES;
    self.contents.delaysContentTouches = YES;
    self.contents.canCancelContentTouches = YES;
    self.labels.backgroundColor = [UIColor clearColor];
}

-(void)setupIndicator
{
    UIView *indicator = [[UIView alloc] initWithFrame:CGRectZero];
    self.indicator = indicator;
    self.indicator.backgroundColor = [UIColor whiteColor];
    [self.labels addSubview:indicator];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contents.contentInset = UIEdgeInsetsMake(0, 0, self.labelsHeightInPrecent * self.view.bounds.size.height, 0);
    self.indicator.frame = CGRectMake(-20, (self.labelsHeightInPrecent * self.view.bounds.size.height) - 3, 320, 3);
    [self.contents.collectionViewLayout invalidateLayout];
    [self.labels.collectionViewLayout invalidateLayout];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.viewControllers.count > 0)
    {
        [self placeIndicatorForIndex:0];
    }
}

#pragma mark - Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    [self.labels bringSubviewToFront:self.indicator];
    
    if(collectionView == self.labels)
    {
        AMPagedViewControllerCell *labelCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"label_cell" forIndexPath:indexPath];
        [labelCell setTitleLabelText:_viewControllersLabelsText[indexPath.row]];
        if (indexPath.item == self.visibleViewController)
        {
            labelCell.titleLabel.alpha = 1.0;
        }
        else
        {
            labelCell.titleLabel.alpha = 0.5;
        }
        cell = labelCell;
        [labelCell setNeedsLayout];
    }
    else
    {
        AMPagedViewControllerContainerCell *containerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"container_cell" forIndexPath:indexPath];
        
        if(containerCell.cellPath)
        {
            UIViewController *oldVC = self.viewControllers[containerCell.cellPath.row];
            [oldVC willMoveToParentViewController:nil];
            [oldVC.view removeFromSuperview];
            [oldVC removeFromParentViewController];
        }
        
        UIViewController *newVC = self.viewControllers[indexPath.row];
        [self addChildViewController:newVC];
        newVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        [containerCell.contentView addSubview:newVC.view];
        [newVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [newVC didMoveToParentViewController:self];
        self.currentlySelectedViewController = newVC;
        containerCell.cellPath = indexPath;
        cell = containerCell;
    }
    return cell;
}

#pragma mark - Collection View Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.labels)
    {
        return CGSizeMake([self widthOfString:[[NSAttributedString alloc] initWithString:_viewControllersLabelsText[indexPath.row]
                                                                              attributes:[AMPagedViewControllerCell textAttributes]]], self.labels.bounds.size.height);
    }
    else
    {
        return CGSizeMake(self.contents.bounds.size.width, self.contents.bounds.size.height - self.labels.bounds.size.height);
    }
}

-(CGFloat)widthOfString:(NSAttributedString *)string
{
    CGRect rect = [string boundingRectWithSize:(CGSize){CGFLOAT_MAX, self.labels.bounds.size.height}
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                       context:nil];
    return ceilf(rect.size.width) + 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return collectionView == self.contents ? 0 : 50;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return collectionView == self.contents ? 0 : 50;
}

#pragma mark - Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if(scrollView == self.contents)
    {
        if(scrollView.isDragging)
        {
            if (self.lastContentOffset < self.contents.contentOffset.x)
            {
                self.indicator.center = CGPointMake(self.indicator.center.x + 0.1, self.indicator.center.y);
            }
            else if(self.lastContentOffset >= self.contents.contentOffset.x)
            {
                 self.indicator.center = CGPointMake(self.indicator.center.x - 0.5, self.indicator.center.y);
            }
        }
        
        self.lastContentOffset = self.contents.contentOffset.x;
        
        if(self.labels.contentInset.left + self.labels.contentInset.right + self.labels.contentSize.width > self.labels.bounds.size.width)
        {
            CGFloat percentageScrolled = self.contents.contentOffset.x / (self.contents.contentSize.width - self.contents.bounds.size.width);
            CGFloat contentsDelta = (self.labels.contentSize.width - self.labels.bounds.size.width + self.labels.contentInset.right + self.labels.contentInset.left) * percentageScrolled;
            self.labels.contentOffset = CGPointMake(-self.labels.contentInset.left + contentsDelta, self.labels.contentOffset.y);
            self.indicator.center = CGPointMake(self.indicator.center.x + 0.25, self.indicator.center.y);
        }
    }
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offset = targetContentOffset->x / self.contents.frame.size.width;
    NSInteger newVisibleViewController = [@(offset) integerValue];
    [self placeIndicatorForIndex:newVisibleViewController];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self highlightCell];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self highlightCell];
}

-(void)highlightCell
{
    CGFloat offset = self.contents.contentOffset.x / self.contents.frame.size.width;
    NSInteger newVisibleViewController = [@(offset) integerValue];
    self.visibleViewController = newVisibleViewController;
    [self placeIndicatorForIndex:newVisibleViewController];
    [self.labels reloadData];
}

-(void)placeIndicatorForIndex:(NSInteger)index
{
    UICollectionViewLayoutAttributes *attr = [self.labels layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(attr.frame.origin.x, self.labels.bounds.size.height - 3, attr.frame.size.width,3)];
    [self.indicator pop_addAnimation:anim forKey:nil];
}

#pragma mark - Public API

-(void)addViewController:(UIViewController *)viewController forLabelWithText:(NSString *)text
{
    [(NSMutableArray *) _viewControllers addObject:viewController];
    [(NSMutableArray *) _viewControllersLabelsText addObject:text];
    [self.labels reloadData];
    [self.contents reloadData];
}

-(void)setViewController:(UIViewController *)viewController atIndex:(NSUInteger)index forLabelWithText:(NSString *)text
{
    ((NSMutableArray *) _viewControllers)[index] = viewController;
    ((NSMutableArray *) _viewControllersLabelsText)[index] = text;
    [self.labels reloadData];
    [self.contents reloadData];
}

-(void)inserViewController:(UIViewController *)viewController atIndex:(NSUInteger)index forLabelWithText:(NSString *)text
{
    [((NSMutableArray *) _viewControllers) insertObject:viewController atIndex:index];
    [((NSMutableArray *) _viewControllersLabelsText) insertObject:text atIndex:index];
    [self.labels reloadData];
    [self.contents reloadData];
}

-(void)moveViewControllerAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    UIViewController *controller = ((NSMutableArray *) _viewControllers)[fromIndex];
    NSString *text = ((NSMutableArray *) _viewControllersLabelsText)[fromIndex];
    [((NSMutableArray *) _viewControllers) removeObject:controller];
    [((NSMutableArray *) _viewControllersLabelsText) removeObject:text];
    [((NSMutableArray *) _viewControllers) insertObject:controller atIndex:toIndex - 1];
    [((NSMutableArray *) _viewControllersLabelsText) insertObject:text atIndex:toIndex - 1];
    [self.labels reloadData];
    [self.contents reloadData];
}

-(void)exchangeViewControllerAtIndex:(NSUInteger)index withViewControllerAtIndex:(NSUInteger)otherIndex
{
    [((NSMutableArray *) _viewControllers) exchangeObjectAtIndex:index withObjectAtIndex:otherIndex];
    [((NSMutableArray *) _viewControllersLabelsText) exchangeObjectAtIndex:index withObjectAtIndex:otherIndex];
    [self.labels reloadData];
    [self.contents reloadData];
}

-(void)removeViewController:(UIViewController *)viewController
{
    NSUInteger index = [((NSMutableArray *) _viewControllers) indexOfObject:viewController];
    [((NSMutableArray *) _viewControllers) removeObjectAtIndex:index];
    [((NSMutableArray *) _viewControllersLabelsText) removeObjectAtIndex:index];
    [self.labels reloadData];
    [self.contents reloadData];
}

-(void)removeViewControllerAtIndex:(NSUInteger)index
{
    [((NSMutableArray *) _viewControllers) removeObjectAtIndex:index];
    [((NSMutableArray *) _viewControllersLabelsText) removeObjectAtIndex:index];
    [self.labels reloadData];
    [self.contents reloadData];
}

-(void)removeViewControllerWithLabelText:(NSString*)text
{
    NSUInteger index = [((NSMutableArray *) _viewControllersLabelsText) indexOfObject:text];
    [((NSMutableArray *) _viewControllers) removeObjectAtIndex:index];
    [((NSMutableArray *) _viewControllersLabelsText) removeObjectAtIndex:index];
    [self.labels reloadData];
    [self.contents reloadData];
}

-(void)removeAllViewControllers
{
    [((NSMutableArray *) _viewControllers) removeAllObjects];
    [((NSMutableArray *) _viewControllersLabelsText) removeAllObjects];
    [self.labels reloadData];
    [self.contents reloadData];
}

@end














