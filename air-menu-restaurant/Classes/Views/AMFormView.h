//
//  AMFormView.h
//  air-menu-restaurant
//
//  Created by Robert Lis on 07/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMInputValidator.h"

typedef NS_ENUM(NSUInteger, AMFormViewRowColumnStyle)
{
    AMFormViewRowColumnStyleView,
    AMFormViewRowColumnStyleField
};

@interface AMFormViewSection : NSObject
@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, strong) NSArray *rows;
+(AMFormViewSection *)withRows:(NSArray *)rows;
+(AMFormViewSection *)withName:(NSString *)name rows:(NSArray *)rows;
@end

@interface AMFormViewRow : NSObject
@property (nonatomic, readonly, strong) NSArray *columns;
+(AMFormViewRow *)withColumns:(NSArray *)columns;
@end

@interface AMFormViewRowColumn : NSObject
@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, strong) NSString *userInput;
@property (nonatomic, readonly) UIKeyboardType type;
@property (nonatomic, readonly) AMFormViewRowColumnStyle style;
@property (nonatomic, readonly) NSUInteger lineCount;
@property (nonatomic, readonly, strong) AMInputValidator *validator;

+(AMFormViewRowColumn *)withName:(NSString *)name;
+(AMFormViewRowColumn *)withName:(NSString *)name validator:(AMInputValidator *)validator;
+(AMFormViewRowColumn *)withName:(NSString *)name validator:(AMInputValidator *)validator keyboardType:(UIKeyboardType)type;
+(AMFormViewRowColumn *)withName:(NSString *)name
              keyboardType:(UIKeyboardType)type
                     style:(AMFormViewRowColumnStyle)style
                 lineCount:(NSUInteger )count
            inputValidator:(AMInputValidator *)validator;
-(BOOL)isValid;
-(void)showError;
@end

@protocol AMFormViewDelegate <NSObject>
-(void)didFinishEditing:(AMFormViewRow *)row;
@end

@interface AMFormView : UIView
-(void)setSections:(NSArray *)sections;
@end
