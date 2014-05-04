//
//  AMDataSource.m
//  Air Menu
//
//  Created by Robert Lis on 03/05/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMDataSource.h"
#import "AMCollectionViewAdapter.h"

@implementation AMDataSource

+(NSDictionary *)adapters
{
    return @{NSStringFromClass([UICollectionView class]) : [AMCollectionViewAdapter class]};
}

+(id)withBlock:(DataRetreivalBlock)block destination:(UIView *)destination
{
    return [self withBlock:block destination:destination adapter:nil];
}

+(id)withBlock:(DataRetreivalBlock)block destination:(UIView *)destination adapter:(id <AMDataSourceAdapter>)adapter
{
    AMDataSource *dataSource = [[AMDataSource alloc] initWithBlock:block destination:destination adapter:adapter];
    return dataSource;
}

-(id)initWithBlock:(DataRetreivalBlock)block destination:(UIView *)destination adapter:(id <AMDataSourceAdapter>)adapter;
{
    NSAssert(destination, @"destination view must not be nil");
    self = [super init];
    if(self)
    {
        _block = block;
        _dataDestination = destination;
        _dataAdapter = adapter;
        [self configureAdapter];
        [self getData];
    }
    return self;
}

-(void)refresh
{
    [self getData];
}

-(void)configureAdapter
{
    if(!_dataAdapter)
    {
        [self chooseAdapter];
    }
    
    if([_dataAdapter respondsToSelector:@selector(setDataSource:)])
    {
        [_dataAdapter setDataSource:self];
    }
    
    if([_dataAdapter respondsToSelector:@selector(adaptView:)])
    {
        [_dataAdapter adaptView:self.dataDestination];
    }
}

-(void)getData
{
    if (self.block)
    {
        self.block(^(id data){
            [self processData:data];
        });
    }
}

-(void)chooseAdapter
{
    Class adapterClass =  [self.class adapters][NSStringFromClass(self.dataDestination.class)];
    NSAssert(adapterClass, @"no adapter for destination view");
    _dataAdapter = [[adapterClass alloc] init];
}

-(void)processData:(id)data
{
    _data = data;
    if([_dataAdapter respondsToSelector:@selector(refreshView:)])
    {
        [self.dataAdapter refreshView:self.dataDestination];
    }
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL doIRespond = [super respondsToSelector:aSelector];
    BOOL doesAdapterRespond = [_dataAdapter respondsToSelector:aSelector];
    return doIRespond || doesAdapterRespond;
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    return [_dataAdapter respondsToSelector:aSelector] ? _dataAdapter : nil;
}

@end
