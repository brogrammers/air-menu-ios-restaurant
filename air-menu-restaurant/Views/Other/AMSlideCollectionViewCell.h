//
//  AMSlideCollectionViewCell.h
//  Air Menu
//
//  Created by Robert Lis on 30/04/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "JCRSlideCollectionViewCell.h"

@interface AMSlideCollectionViewCell : JCRSlideCollectionViewCell <UIScrollViewDelegate>
-(void)restoreState;
@end
