//
//  AMStaffMemberCell.m
//  Air Menu
//
//  Created by Robert Lis on 30/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMStaffMemberCell.h"
#import "UILabel+AttributesCopy.h"

@interface AMStaffMemberCell()
@property (nonatomic, readwrite, weak) UIImageView *memberPhoto;
@property (nonatomic, readwrite, weak) UILabel *memberName;
@end

@implementation AMStaffMemberCell

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
    [self setupPhoto];
    [self setupName];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

-(void)setupPhoto
{
    UIImageView *memberPhoto = [UIImageView newAutoLayoutView];
    self.memberPhoto = memberPhoto;
    [self.contentView addSubview:self.memberPhoto];
    [self.memberPhoto autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:20.0f];
    [self.memberPhoto autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
    [self.memberPhoto autoSetDimensionsToSize:CGSizeMake(50, 50)];
    self.memberPhoto.layer.cornerRadius = 25.0f;
    self.memberPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    self.memberPhoto.layer.borderWidth = 2.0f;
}

-(void)setupName
{
    UILabel *memberName = [UILabel newAutoLayoutView];
    self.memberName = memberName;
    [self.contentView addSubview:self.memberName];
    [self.memberName autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.memberPhoto withOffset:20.0];
    [self.memberName autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
    self.memberName.attributes = @{ NSFontAttributeName : [UIFont fontWithName:GOTHAM_BOOK size:17.0f],
                                    NSForegroundColorAttributeName : [UIColor whiteColor] };
}
@end
