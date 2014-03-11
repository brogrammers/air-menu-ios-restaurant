//
//  AMInputValidator.m
//  Air Menu
//
//  Created by Robert Lis on 08/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import "AMInputValidator.h"

@interface AMChainedInputValidator()
@property (nonatomic, readwrite, strong) AMInputValidator *next;
@end

@interface AMBlockInputValidator()
@property (nonatomic, readwrite,strong) InputValidationBlock validationBlock;
@end

@implementation AMInputValidator
-(BOOL)validate:(NSString *)string
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"AMInputValidator is a abstract class"
                                 userInfo:nil];
}
@end

@implementation AMChainedInputValidator
+(id)withNext:(AMInputValidator *)nextValidator
{
    AMChainedInputValidator *validator = [[AMChainedInputValidator alloc] init];
    validator.next = nextValidator;
    return validator;
}

-(BOOL)validate:(NSString *)string
{
    if(self.next)
    {
        return [self.next validate:string];
    }
    else
    {
        return YES;
    }
}
@end

@implementation AMBlockInputValidator
+(id)withBlock:(InputValidationBlock)block next:(AMInputValidator *)nextValidator
{
    NSAssert(block, @"Validation block must be present");
    AMBlockInputValidator *validator = [[AMBlockInputValidator alloc] init];
    validator.validationBlock = block;
    validator.next = nextValidator;
    return validator;
}

-(BOOL)validate:(NSString *)string
{
    if(self.validationBlock)
    {
        return self.validationBlock(string) && [super validate:string];
    }
    else
    {
        return [super validate:string];
    }
}
@end
