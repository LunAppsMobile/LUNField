//
//  LUN_RectangleField.m
//  LUNFields
//
//  Created by Vladimir Sharavara on 1/8/16.
//  Copyright © 2016 gmgroup. All rights reserved.
//

#import "LUNField.h"


static const CGFloat kLUNDefaultMarginBetweenTextFields = 4.0f;

@interface UIColor (LUNDefaultColors)

+ (UIColor *)LUNDefaultBorderColor;
+ (UIColor *)LUNDefaultUpperBorderColor;
+ (UIColor *)LUNDefaultUpperPlaceholderFontColor;
+ (UIColor *)LUNDefaultTintColor;
+ (UIColor *)LUNDefaultPlaceholderFontColor;
+ (UIColor *)LUNDefaultTextFontColor;
+ (UIColor *)LUNDefaultUnderliningColor;

@end

@implementation UIColor (LUNDefaultColors)

+ (UIColor *)LUNDefaultBorderColor {
    return [UIColor colorWithRed:156.0f / 255.0f green:168.0f / 255.0f blue:173.0f / 255.0f alpha:1];
}

+ (UIColor *)LUNDefaultUpperBorderColor {
    return [UIColor colorWithRed:180.0f / 255.0f green:180.0f / 255.0f blue:180.0f / 255.0f alpha:1];
}

+ (UIColor *)LUNDefaultUpperPlaceholderFontColor {
    return [UIColor colorWithRed:180.0f / 255.0f green:180.0f / 255.0f blue:180.0f / 255.0f alpha:1];
}

+ (UIColor *)LUNDefaultTintColor {
    return [UIColor colorWithRed:0.0f / 255.0f green:122.0f / 255.0f blue:255.0f / 255.0f alpha:1];
}

+ (UIColor *)LUNDefaultPlaceholderFontColor {
    return [UIColor colorWithRed:80.0f / 255.0f green:80.0f / 255.0f blue:80.0f / 255.0f alpha:1];
}

+ (UIColor *)LUNDefaultTextFontColor {
    return [UIColor colorWithRed:80.0f / 255.0f green:80.0f / 255.0f blue:80.0f / 255.0f alpha:1];
}

+ (UIColor *)LUNDefaultUnderliningColor {
    return [UIColor colorWithRed:180.0f / 255.0f green:180.0f / 255.0f blue:180.0f / 255.0f alpha:1];
}

@end

@interface LUNTextFieldWithTextInsets : UITextField

@end

@implementation LUNTextFieldWithTextInsets

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (self.leftView) {
        return CGRectInset(bounds, self.leftView.frame.size.width + kLUNDefaultMarginBetweenTextFields, 0);
    }
    return CGRectInset(bounds, kLUNDefaultMarginBetweenTextFields, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.leftView) {
        return CGRectInset(bounds, self.leftView.frame.size.width + kLUNDefaultMarginBetweenTextFields, 0);
    }
    return CGRectInset(bounds, kLUNDefaultMarginBetweenTextFields, 0);
}

@end


@interface LUNField () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView *placeholderImageView;
@property (strong, nonatomic) UIImageView *stateImageView;
@property (strong, nonatomic) NSMutableArray<UITextField *> *textFields;
@property (strong, nonatomic) NSLayoutConstraint *placeholderLabelTopConstraint;
@property (strong, nonatomic) NSLayoutConstraint *placeholderImageViewRightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *placeholderImageViewTopConstraint;
@property (strong, nonatomic) NSLayoutConstraint *stateImageViewTopConstraint;
@property (strong, nonatomic) NSLayoutConstraint *lineViewLeftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *lineViewRightConstraint;
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) BOOL isMultifield;

@end

@implementation LUNField

static const UIViewContentMode kLUNImageViewDefaultContentMode = UIViewContentModeScaleToFill;
static const CGFloat kLUNUpAnimationDuration = 0.9f;
static const CGFloat kLUNDownAnimationDuration = 0.35f;
static const CGFloat kLUNChangeStateAnimationDuration = 0.2f;
static const CGFloat kLUNScaleFactor = 0.75f;
static const CGFloat kLUNDamping = 0.5f;
static const CGFloat kLUNInitialVelocity = 0.0f;

#pragma mark init 

- (instancetype)init {
    if (self = [super init]) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonSetup];
    }
    return self;
}

#pragma mark Life cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL isEdited = NO;
    for (UITextField *textField in self.textFields) {
        if (textField.text.length > 0) {
            isEdited = YES;
            break;
        }
    }
    if (self.isEditing || isEdited) {
        self.placeholderLabelTopConstraint.constant = self.placeholderLabel.frame.size.height + 4;
        self.placeholderImageViewTopConstraint.constant = self.placeholderImageView.frame.size.height;
        self.stateImageViewTopConstraint.constant = -1 * (self.frame.size.height / 2 - self.stateImageView.frame.size.height / 2);
    } else {
        self.placeholderImageViewTopConstraint.constant = -1 * (self.frame.size.height / 2 - self.placeholderImageView.frame.size.height / 2);
        self.placeholderLabelTopConstraint.constant = -1 * (self.frame.size.height / 2 - self.placeholderLabel.frame.size.height / 2);
        self.stateImageViewTopConstraint.constant = -1 * (self.frame.size.height / 2 - self.stateImageView.frame.size.height / 2);
    }
    switch (self.placeholderAlignment) {
        case LUNPlaceholderAlignmentCenter: {
            self.placeholderLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case LUNPlaceholderAlignmentLeft: {
            self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case LUNPlaceholderAlignmentRight: {
            self.placeholderLabel.textAlignment = NSTextAlignmentRight;
        }
            break;
        default: {
            self.placeholderLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
    }
    [self layoutIfNeeded];
}

#pragma mark defaults

- (void)commonSetup {
    self.isEditing = NO;
    self.isMultifield = NO;
    _isCorrect = LUNUndefined;
    self.textFields = [[NSMutableArray alloc] init];
    self.borderColor = [UIColor LUNDefaultBorderColor];
    self.upperBorderColor = [UIColor LUNDefaultUpperBorderColor];
    self.upperPlaceholderFontColor = [UIColor LUNDefaultUpperPlaceholderFontColor];
    self.tintColor = [UIColor LUNDefaultTintColor];
    self.placeholderFontColor = [UIColor LUNDefaultPlaceholderFontColor];
    self.textFontColor = [UIColor LUNDefaultTextFontColor];
    self.underliningColor = [UIColor LUNDefaultUnderliningColor];
    self.borderWidth = 1.0f;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UITapGestureRecognizer *viewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self addGestureRecognizer:viewTapGestureRecognizer];
}

#pragma mark UITextFieldDelegate

- (void)textFieldTextChanged:(UITextField *)sender {
    NSInteger index = [self.textFields indexOfObject:sender];
    if (sender.text.length == [self.dataSource numberOfCharactersInSection:index inTextField:self]) {
        if (index < self.textFields.count - 1) {
            [self.textFields[index + 1] becomeFirstResponder];
        } else {
            [self validateInput];
        }
    }
    if (sender.text.length == 0) {
        if (index > 0) {
            [self.textFields[index - 1] becomeFirstResponder];
        }
    }
    if ([self.delegate respondsToSelector:@selector(LUNFieldTextChanged:)]) {
        [self.delegate LUNFieldTextChanged:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger index = [self.textFields indexOfObject:textField];
    if ([textField.text isEqualToString:@""] && [string isEqualToString:@""]) {
        if (index > 0) {
            [self.textFields[index - 1] becomeFirstResponder];
        }
    }
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (resultString.length > [self.dataSource numberOfCharactersInSection:index inTextField:self]) {
        if (index < self.textFields.count - 1) {
            [self.textFields[index + 1] becomeFirstResponder];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.isEditing = NO;
    BOOL isEdited = NO;
    for (UITextField *textField in self.textFields) {
        if (textField.text.length > 0) {
            isEdited = YES;
            break;
        }
    }
    if (!isEdited) {
        void (^underliningAnimation)() = ^void() {
            self.lineView.alpha = 1.0f;
            self.lineView.backgroundColor = self.borderColor ? self.borderColor : self.underliningColor;
        };
        
        void (^stateImageViewToPlaceholderImageViewAnimation)() = ^void() {
            self.stateImageView.alpha = 0.0f;
            self.placeholderImageView.alpha = 1.0f;
        };
        
        void (^placeHolderLabelAnimation)() = ^void() {
            self.placeholderLabel.textColor = self.placeholderFontColor;
            self.placeholderLabel.text = self.placeholderText;
            self.placeholderLabel.transform = CGAffineTransformIdentity;
            [self easeInOutView:self.placeholderLabel];
        };
        
        void (^borderAnimation)() = ^void() {
            for (UITextField *currentTextField in self.textFields) {
                currentTextField.layer.borderColor = self.borderColor.CGColor;
            }
        };
        
        void (^textFieldsAnimation)() = ^void() {
            for (UITextField *currentTextField in self.textFields) {
                currentTextField.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1 + 2 * kLUNDefaultMarginBetweenTextFields / currentTextField.frame.size.width, 0.001), CGAffineTransformMakeTranslation(0, currentTextField.frame.size.height / 2 - self.borderWidth));
            }
        };
        
        self.lineViewLeftConstraint.constant = 0;
        self.lineViewRightConstraint.constant = 0;
        self.placeholderImageViewTopConstraint.constant = -1 * (self.frame.size.height / 2 - self.placeholderImageView.frame.size.height / 2);
        self.placeholderLabelTopConstraint.constant = -1 * (self.frame.size.height / 2 - self.placeholderLabel.frame.size.height / 2);
        
        [UIView animateWithDuration:kLUNDownAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            underliningAnimation();
            stateImageViewToPlaceholderImageViewAnimation();
            placeHolderLabelAnimation();
            borderAnimation();
            textFieldsAnimation();
            [self layoutIfNeeded];
        }
                         completion:nil];
    } else {
        [self validateInput];
    }
    if ([self.delegate respondsToSelector:@selector(LUNFieldHasEndedEditing:)]) {
        [self.delegate LUNFieldHasEndedEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark validation

- (void)validateInput {
    if ([self.delegate respondsToSelector:@selector(LUNField:containsValidText:)]) {
        BOOL isValid = [self.delegate LUNField:self containsValidText:self.text];
        if (isValid) {
            _isCorrect = LUNCorrectContent;
        } else {
            _isCorrect = LUNIncorrectContent;
        }
        [self animateValidation:isValid];
        [self endEditing:YES];
    } else {
        _isCorrect = LUNUndefined;
    }
}

- (void)animateValidation:(BOOL)valid {
    UIColor *resultBorderColor;
    UIColor *resultPlaceholderLabelColor;
    NSString *resultLabelText;
    UIImage *resultStateImage;
    if (valid) {
        resultBorderColor = self.correctStateBorderColor ? self.correctStateBorderColor : self.borderColor;
        resultPlaceholderLabelColor = self.correctStatePlaceholderLabelTextColor ? self.correctStatePlaceholderLabelTextColor : self.placeholderFontColor;
        resultLabelText = self.correctLabelText ? self.correctLabelText : self.placeholderText;
        resultStateImage = self.correctStateImage;
    } else {
        resultBorderColor = self.incorrectStateBorderColor ? self.incorrectStateBorderColor : self.borderColor;
        resultPlaceholderLabelColor = self.incorrectStatePlaceholderLabelTextColor ? self.incorrectStatePlaceholderLabelTextColor : self.placeholderFontColor;
        resultLabelText = self.incorrectLabelText ? self.incorrectLabelText : self.placeholderText;
        resultStateImage = self.incorrectStateImage;
    }
    
    void (^borderColorAnimation)() = ^void() {
        for (UITextField *currentTextField in self.textFields) {
            currentTextField.layer.borderColor = resultBorderColor.CGColor;
        }
    };
    
    void (^placeholderLabelAnimation)() = ^void() {
        self.placeholderLabel.text = resultLabelText;
        self.placeholderLabel.textColor = resultPlaceholderLabelColor;
        [self easeInOutView:self.placeholderLabel];
    };
    
    void (^stateImageViewAnimation)() = ^void() {
        self.stateImageView.image = resultStateImage;
        self.stateImageView.alpha = 1.0f;
        [self easeInOutView:self.stateImageView];
    };
    
    [UIView animateWithDuration:kLUNChangeStateAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        borderColorAnimation();
        placeholderLabelAnimation();
        stateImageViewAnimation();
    } completion:nil];
}

#pragma mark Transitions

- (void)easeInOutView:(UIView *)view {
    CATransition *transition = [CATransition animation];
    transition.duration = kLUNChangeStateAnimationDuration;
    [transition setType:kCATransitionFade];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:
                                 kCAMediaTimingFunctionEaseInEaseOut];
    [transition setFillMode:@"extended"];
    [view.layer addAnimation:transition forKey:nil];
    [CATransaction commit];
}

#pragma mark tap gesture recognizer handler

- (void)viewTapped {
    BOOL isEdited = NO;
    for (UITextField *textField in self.textFields) {
        if (textField.text.length > 0) {
            isEdited = YES;
            break;
        }
    }
    
    if (!self.isEditing && !isEdited) {
        self.isEditing = YES;
        [self.textFields[0] becomeFirstResponder];
        void (^placeholderLabelAnimation)() = ^void() {
            self.placeholderLabel.textColor = self.upperPlaceholderFontColor;
            CGAffineTransform translation;
            switch (self.placeholderLabel.textAlignment) {
                case NSTextAlignmentCenter:
                    translation = CGAffineTransformMakeTranslation(0, 0);
                    break;
                case NSTextAlignmentLeft:
                    translation = CGAffineTransformMakeTranslation(-1 * (1 - kLUNScaleFactor) / 2 * self.placeholderLabel.frame.size.width + kLUNDefaultMarginBetweenTextFields, 0);
                    break;
                case NSTextAlignmentRight:
                    translation = CGAffineTransformMakeTranslation((1 - kLUNScaleFactor) / 2 * self.placeholderLabel.frame.size.width - 2 * kLUNDefaultMarginBetweenTextFields, 0);
                    break;
                default:
                    translation = CGAffineTransformMakeTranslation(0, 0);
                    break;
            }
            CGAffineTransform resultTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(kLUNScaleFactor, kLUNScaleFactor), translation);
            self.placeholderLabel.transform = resultTransform;
        };
        
        void (^textFieldsAnimation)() = ^void() {
            for (UITextField *currentTexField in self.textFields) {
                currentTexField.layer.borderColor = self.upperBorderColor.CGColor;
                currentTexField.transform = CGAffineTransformIdentity;
            }
        };
        
        void (^borderAndUnderliningAnimation)() = ^void() {
            if (self.borderColor) {
                self.lineView.alpha = 0.0f;
            }
            self.lineView.backgroundColor = self.upperBorderColor ? self.upperBorderColor : self.underliningColor;
        };
        
        void (^placeholderImageViewAnimation)() = ^void() {
            self.placeholderImageView.alpha = 0.0f;
        };
        
        self.placeholderImageViewTopConstraint.constant = self.placeholderImageView.frame.size.height;
        self.placeholderLabelTopConstraint.constant = self.placeholderLabel.frame.size.height;
        
        self.lineViewLeftConstraint.constant = -kLUNDefaultMarginBetweenTextFields;
        self.lineViewRightConstraint.constant = kLUNDefaultMarginBetweenTextFields;
        
        [UIView animateWithDuration:kLUNUpAnimationDuration delay:0 usingSpringWithDamping:kLUNDamping initialSpringVelocity:kLUNInitialVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
            placeholderLabelAnimation();
            borderAndUnderliningAnimation();
            placeholderImageViewAnimation();
            textFieldsAnimation();
            [self layoutIfNeeded];
            
        }                completion:nil];
    }
}


#pragma mark DataSource

- (void)setDataSource:(id <LUNFieldDataSource>)dataSource {
    _dataSource = dataSource;
    [self updatePlaceholderLabel];
    [self updateTextFields];
    [self updateUnderliningView];
    [self updateLeftView];
    [self updatePlaceholderImageView];
    [self updateStateImageView];
    [self layoutIfNeeded];
}

#pragma mark updating views in LUNField

- (void)updateTextFields {
    NSUInteger numberOfSections = [_dataSource numberOfSectionsInTextField:self];
    NSUInteger lengthOfSections[numberOfSections];
    NSUInteger summLength = 0;
    for (NSUInteger i = 0; i < numberOfSections; ++i) {
        lengthOfSections[i] = [_dataSource numberOfCharactersInSection:i inTextField:self];
        summLength += lengthOfSections[i];
    }
    if (numberOfSections > 1) {
        self.isMultifield = YES;
    } else {
        self.isMultifield = NO;
    }
    for (NSUInteger i = 0; i < numberOfSections; ++i) {
        LUNTextFieldWithTextInsets *textField = [LUNTextFieldWithTextInsets new];
        [self setupTextField:textField];
        [self addSubview:textField];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
        if (i == 0) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeLeading multiplier:1.0f constant:-1 * kLUNDefaultMarginBetweenTextFields]];
        }
        if (i > 0) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textFields[i - 1] attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeLeading multiplier:1.0f constant:-kLUNDefaultMarginBetweenTextFields]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.textFields[0] attribute:NSLayoutAttributeWidth multiplier:(lengthOfSections[i] / (CGFloat) lengthOfSections[0]) constant:0.0f]];
        }
        if (i == numberOfSections - 1) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:kLUNDefaultMarginBetweenTextFields]];
            textField.inputAccessoryView = self.accessoryView;
        }
        [self layoutIfNeeded];
        CGAffineTransform concat = CGAffineTransformConcat(CGAffineTransformMakeScale(1 + 2 * kLUNDefaultMarginBetweenTextFields / (self.frame.size.width - (numberOfSections + 1) * kLUNDefaultMarginBetweenTextFields) / numberOfSections, 0.001), CGAffineTransformMakeTranslation(0, textField.frame.size.height / 2 - self.borderWidth));
        textField.transform = concat;
        [self.textFields addObject:textField];
    }
}

- (void)updateUnderliningView {
    self.lineView = [UIView new];
    self.lineView.translatesAutoresizingMaskIntoConstraints = NO;
    self.lineView.backgroundColor = self.borderColor ? self.borderColor : self.underliningColor;
    [self addSubview:self.lineView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:(self.borderWidth ? self.borderWidth : 1.0f)]];
    self.lineViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.lineView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0];
    [self addConstraint:self.lineViewLeftConstraint];
    self.lineViewRightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.lineView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    [self addConstraint:self.lineViewRightConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.lineView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
}

- (void)updateLeftView {
    if (!self.isMultifield && self.leftView) {
        [self.textFields firstObject].leftView = self.leftView;
        [[self.textFields firstObject] setLeftViewMode:UITextFieldViewModeAlways];
    }
}

- (void)updatePlaceholderLabel {
    self.placeholderLabel = [UILabel new];
    [self addSubview:self.placeholderLabel];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.placeholderLabel.textColor = self.placeholderFontColor;
    self.placeholderLabel.font = self.placeholderFont;
    self.placeholderLabel.text = self.placeholderText;
    [self layoutIfNeeded];
    self.placeholderLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.placeholderLabel attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    self.placeholderLabelTopConstraint.constant = -1 * (self.frame.size.height / 2 - self.placeholderLabel.frame.size.height / 2);
    [self addConstraint:self.placeholderLabelTopConstraint];
    [self layoutIfNeeded];
    self.placeholderLabel.textAlignment = NSTextAlignmentCenter;
    [self setupPlaceholderPositionWithAlignment:self.placeholderAlignment];
}

- (void)updatePlaceholderImageView {
    self.placeholderImageView = [UIImageView new];
    self.placeholderImageView.clipsToBounds = YES;
    self.placeholderImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.placeholderImageView.image = self.placeholderImage;
    self.placeholderImageView.contentMode = self.placeholderImageViewContentMode;
    [self setupPlaceholderImagePosition];
}

- (void)updateStateImageView {
    self.stateImageView = [UIImageView new];
    self.stateImageView.clipsToBounds = YES;
    self.stateImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stateImageView.alpha = 0.0f;
    self.stateImageView.contentMode = kLUNImageViewDefaultContentMode;
    [self addSubview:self.stateImageView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.stateImageView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:2 * kLUNDefaultMarginBetweenTextFields + self.borderWidth]];
    self.stateImageViewTopConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.stateImageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:-1 * (self.frame.size.height / 2 - self.stateImageView.frame.size.height / 2)];
    [self addConstraint:self.stateImageViewTopConstraint];
}

- (void)setupTextField:(UITextField *)textField {
    textField.textColor = self.textFontColor;
    textField.font = self.textFont;
    textField.layer.borderColor = self.borderColor.CGColor;
    textField.layer.borderWidth = self.borderWidth;
    textField.tintColor = self.tintColor;
    textField.keyboardType = self.keyboardType;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.delegate = self;
    textField.textAlignment = self.isMultifield ? NSTextAlignmentCenter : self.placeholderLabel.textAlignment;
    if (self.accessoryViewMode == LUNAccessoryViewModeAlways) {
        textField.inputAccessoryView = self.accessoryView;
    }
    [textField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark placeholder setup

- (void)setupPlaceholderPositionWithAlignment:(LUNPlaceholderAlignment)alignment {
    self.placeholderAlignment = alignment;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.placeholderLabel attribute:NSLayoutAttributeLeading multiplier:1.0f constant:-4]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.placeholderLabel attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
    [self layoutIfNeeded];
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    self.placeholderLabel.text = placeholderText;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    self.placeholderLabel.font = placeholderFont;
}

- (void)setPlaceholderFontColor:(UIColor *)placeholderFontColor {
    _placeholderFontColor = placeholderFontColor;
    self.placeholderLabel.textColor = placeholderFontColor;
}

#pragma mark placeholderImage setup

- (void)setupPlaceholderImagePosition {
    [self addSubview:self.placeholderImageView];
    self.placeholderImageViewRightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.placeholderImageView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:4];
    [self addConstraint:self.placeholderImageViewRightConstraint];
    self.placeholderImageViewTopConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.placeholderImageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    self.placeholderImageViewTopConstraint.constant = -1 * (self.frame.size.height / 2 - self.placeholderImageView.frame.size.height / 2);
    [self addConstraint:self.placeholderImageViewTopConstraint];
    [self layoutIfNeeded];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    if (!self.placeholderImageView) {
        self.placeholderImageView = [UIImageView new];
        self.placeholderImageView.clipsToBounds = YES;
    }
    self.placeholderImageView.image = placeholderImage;
}

#pragma mark text setup

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    for (UITextField *currentTextField in self.textFields) {
        currentTextField.font = textFont;
    }
}

- (void)setTextFontColor:(UIColor *)textFontColor {
    _textFontColor = textFontColor;
    for (UITextField *currentTextField in self.textFields) {
        currentTextField.textColor = textFontColor;
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    for (UITextField *currentTextField in self.textFields) {
        currentTextField.tintColor = tintColor;
    }
}

#pragma mark textFieldsBorderSetup

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    for (UITextField *currentTextField in self.textFields) {
        currentTextField.layer.borderColor = borderColor.CGColor;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    for (UITextField *currentTextField in self.textFields) {
        currentTextField.layer.borderWidth = borderWidth;
    }
}

#pragma mark text

- (NSString *)text {
    NSMutableString *concat = [[NSMutableString alloc] init];
    for (UITextField *textField in self.textFields) {
        [concat appendString:textField.text];
    }
    return concat;
}

- (void)setText:(NSString *)text {
    for (UITextField *textField in self.textFields) {
        textField.text = @"";
    }
    [self viewTapped];
    NSUInteger numberOfSections = self.textFields.count;
    NSUInteger lengthOfSections[numberOfSections];
    NSUInteger summLength = 0;
    for (NSUInteger i = 0; i < numberOfSections; ++i) {
        lengthOfSections[i] = [_dataSource numberOfCharactersInSection:i inTextField:self];
        summLength += lengthOfSections[i];
    }
    if (summLength < text.length) {
        text = [text substringToIndex:summLength];
    }
    for (NSUInteger i = 0; i < self.textFields.count; ++i) {
        self.textFields[i].text = [text substringToIndex:(lengthOfSections[i] < text.length) ? lengthOfSections[i] : text.length];
        text = [text substringFromIndex:(lengthOfSections[i] < text.length) ? lengthOfSections[i] : text.length];
    }
    [self validateInput];
    [self resignFirstResponder];
}

#pragma mark reload

- (void)reload {
    NSString *currentText = self.text;
    self.textFields = [[NSMutableArray alloc] init];
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self updatePlaceholderLabel];
    [self updateTextFields];
    [self updateUnderliningView];
    [self updateLeftView];
    [self updatePlaceholderImageView];
    [self updateStateImageView];
    if (currentText.length > 0) {
        self.text = currentText;
    }
}

#pragma mark Responding

- (BOOL)isFirstResponder {
    for (UITextField *textField in self.textFields) {
        if ([textField isFirstResponder]) {
            return YES;
        }
    }
    return NO;
}

- (void)becomeFirstResponder {
    BOOL needResponding = YES;
    [self viewTapped];
    for (UITextField *currentTexField in self.textFields) {
        if (currentTexField.text.length != [self.dataSource numberOfCharactersInSection:[self.textFields indexOfObject:currentTexField] inTextField:self]) {
            [currentTexField becomeFirstResponder];
            needResponding = NO;
            break;
        }
    }
    if (needResponding) {
        [[self.textFields lastObject] becomeFirstResponder];
    }
}

- (void)resignFirstResponder {
    for (UITextField *textField in self.textFields) {
        [textField resignFirstResponder];
    }
}

#pragma fabric methods

+ (LUNField *)LUNBorderedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate {
    LUNField *LUNfield = [[LUNField alloc]init];
    LUNfield.dataSource = dataSource;
    LUNfield.delegate = delegate;
    return LUNfield;
}

+ (LUNField *)LUNUnderlinedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate {
    LUNField *LUNfield = [[LUNField alloc]init];
    LUNfield.dataSource = dataSource;
    LUNfield.delegate = delegate;
    LUNfield.borderColor = nil;
    [LUNfield reload];
    return LUNfield;
}

+ (LUNField *)LUNBorderedFieldWithWithDataSource:(id<LUNFieldDataSource> )dataSource delegate:(id<LUNFieldDelegate>)delegate placeholderText:(NSString *)placeholderText {
    LUNField *LUNfield = [LUNField LUNBorderedFieldWithDataSource:dataSource delegate:delegate];
    LUNfield.placeholderText = placeholderText;
    [LUNfield reload];
    return LUNfield;
}

+ (LUNField *)LUNBorderedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate placeholderText:(NSString *)placeholderText borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor upperBorderColor:(UIColor *)upperBorderColor {
    LUNField *LUNfield = [[LUNField alloc]init];
    LUNfield.dataSource = dataSource;
    LUNfield.delegate = delegate;
    LUNfield.placeholderText = placeholderText;
    LUNfield.borderWidth = borderWidth;
    LUNfield.borderColor = borderColor;
    LUNfield.upperBorderColor = upperBorderColor;
    [LUNfield reload];
    return LUNfield;
}

+ (LUNField *)LUNUnderlinedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate underliningHeight:(CGFloat)underliningHeight underliningColor:(UIColor *)underliningColor {
    LUNField *LUNfield = [[LUNField alloc]init];
    LUNfield.dataSource = dataSource;
    LUNfield.delegate = delegate;
    LUNfield.borderWidth = underliningHeight;
    LUNfield.underliningColor = underliningColor;
    LUNfield.borderColor = nil;
    [LUNfield reload];
    return LUNfield;
}

@end
