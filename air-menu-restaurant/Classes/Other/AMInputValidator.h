//
//  AMInputValidator.h
//  Air Menu
//
//  Created by Robert Lis on 08/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMInputValidator : NSObject
-(BOOL)validate:(NSString *)string;
@end

@interface AMChainedInputValidator : AMInputValidator
@property (nonatomic, readonly, strong) AMInputValidator *next;
+(id)withNext:(AMInputValidator *)nextValidator;
@end

typedef BOOL (^InputValidationBlock) (NSString * input);
@interface AMBlockInputValidator : AMChainedInputValidator
@property (nonatomic, readonly,strong) InputValidationBlock validationBlock;
+(id)withBlock:(InputValidationBlock)block next:(AMInputValidator *)nextValidator;
@end
