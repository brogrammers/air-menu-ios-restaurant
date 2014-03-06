//
//  AMActionCell.h
//  air-menu-restaurant
//
//  Created by Robert Lis on 06/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMActionCell;
@protocol AMActionCellDelegate <NSObject>
-(void)didSelectAction:(NSString *)action onCell:(AMActionCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@interface AMActionCell : UITableViewCell
@property (nonatomic, readonly, weak) id <AMActionCellDelegate> delegate;
@property (nonatomic, readonly, strong) NSIndexPath *indexPath;
-(void)setActions:(NSArray *)actions withFonts:(NSArray *)fonts andColors:(NSArray *)colors;
@end
