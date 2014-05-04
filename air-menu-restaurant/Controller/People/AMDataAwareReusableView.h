//
//  AMDataAwareReusableView.h
//  Air Menu
//
//  Created by Robert Lis on 04/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMDataAwareReusableView <NSObject>
@optional
-(void)displayData:(id)item
       atIndexPath:(NSIndexPath *)indexPath;
@end
