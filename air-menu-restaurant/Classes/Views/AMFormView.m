//
//  AMFormView.m
//  air-menu-restaurant
//
//  Created by Robert Lis on 07/03/2014.
//  Copyright (c) 2014 Air-menu. All rights reserved.
//

#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import <UIView+AutoLayout/UIView+AutoLayout.h>
#import "AMFormView.h"
#import "AMAppDelegate.h"
#import "AMFloatingTextField.h"

#pragma mark - Helper category to find first responder

@interface UIView(FindFirstResponder)
- (UIView*)getFirstResponder;
@end

@implementation UIView (FindFirstResponder)
- (UIView*)getFirstResponder
{
    if (self.isFirstResponder)
    {
        return self;
    }
    
    for (UIView *subview in self.subviews)
    {
        UIView *responder = [subview getFirstResponder];
        if (responder)
        {
            return responder;
        }
    }
    
    return nil;
}
@end

#pragma mark - Form View Section

@implementation AMFormViewSection

+(AMFormViewSection *)withRows:(NSArray *)rows
{
    return [self withName:@"" rows:rows];
}

+(AMFormViewSection *)withName:(NSString *)name rows:(NSArray *)rows
{
    return [[self alloc] initWithName:name rows:rows];
}

-(id)initWithName:(NSString *)name rows:(NSArray *)rows
{
    self = [super init];
    if(self)
    {
        _name = name;
        _rows = rows;
    }
    return self;
}
@end


#pragma mark - Form View Row
@implementation AMFormViewRow

+(AMFormViewRow *)withColumns:(NSArray *)columns
{
    return [[self alloc] initWithColumns:columns];
}

-(id)initWithColumns:(NSArray *)columns
{
    self = [super init];
    if(self)
    {
        _columns = columns;
    }
    return self;
}
@end

#pragma mark - Form View Column

@implementation AMFormViewRowColumn

+(AMFormViewRowColumn *)withName:(NSString *)name
{
    return [self withName:name validator:nil];
}

+(AMFormViewRowColumn *)withName:(NSString *)name validator:(AMInputValidator *)validator
{
    return [self withName:name validator:validator keyboardType:UIKeyboardTypeDefault];
}
+(AMFormViewRowColumn *)withName:(NSString *)name validator:(AMInputValidator *)validator keyboardType:(UIKeyboardType)type
{
    return [[self alloc] initWithName:name keyboardType:type style:AMFormViewRowColumnStyleField lineCount:1 inputValidator:validator];
}

+(AMFormViewRowColumn *)withName:(NSString *)name
                    keyboardType:(UIKeyboardType)type
                           style:(AMFormViewRowColumnStyle)style
                       lineCount:(NSUInteger )count
                  inputValidator:(AMInputValidator *)validator
{
    return [[self alloc] initWithName:name keyboardType:type style:style lineCount:count inputValidator:validator];
}

-(id)initWithName:(NSString *)name
     keyboardType:(UIKeyboardType)type
            style:(AMFormViewRowColumnStyle)style
        lineCount:(NSUInteger )count
   inputValidator:(AMInputValidator *)validator
{
    self = [super init];
    if(self)
    {
        _name = name;
        _type = type;
        _style = style;
        _lineCount = count;
        _validator = validator;
    }
    return self;
}

-(BOOL)isValid
{
    return [self.validator validate:self.userInput];
}

-(void)showError
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didDetectErrorOnTextField"
                                                        object:self
                                                      userInfo:nil];
}
@end

#pragma mark - JVFloatLabeledTextField cell that distributes text fields

@interface AMFormFieldTableViewCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, readwrite, strong) AMFormViewRow *row;
@property (nonatomic, readwrite, strong) NSIndexPath *indexPath;
@property (nonatomic, readwrite, strong) NSIndexPath *lastIndexPath;
@end

@implementation AMFormFieldTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showError:)
                                                     name:@"didDetectErrorOnTextField"
                                                   object:nil];
    }
    return self;
}

-(void)showError:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUInteger index = [self.row.columns indexOfObject:notification.object];
        if(index != NSNotFound)
        {
            AMFloatingTextField *field = self.contentView.subviews[index];
            CAKeyframeAnimation * anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)], [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)]] ;
            anim.autoreverses = YES;
            anim.repeatCount = 2.0f;
            anim.duration = 0.07f;
            [field.layer addAnimation:anim forKey:nil];
        }
    });
}

-(void)setRow:(AMFormViewRow *)row
{
    _row = row;
    [self clearOldFields];
    [self addNewFields:row.columns];
}

-(void)clearOldFields
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)addNewFields:(NSArray *)fields
{
    NSUInteger index = 0;
    for (AMFormViewRowColumn *field in fields)
    {
        AMFloatingTextField *textField = [AMFloatingTextField newAutoLayoutView];
        NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0]};
        textField.textColor = [UIColor whiteColor];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:field.name attributes:placeholderAttributes];
        textField.font = [UIFont fontWithName:GOTHAM_LIGHT size:20];
        textField.floatingLabelYPadding = @(4);
        textField.floatingLabel.font = [UIFont fontWithName:GOTHAM_BOOK size:12];
        textField.floatingLabel.text = field.name;
        textField.floatingLabelTextColor = [UIColor colorWithRed:1.0f/255.0f green:57.0f/255.0f blue:83.0f/255.0f alpha:1.0];
        [self.contentView addSubview:textField];
        textField.delegate = self;
        textField.index = index++;
    }
    
    //layout
    if(self.contentView.subviews.count > 1)
    {
        [self.contentView.subviews autoDistributeViewsAlongAxis:ALAxisHorizontal withFixedSpacing:2 alignment:NSLayoutFormatAlignAllBottom];
        [[self.contentView.constraints firstObject] setConstant:0];
        [[self.contentView.constraints lastObject] setConstant:0];
        [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0];
            [view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-1];
        }];
    }
    else
    {
        [self.contentView.subviews[0] autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 0, 1, 0)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(AMFloatingTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.row.columns[textField.index] setValue:newString forKey:@"userInput"];
    return YES;
}

-(void)drawRect:(CGRect)rect
{
    [[[UIColor whiteColor] colorWithAlphaComponent:0.1] setFill];
    CGRect rectToDraw = CGRectMake(0, 1, rect.size.width, rect.size.height - 2);
    
    if(self.indexPath.row == 0)
    {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rectToDraw
                                                         byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                               cornerRadii:CGSizeMake(10, 10)];
        [bezierPath fill];
    }
    else if(self.indexPath.row == self.lastIndexPath.row - 1)
    {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rectToDraw
                                                         byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                               cornerRadii:CGSizeMake(10, 10)];
        [bezierPath fill];
    }
    else
    {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rectToDraw];
        [bezierPath fill];
    } 
}
@end

#pragma mark - Form view that uses a table view to display rows of input

@interface AMFormView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, readwrite, weak) UITableView *tableView;
@property (nonatomic, readwrite, strong) NSArray *sections;
@end

@implementation AMFormView

-(id)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    [self setupTableView];
    self.bounces = YES;
    self.showsVerticalScrollIndicator = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *tappedView = [self getFirstResponder];
        
        if(tappedView)
        {
            CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGRect convertedRect = [self convertRect:keyboardRect fromView:((AMAppDelegate *)[UIApplication sharedApplication].delegate).window];
            CGRect intersection = CGRectIntersection(self.bounds, convertedRect);
            
            CGRect tappedViewRect = tappedView.frame;
            CGRect tappedViewRectConverted = [self convertRect:tappedViewRect fromView:tappedView];
            CGRect tappedViewKeyboardIntersection = CGRectIntersection(tappedViewRectConverted, convertedRect);
            if (tappedViewKeyboardIntersection.origin.x != INFINITY && tappedViewKeyboardIntersection.origin.y != INFINITY)
            {
                [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]
                                      delay:0.0
                                    options:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]
                                 animations:^{
                                     [self setContentOffset:CGPointMake(0, self.contentOffset.y + (fabs(tappedViewRectConverted.origin.y - (convertedRect.size.height - tappedViewRectConverted.size.height - 17)))) animated:YES];
                                     self.contentInset = UIEdgeInsetsMake(0, 0, intersection.size.height + 2, 0);
                                 }
                                 completion:nil];

            }
            else
            {
                self.contentInset = UIEdgeInsetsMake(0, 0, intersection.size.height + 2, 0);
            }
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }
    });
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]
                     animations:^{
                         self.contentInset = UIEdgeInsetsZero;
                         self.contentOffset = CGPointZero;
                     }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


-(void)setupTableView
{
    UITableView *tableView = [UITableView newAutoLayoutView];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self.tableView registerClass:[AMFormFieldTableViewCell class] forCellReuseIdentifier:@"field_cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [tableView autoCenterInSuperview];
    [tableView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:1.0];
    [tableView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:1.0];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.sections[section] rows].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMFormFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"field_cell" forIndexPath:indexPath];
    AMFormViewRow *row = [self.sections[indexPath.section] rows][indexPath.row];
    cell.row = row;
    cell.indexPath = indexPath;
    NSInteger numberOfSections = [self numberOfSectionsInTableView:self.tableView];
    NSInteger numberOfRowsInLastSection = [self tableView:self.tableView numberOfRowsInSection:numberOfSections - 1];
    cell.lastIndexPath = [NSIndexPath indexPathForRow:numberOfRowsInLastSection inSection:numberOfSections];
    return cell;
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20 + 35;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - Other
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if(!view)
    {
        UIView *firstRespodonder = [self getFirstResponder];
        [firstRespodonder resignFirstResponder];
    }
    return view;
}

-(void)layoutSubviews
{
    self.contentSize = self.tableView.contentSize;
    [super layoutSubviews];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
@end
