//
//  AMDataSource.h
//  Air Menu
//
//  Created by Robert Lis on 03/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMDataSource;
@protocol AMDataSourceAdapter <NSObject>
@optional
@property (nonatomic, readwrite, weak) AMDataSource *dataSource;
-(void)adaptView:(UIView *)view;
-(void)refreshView:(UIView *)view oldData:(id)oldData;
@end

typedef void (^Done)(id data);
typedef void (^DataRetreivalBlock)(Done block);

@interface AMDataSource : NSObject
@property (nonatomic, readonly, weak) UIView *dataDestination;
@property (nonatomic, readonly, strong) id <AMDataSourceAdapter> dataAdapter;
@property (nonatomic, readonly, strong) id data;
@property (nonatomic, readonly) DataRetreivalBlock block;
+(NSDictionary *)adapters;
+(id)withBlock:(DataRetreivalBlock)block destination:(UIView *)destination;
+(id)withBlock:(DataRetreivalBlock)block destination:(UIView *)destination adapter:(id <AMDataSourceAdapter>)adapter;
-(id)initWithBlock:(DataRetreivalBlock)block destination:(UIView *)destination adapter:(id <AMDataSourceAdapter>)adapter;
-(void)refresh;
@end
