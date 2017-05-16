//
//  CustomLabel.h
//  rointe
//
//  Created by Juanjo Guevara on 22/5/15.
//  Copyright (c) 2015 Juanjo Guevara. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JJTextFieldDelegate <NSObject>

@optional
-(void) buttonDeletePressed:(nonnull UITextField*)textField;

@end
@interface JJMaterialTextfield : UITextField

/**
 *  Attributes that are optionally applied to the placeholder text. Use this to style the placeholder differently than the regular text. Default is nil (meaning no additional styling will be applied to the placeholder. If nil, the placeholder will be styled the same as the textfield except its color will be a 0.8 alpha version of the textfield text color.
 */
@property (nonatomic, strong, nullable) NSDictionary *placeholderAttributes;

/**
 *  The color of the line when there is an error.
 */
@property (nonatomic, strong, nullable) UIColor *errorColor;

@property (nonatomic, strong, nullable) UILabel *errorLabel;

@property (nonatomic, strong,nullable) UILabel *placeHolderLabel;

/**
 *  The color of the line when the textfield is active.  Default is [UIColor lightGrayColor];
 */
@property (nonatomic, strong, nullable) UIColor *lineColor;

@property (nonatomic, strong, nullable) UIColor *lineBackGround;

@property (nonatomic, strong, nullable) UIView *line;

@property (nonatomic, weak, nullable) id<JJTextFieldDelegate>delegateJJ;

@property (nonatomic, strong, nullable) UIButton *buttonDelete;
/**
 *  Shows an error - makes the line the error color.
 */
- (void)showErrorWithText:(nullable NSString*)errorText;

/**
 *  Hides the error. Returns the line to normal.
 */
- (void)hideError;

-(void)changeErrorColor:(nullable UIColor*)color;
/**
 *  Enables or disables the material placeholder (the placeholder jumping above the textfield on text entry). Default is YES.
 */
- (void)selectTextForInput:(nullable UITextField *)input atRange:(NSRange)range ;

@property (nonatomic) IBInspectable BOOL enableMaterialPlaceHolder;

@property (nonatomic)  BOOL isSpecialCase;
/**
 *  init textfield component
 */
-(void) initTextfieldWithPlaceholder:(nullable NSString*)placeHolder iconActive:(nullable UIImage*)iconActive iconEmpty:(nullable UIImage *)iconEmpty textColor:(nullable NSString *)textColor withFont:(nullable UIFont*)textFont lineColor:(nullable UIColor *)linColor withLineBack:(nullable UIColor*)linBack errorColor:(nullable UIColor*)errColor upPlaceHolder:(BOOL)upPH withImage:(BOOL)isThereImage andError:(BOOL)isThereError andIsLineUp: (BOOL)isThereLineUp phColor:(nullable NSString*)phColor andFontForPhUp:(nullable UIFont*)phUpFont;


-(void)setButtonDeleteImage:(nonnull UIImage*)image;

@end
