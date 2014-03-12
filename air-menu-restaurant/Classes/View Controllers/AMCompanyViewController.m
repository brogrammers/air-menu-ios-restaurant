//
//  AMCompanyViewController.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 06/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMCompanyViewController.h"
#import "AMRestaurantCell.h"
#import "AMActionCell.h"
#import "AMAddTableHeaderView.h"
#import "AMRestaurantCreatorViewController.h"

@interface AMFadingTableView : UITableView
@property CGFloat fadePercentage;
@property CGFloat fadePercentageHidden;
@property BOOL isFadedOut;
@end

@implementation AMFadingTableView

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(!self.layer.mask)
    {
        CGColorRef transparent = [UIColor colorWithWhite:0 alpha:0].CGColor;
        CGColorRef opaque =  [UIColor colorWithWhite:0 alpha:1].CGColor;
        CALayer * maskLayer = [CALayer layer];
        maskLayer.frame = self.bounds;
        
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(self.bounds.origin.x, 0,
                                         self.bounds.size.width, self.bounds.size.height);
        
        gradientLayer.colors = @[(__bridge id) transparent, (__bridge id) opaque, (__bridge id) opaque, (__bridge id) transparent];
        gradientLayer.locations =  @[[NSNumber numberWithFloat:0],
                                     [NSNumber numberWithFloat:self.fadePercentage],
                                     [NSNumber numberWithFloat:1.0 - self.fadePercentage],
                                     [NSNumber numberWithFloat:1]];
        [maskLayer addSublayer:gradientLayer];
        self.layer.mask = maskLayer;
    }
    else
    {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        self.layer.mask.frame = self.bounds;
        [CATransaction commit];
    }
    

    if(self.isFadedOut)
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.525];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];

        ((CAGradientLayer *)self.layer.mask.sublayers[0]).locations =  @[[NSNumber numberWithFloat:0],
                                                                         [NSNumber numberWithFloat:self.fadePercentage],
                                                                         [NSNumber numberWithFloat:self.fadePercentageHidden],
                                                                         [NSNumber numberWithFloat:self.fadePercentageHidden + 0.05]];
        [CATransaction commit];

    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.525];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [UIView setAnimationDelay:5.0];
            ((CAGradientLayer *)self.layer.mask.sublayers[0]).locations = @[[NSNumber numberWithFloat:0],
                                                                            [NSNumber numberWithFloat:self.fadePercentage],
                                                                            [NSNumber numberWithFloat:1.0 - self.fadePercentage],
                                                                            [NSNumber numberWithFloat:1]];
            [CATransaction commit];
        });
        
    }
}

@end

@interface AMCompanyViewController() <UITableViewDelegate,
                                      UITableViewDataSource,
                                      AMAddTableHeaderViewDelegate,
                                      UIViewControllerTransitioningDelegate,
                                      UIViewControllerAnimatedTransitioning,
                                      AMRestaurantCreatorViewControllerDelegate>

@property (nonatomic, weak, readwrite) AMFadingTableView *tableView;
@property BOOL isCreatingCompany;
@property BOOL isAppearing;
@end

@implementation AMCompanyViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createTableView];
}

-(void)createTableView
{
    AMFadingTableView *tableView = [[AMFadingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.fadePercentage = 0.1;
    tableView.fadePercentageHidden = 0.18;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView = tableView;
    [self.tableView registerClass:[AMRestaurantCell class] forCellReuseIdentifier:@"restaurant_cell"];
    [self.tableView registerClass:[AMAddTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"add_restaurant_header"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.view addSubview:tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMRestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restaurant_cell" forIndexPath:indexPath];
    [cell setActions:@[@"Edit", @"Delete"]
           withFonts:@[[UIFont fontWithName:GOTHAM_BOOK size:20], [UIFont fontWithName:GOTHAM_BOOK size:20]]
           andColors:@[[UIColor colorWithRed:119.0f/255.0f green:207.0f/255.0f blue:71.0f/255.0f alpha:1.0], [UIColor colorWithRed:208.0f/255.0f green:2.0f/255.0f blue:27.0f/255.0f alpha:1.0]]];
    cell.restaurantNameLabel.text = @"A Restaurant Name";
    cell.backgroundView= [[UIView alloc] initWithFrame:cell.bounds];
    cell.separatorInset = UIEdgeInsetsMake(0, 320.0f, 0, 0);
    return cell;
}

#pragma mark - Table View delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AMAddTableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"add_restaurant_header"];
    header.delegate = self;
    [header.button setStyle:kFRDLivelyButtonStylePlus animated:NO];
    header.label.text = @"RESTAURANTS";
    return header;
}
#pragma mark - Add table header delegate

-(void)sectionAtIndex:(NSUInteger)index didPressButton:(FRDLivelyButton *)button
{
    self.isCreatingCompany = !self.isCreatingCompany;
    if(self.isCreatingCompany)
    {
        [button setStyle:kFRDLivelyButtonStyleClose animated:YES];
        self.tableView.scrollEnabled = NO;
        [self.tableView.visibleCells makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:@NO];
        self.tableView.isFadedOut = YES;
        
        AMRestaurantCreatorViewController *restaurantCreatorViewController = [[AMRestaurantCreatorViewController alloc] init];
        restaurantCreatorViewController.transitioningDelegate = self;
        restaurantCreatorViewController.modalPresentationStyle = UIModalPresentationCustom;
        restaurantCreatorViewController.delegate = self;
        [self presentViewController:restaurantCreatorViewController animated:YES completion:nil];
    }
    else
    {
        [button setStyle:kFRDLivelyButtonStylePlus animated:YES];
        self.tableView.scrollEnabled = YES;
        [self.tableView.visibleCells makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:@YES];
        self.tableView.isFadedOut = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
}

#pragma mark - Transitioning delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    self.isAppearing = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isAppearing = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    if(self.isAppearing)
    {
        CGRect toViewFrame = toView.frame;
        toViewFrame.size.height -= 100;
        toView.frame = toViewFrame;
        toView.center = CGPointApplyAffineTransform(fromView.center, CGAffineTransformMakeTranslation(0, fromView.bounds.size.height));
        toView.alpha = 0.0;
        [UIView animateWithDuration:1.0
                              delay:0.1
             usingSpringWithDamping:0.70
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             toView.center = CGPointApplyAffineTransform(fromView.center, CGAffineTransformMakeTranslation(0, 50));
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
        
        [UIView animateWithDuration:0.8f animations:^{
            toView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateKeyframesWithDuration:1.0
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionCalculationModeCubic
                                  animations:^{
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:0.2
                                                                    animations:^{
                                                                        fromView.center = CGPointApplyAffineTransform(fromView.center, CGAffineTransformMakeTranslation(0, -10));
                                                                    }];
                                      
                                      [UIView addKeyframeWithRelativeStartTime:0.2
                                                              relativeDuration:0.8
                                                                    animations:^{
                                                                        fromView.alpha = 0.0;
                                                                        fromView.center = CGPointApplyAffineTransform(fromView.center, CGAffineTransformMakeTranslation(0, toView.bounds.size.height));
                                                                    }];
                                      
                                      [self.tableView setNeedsLayout];
                                      [self.tableView layoutIfNeeded];
                                  }
                                  completion:^(BOOL finished) {
                                      [fromView removeFromSuperview];
                                      [transitionContext completeTransition:YES];
                                  }];
    }
}

#pragma mark - Restaurant creator delegate 

-(void)restaurantCreatorViewController:(AMRestaurantCreatorViewController *)controller didCreateCompany:(AMCompany *)company
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
}

@end
