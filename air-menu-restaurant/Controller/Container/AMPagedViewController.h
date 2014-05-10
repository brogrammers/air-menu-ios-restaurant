//
//  AMPagedViewController.h
//  Air Menu
//
//  Created by Robert Lis on 06/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AMPagedViewControllerCell : UICollectionViewCell
@property (nonatomic, readonly, weak) UILabel *titleLabel;
@end

@interface AMPagedViewControllerContainerCell : UICollectionViewCell
@property (nonatomic, readwrite) NSIndexPath *cellPath;
@end

@interface AMPagedViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, readonly, strong) UICollectionView *labels;
@property (nonatomic, readonly, strong) UICollectionView *contents;
@property (nonatomic, readonly, strong) NSArray *viewControllers;
@property (nonatomic, readonly, strong) NSArray *viewControllersLabelsText;
@property (nonatomic, readonly, strong) UIViewController *currentlySelectedViewController;
@property (nonatomic, readwrite) CGFloat labelsHeightInPrecent;

-(void)addViewController:(UIViewController *)viewController forLabelWithText:(NSString *)text;
-(void)setViewController:(UIViewController *)viewController atIndex:(NSUInteger)index forLabelWithText:(NSString *)text;
-(void)inserViewController:(UIViewController *)viewController atIndex:(NSUInteger)index forLabelWithText:(NSString *)text;
-(void)moveViewControllerAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
-(void)exchangeViewControllerAtIndex:(NSUInteger)index withViewControllerAtIndex:(NSUInteger)index;
-(void)removeViewController:(UIViewController *)viewController;
-(void)removeViewControllerAtIndex:(NSUInteger)index;
-(void)removeViewControllerWithLabelText:(NSString*)text;
-(void)removeAllViewControllers;
@end
