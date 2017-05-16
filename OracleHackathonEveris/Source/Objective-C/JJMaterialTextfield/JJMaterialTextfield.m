//
//  CustomLabel.m
//  rointe
//
//  Created by Juanjo Guevara on 22/5/15.
//  Copyright (c) 2015 Juanjo Guevara. All rights reserved.
//

#import "JJMaterialTextfield.h"
#import "UIColor+HexColor.h"

#define widthIconleft    16
#define heightIconleft   21
#define kMARGINLABELERRORLeft 30
#define kMARGINLABELTOP  7

#define colourOff           @"727FA5"

@interface JJMaterialTextfield ()
{
    UIImage *imageEmpty;
    UIImage *imageActive;
    
    UIImageView *iconLeft;
    NSAttributedString *notSelectedPlaceholder;
    UIFont *placeUpFont;
    NSString *colorPhUp;
    NSString *texColor;
    BOOL showError;
    BOOL upPlaceHolder;
    BOOL isImage;
    BOOL isError;
    BOOL isLineUp;
}
@end

@implementation JJMaterialTextfield
@synthesize errorColor,lineColor, lineBackGround;

#define DEFAULT_ALPHA_LINE 0.5

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}


-(void) initTextfieldWithPlaceholder:(NSString*)placeHolder iconActive:(UIImage*)iconActive iconEmpty:(UIImage *)iconEmpty textColor:(NSString *)textColor withFont:(UIFont*)textFont lineColor:(UIColor *)linColor withLineBack:(UIColor*)linBack errorColor:(UIColor*)errColor upPlaceHolder:(BOOL)upPH withImage:(BOOL)isThereImage andError:(BOOL)isThereError andIsLineUp: (BOOL)isThereLineUp phColor:(NSString*)phColor andFontForPhUp:(UIFont*)phUpFont{
    //Init boolean
    upPlaceHolder = upPH;
    
    //Set icon active and empty
    colorPhUp =phColor;
    placeUpFont = [self checkFontSize:phUpFont];
    imageActive = iconActive;
    imageEmpty = iconEmpty;
    isError= isThereError;
    isImage=isThereImage;
    isLineUp=isThereLineUp;
    
    //Set colors
    [self setLineColor:linColor];
    [self setErrorColor:errColor];
    [self setTextColor:[UIColor colorWithHexString:textColor]];
    [self setLineBackGround:linBack];
    
    //Set style placeholders
    notSelectedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: [[UIColor colorWithHexString:phColor] colorWithAlphaComponent:1],NSFontAttributeName: [self checkFontSize:textFont]}];
    
    self.attributedPlaceholder = notSelectedPlaceholder;
    
    //Set style text texfield
    self.font = [self checkFontSize:textFont];
    
    [self commonInit];
}

- (void)commonInit
{
    //self.tintColor=[UIColor colorWithRed:0.482 green:0.800 blue:1.000 alpha:1.000];
    self.backgroundColor = [UIColor clearColor];
    
    self.enableMaterialPlaceHolder = YES;
    [self setEnableMaterialPlaceHolder:self.enableMaterialPlaceHolder];
    self.returnKeyType=UIReturnKeyNext;
    self.clipsToBounds = NO;
    self.tag=1;
    
    //Create subLine
    self.line = [[UIView alloc] init];
    //Initial colour
    self.line.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    //Create left icon
    if(isImage){
        iconLeft = [[UIImageView alloc] initWithImage:imageEmpty];
        [iconLeft setContentMode:UIViewContentModeScaleAspectFill];
        [iconLeft setFrame:CGRectMake(2, 0, widthIconleft, heightIconleft)];
    }
    
    //create icon delete
    _buttonDelete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [_buttonDelete setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 10, 10)];
    [_buttonDelete setImage:[UIImage imageNamed:@"ico_cerrar_2"] forState:UIControlStateNormal];    //Set state initial button delete
    [_buttonDelete setHidden:TRUE];
    
    //Create label error
    _errorLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    
    [_errorLabel setTextColor:[UIColor colorWithHexString:@"FF4F4E"]];
    [_errorLabel setFont:[self checkFontSize:[UIFont fontWithName:@"Geomanist-WZ-Light" size:11.0]]];
    [_errorLabel setNumberOfLines:0];
    [_errorLabel setText:@"Error por favor repita la operación si desea continuar con el proceso."];
    [_errorLabel sizeToFit];
    [_errorLabel setHidden:YES];
    CGSize textViewSize = [_errorLabel sizeThatFits:CGSizeMake(_errorLabel.frame.size.width, FLT_MAX)];
    [_errorLabel setFrame: CGRectMake(_errorLabel.frame.origin.x, _errorLabel.frame.origin.y, _errorLabel.frame.size.width, textViewSize.height)] ;
    
    
    [_placeHolderLabel setHidden:YES];  
    
    //Add image to textfield
    [self addSubview:_errorLabel];
    [self addSubview:self.line];
    [self addSubview:iconLeft];
    [self addSubview:_buttonDelete];
    
    //add target when change text
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_buttonDelete addTarget:self action:@selector(buttonDeleteX) forControlEvents:UIControlEventTouchUpInside];
}


-(void)buttonDeleteX{
    self.text = @"";
    [self textFieldDidChange:nil];
    if([self.delegate respondsToSelector:@selector(buttonDeletePressed:)]){
        [self.delegateJJ buttonDeletePressed:self];
    }
    if(![self.errorLabel isHidden]){
        [self hideError];
    }
}

- (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}



- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textFieldDidChange:self];
}

- (IBAction)textFieldDidChange:(id)sender
{
    if (self.enableMaterialPlaceHolder) {
        
        if (!self.text || self.text.length > 0) {
            _placeHolderLabel.alpha = 1;
            self.line.alpha=1;
            //self.attributedPlaceholder = nil;
        }else{
            self.line.alpha=0.5;
        }
//        else {
//            self.attributedPlaceholder = nil;
//        }
        
        CGFloat duration = 0.5;
        CGFloat delay = 0;
        CGFloat damping = 0.6;
        CGFloat velocity = 1;
        
        [UIView animateWithDuration:duration
                              delay:delay
             usingSpringWithDamping:damping
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{

                                if (!self.text || self.text.length <= 0) {
                                    if(upPlaceHolder){
                                        _placeHolderLabel.transform = CGAffineTransformIdentity;
                                        [_placeHolderLabel setHidden:YES];
                                        //self.attributedPlaceholder=notSelectedPlaceholder;
                                    }else{
                                        [_placeHolderLabel setHidden:TRUE];
                                    }
                                    
                                    [iconLeft setImage:imageEmpty];
                                    
                                    self.line.backgroundColor = self.line.backgroundColor;
                                    
                                    if(!_buttonDelete.hidden){
                                        [_buttonDelete setHidden:TRUE];
                                    }
                                }
                                else {
                                    [iconLeft setImage:imageActive];
                                    
                                    if(upPlaceHolder){
                                        _placeHolderLabel.transform = CGAffineTransformMakeTranslation(0, -_placeHolderLabel.frame.size.height - 8);
                                         [_placeHolderLabel setHidden:NO];
                                        //self.attributedPlaceholder=selectedPlaceholder;
                                        _placeHolderLabel.textColor=[UIColor colorWithHexString:colorPhUp];
                                        _placeHolderLabel.font = placeUpFont;
                                        
                                    }else{
                                        [_placeHolderLabel setHidden:TRUE];
                                    }
                                    self.line.backgroundColor = lineBackGround;
                                    
                                    if(_buttonDelete.hidden && ![self.placeHolderLabel.text isEqual:NSLocalizedString(@"PRF_ROAD_TYPE", @"PRF_ROAD_TYPE")]){
                                        [_buttonDelete setHidden:FALSE];
                                        if([self.placeHolderLabel.text isEqual:NSLocalizedString(@"PRF_COUNTRY_TITLE", @"PRF_COUNTRY_TITLE")]){
                                            [_buttonDelete setHidden:TRUE];
                                        }
                                    }
                                }
                                
                            }
                         completion:^(BOOL finished) {
                             
                         }];
       
    }
}

-(IBAction)clearAction:(id)sender
{
    self.text = @"";
    [self textFieldDidChange:self];
}

-(void)setButtonDeleteImage:(UIImage*)image{
    [_buttonDelete setImage:image forState:UIControlStateNormal];
}

-(void)highlight
{
    
    [UIView animateWithDuration: 0.3 // duración
                          delay: 0 // sin retardo antes de comenzar
                        options: UIViewAnimationOptionCurveEaseInOut //opciones
                     animations:^{
                         
                         if (showError) {
                             self.line.backgroundColor=errorColor;
                         //}else if(){
                             
                         }
                         else {
                             self.line.backgroundColor = lineBackGround;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             //finalizacion
                         }
                     }];
    
}

-(void)unhighlight
{
    [UIView animateWithDuration: 0.3 // duración
                          delay: 0 // sin retardo antes de comenzar
                        options: UIViewAnimationOptionCurveEaseInOut //opciones
                     animations:^{
                         
                         if (showError) {
                             self.line.backgroundColor = errorColor;
                         }
                         else {
                             //Check if textfield is empty
                             if(self.text.length == 0){
                                 self.line.backgroundColor = [UIColor colorWithHexString:colourOff];
                             }else{
                                 self.line.backgroundColor = lineColor;
                             }
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             //finalizacion
                         }
                     }];

  }

- (void)setPlaceholderAttributes:(NSDictionary *)placeholderAttributes
{
    _placeholderAttributes = placeholderAttributes;
    [self setPlaceholder:self.placeholder];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    
    NSDictionary *atts = @{NSForegroundColorAttributeName: [self.textColor colorWithAlphaComponent:0.0],
                           NSFontAttributeName : [self.font fontWithSize: self.font.pointSize]};
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder ?: @"" attributes: self.placeholderAttributes ?: atts];
    [self setEnableMaterialPlaceHolder:self.enableMaterialPlaceHolder];
}

- (void)setEnableMaterialPlaceHolder:(BOOL)enableMaterialPlaceHolder
{
    _enableMaterialPlaceHolder = enableMaterialPlaceHolder;
    if (!_placeHolderLabel && (isImage)) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 2, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_placeHolderLabel];
    }else if (!_placeHolderLabel && !(isImage)){
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_placeHolderLabel];
    }else if (!upPlaceHolder){
        [_placeHolderLabel setHidden:YES];
    }
    //placeHolderLabel.alpha = 1;
    _placeHolderLabel.attributedText = self.attributedPlaceholder;
    [_placeHolderLabel sizeThatFits:CGSizeMake(self.frame.size.width , self.frame.size.height)];
    
}

- (BOOL)becomeFirstResponder
{
    BOOL returnValue = [super becomeFirstResponder];
    
    [self highlight];
    
    return returnValue;
}

- (BOOL)resignFirstResponder
{
    BOOL returnValue = [super resignFirstResponder];
   
    [self unhighlight];
    
    return returnValue;
}

- (void)showErrorWithText:(NSString*)errorText
{
    showError = YES;
    self.line.backgroundColor = errorColor;
    
    if(errorText){
        _errorLabel.text=errorText;
        [_errorLabel setHidden:NO];
    }
    
}

- (void)hideError
{
    if(!_isSpecialCase){
        showError = NO;
        self.line.backgroundColor = lineColor;
        [_errorLabel setHidden:YES];
        _isSpecialCase=NO;
    }
}
-(void)changeErrorColor:(UIColor*)color{
    [_errorLabel setTextColor:color];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(isLineUp){
        self.line.frame = CGRectMake(0, self.frame.size.height-10, self.frame.size.width, 1);
    }else{
        self.line.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    }
    if([self isFirstResponder]){
        [self.line setAlpha:1];
    }else{
        [self.line setAlpha:0.3];
    }
    
    _buttonDelete.frame = CGRectMake(self.frame.size.width - 45, -10, _buttonDelete.frame.size.width, _buttonDelete.frame.size.height);
    if(isImage){
        self.errorLabel.frame = CGRectMake(kMARGINLABELERRORLeft, self.line.frame.origin.y+self.line.frame.size.height + kMARGINLABELTOP, _errorLabel.frame.size.width, _errorLabel.frame.size.height);
    }else{
        self.errorLabel.frame = CGRectMake(0, self.line.frame.origin.y+self.line.frame.size.height + kMARGINLABELTOP, _errorLabel.frame.size.width, _errorLabel.frame.size.height);
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if(isImage){
        return CGRectMake(bounds.origin.x + 30, bounds.origin.y + 2,
                          bounds.size.width - 50, bounds.size.height - 15);
    }else{
        if([self.placeholder isEqualToString:@"Cantidad que quieres compartir"]){
                return CGRectMake(bounds.origin.x, bounds.origin.y,
                                  bounds.size.width, bounds.size.height);
        }else{
            return CGRectMake(bounds.origin.x, bounds.origin.y + 2,
                      bounds.size.width - 50, bounds.size.height - 15);
        }
    }
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

-(UIFont *) checkFontSize:(UIFont*)font{
    
    return font;
}

@end
