//
//  AMMenuItemView.m
//  Air Menu C
//
//  Created by Robert Lis on 21/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuItemCell.h"
#import "UILabel+AttributesCopy.h"
#import "UITextView+AttributesCopy.h"
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "UILabel+AttributesCopy.h"
#import "AMLineSpacer.h"

@interface AMMenuItemCell()
@property (nonatomic, readwrite, weak) UITextView *itemNameLabel;
@property (nonatomic, readwrite, weak) UILabel *itemPriceLabel;
@property (nonatomic, readwrite, weak) UILabel *itemDescriptionLabel;
@property (nonatomic, readwrite, weak) AXRatingView *ratingView;
@end

@implementation AMMenuItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self createItemNameLabel];
    [self createItemPriceLabel];
    [self createItemDescriptionLabel];
    [self createItemRatingView];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

-(void)createItemNameLabel
{
    UITextView *itemNameLabel = [UITextView newAutoLayoutView];
    self.itemNameLabel = itemNameLabel;
    [self.contentView addSubview:self.itemNameLabel];
    [self.itemNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f];
    [self.itemNameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.itemNameLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [self.itemNameLabel autoSetDimension:ALDimensionHeight toSize:25].priority = UILayoutPriorityDefaultLow;
    [self.itemNameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView].priority = UILayoutPriorityDefaultLow;
    self.itemNameLabel.attributes = @{ NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:20.0f],
                                       NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.itemNameLabel.contentInset = UIEdgeInsetsMake(-8,-5,0,0);
    self.itemNameLabel.textAlignment = NSTextAlignmentLeft;
    self.itemNameLabel.backgroundColor = [UIColor clearColor];
    self.itemNameLabel.userInteractionEnabled = NO;
    [self.itemNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self.itemNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    AMLineSpacer *spacer= [AMLineSpacer newAutoLayoutView];
    [self.contentView addSubview:spacer];
    [spacer autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [spacer autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [spacer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.itemNameLabel withOffset:10.0f];
    [spacer autoSetDimension:ALDimensionHeight toSize:0.5];
    spacer.shouldFade = NO;
    spacer.alpha = 0.1;
}

-(void)createItemPriceLabel
{
    UILabel *itemPriceLabel = [UILabel newAutoLayoutView];
    self.itemPriceLabel = itemPriceLabel;
    [self.contentView addSubview:self.itemPriceLabel];
    [self.itemPriceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f];
    [self.itemPriceLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    self.itemPriceLabel.numberOfLines = 0;
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:GOTHAM_NARROW_LIGHT size:15.0f],
                                 NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSUnderlineStyleAttributeName : @1};
    self.itemPriceLabel.attributes = attributes;
}

-(void)createItemDescriptionLabel
{
    UILabel *itemDescriptionLabel = [UILabel newAutoLayoutView];
    self.itemDescriptionLabel = itemDescriptionLabel;
    [self.contentView addSubview:self.itemDescriptionLabel];
    [self.itemDescriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.itemNameLabel withOffset:20.0];
    [self.itemDescriptionLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.itemDescriptionLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [self.itemDescriptionLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-20.0];
    [self.itemDescriptionLabel autoSetDimension:ALDimensionHeight toSize:50.0].priority = UILayoutPriorityDefaultLow;
    NSMutableParagraphStyle *paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraph.alignment = NSTextAlignmentJustified | NSTextAlignmentLeft;
    paragraph.lineSpacing = 5.0f;
    paragraph.hyphenationFactor = 0.5f;
    self.itemDescriptionLabel.attributes = @{NSFontAttributeName : [UIFont fontWithName:GOTHAM_LIGHT size:15],
                                             NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:0.9],
                                             NSParagraphStyleAttributeName : paragraph };
    self.itemDescriptionLabel.numberOfLines = 0;
    self.itemDescriptionLabel.preferredMaxLayoutWidth = 280.0f;
    [self.itemDescriptionLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self.itemDescriptionLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

-(void)createItemRatingView
{
    
}

-(void)setName:(NSString *)name
{
    [self.itemNameLabel setTextWithExistingAttributes:name];
    [self.itemNameLabel sizeToFit];
}

-(void)setDescription:(NSString *)description
{
    [self.itemDescriptionLabel setTextWithExistingAttributes:description];
}

-(void)setPrice:(NSString *)price
{
    if(price.length)
    [self.itemPriceLabel setTextWithExistingAttributes:price];
}
@end
