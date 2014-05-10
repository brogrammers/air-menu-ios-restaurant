//
//  AMMenuCell+ModelExtension.h
//  Air Menu
//
//  Created by Robert Lis on 10/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMMenuCell.h"
#import "AMDataAwareReusableView.h"

@interface AMMenuCell (ModelExtension) <AMDataAwareReusableView>
-(void)displayData:(id)item atIndexPath:(NSIndexPath *)indexPath;
@end
