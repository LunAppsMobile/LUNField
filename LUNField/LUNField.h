//
//  LUN_RectangleField.h
//  LUNFields
//
//  Created by Vladimir Sharavara on 1/8/16.
//  Copyright © 2016 gmgroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LUNField;


/**
 @brief LUNPlaceholderAlignmentLeft - placeholder label aligned to the left edge of LUNField
 @brief LUNPlaceholderAlignmentRight - placeholder label aligned to the right edge of LUNField
 @brief LUNPlaceholderAlignmentCenter - placeholder label aligned to the center of LUNField
 */
typedef enum LUNPlaceholderAlignment : NSUInteger {
    LUNPlaceholderAlignmentLeft = 1,
    LUNPlaceholderAlignmentRight = 2,
    LUNPlaceholderAlignmentCenter = 3,
} LUNPlaceholderAlignment;

/**
 @brief LUNCorrectContent - validation passed successfully
 @brief LUNIncorrectContent - validation failed
 @brief LUNUndefined - validation didn't happened (reasons: 1. you haven't implemented LUNField:containsValidText: delegate's method; 2. field hasn't been edited)
 */
typedef enum LUNValidationOfContent : NSUInteger {
    LUNUndefined = 0,
    LUNCorrectContent = 1,
    LUNIncorrectContent = 2
} LUNValidationOfContent;

/**
 @brief LUNAccessoryViewModeLast - accessoryView will be shown only for last textField in LUNField
 @brief LUNAccessoryViewModeAlways - accessoryView will be shown for each textField in LUNField
 */
typedef enum LUN_AccessoryViewMode : NSUInteger {
    LUNAccessoryViewModeLast = 0,
    LUNAccessoryViewModeAlways = 1
} LUNAccessoryViewMode;


@protocol LUNFieldDelegate <NSObject>

@optional
/**
 *  @brief Notifies delegate object that text in LUNField object
 *
 *  @param LUNField LUNField object where text changed
 */
- (void)LUNFieldTextChanged:(LUNField *)LUNField;

/**
 *  @brief Notifies delegate object that LUNField object has ended editing
 *
 *  @param LUNField LUNField object that ended editing
 */
- (void)LUNFieldHasEndedEditing:(LUNField *)LUNField;

/**
 *  @brief Asks delegate if the text that is contained in LUNField is valid
 *
 *  @param LUNField LUNField object
 *  @param text      text for validation
 *
 *  @return YES if contained text is valid, NO otherwise
 */
- (BOOL)LUNField:(LUNField *)LUNField containsValidText:(NSString *)text;

@end


/**
 *  @brief The LUNFieldDataSource protocol is adopted by an object that mediates the application’s data model for a LUNField object. The data source provides the LUNField object with the information it needs to construct and modify a LUNField.
 */
@protocol LUNFieldDataSource <NSObject>

@required

/**
 *  @brief Tells the data source to return the number section of a LUNField
 *
 *  @param LUNField LUNField object that requests for number of sections
 *
 *  @return
 */
- (NSUInteger)numberOfSectionsInTextField:(LUNField *)LUNField;

/**
 *  @brief Tells the data source to return the number of characters in a given section of a LUNField
 *
 *  @param section   An index number identifying a section in LUNField
 *  @param LUNField LUNField object that requests for number of characters
 *
 *  @return Number of charaters in section
 */
- (NSUInteger)numberOfCharactersInSection:(NSInteger)section inTextField:(LUNField *)LUNField;

@end


IB_DESIGNABLE
@interface LUNField : UIView

@property (weak, nonatomic) IBOutlet id <LUNFieldDataSource> dataSource;
@property (weak, nonatomic) IBOutlet id <LUNFieldDelegate> delegate;

/**
 *  @brief current text in LUNField, text is result of concatenation textfield's texts
 */
@property (strong, nonatomic) NSString *text;
/**
 *  @brief text fields keyboard type
 */
@property (assign, nonatomic) UIKeyboardType keyboardType;

/**
 *  @brief font for placeholder label
 */
@property (strong, nonatomic) UIFont *placeholderFont;

/**
 *  @brief text for placeholder label
 */
@property (strong, nonatomic) IBInspectable NSString *placeholderText;

/**
 *  @brief placeholder label's textColor for unedited state
 */
@property (strong, nonatomic) IBInspectable UIColor *placeholderFontColor;

/**
 *  @brief placeholder label's textColor for edited state
 */
@property (strong, nonatomic) IBInspectable UIColor *upperPlaceholderFontColor;

/**
 *  @brief image that would move up and dissolve between transition from unedited state to edited state
 */
@property (strong, nonatomic) IBInspectable UIImage *placeholderImage;

/**
 *  @brief font for textfields
 */
@property (strong, nonatomic) UIFont *textFont;

/**
 *  @brief textColor for textfields
 */
@property (strong, nonatomic) IBInspectable UIColor *textFontColor;

/**
 *  @brief tintColor for textFields
 */
@property (strong, nonatomic) IBInspectable UIColor *tintColor;

/**
 *  @brief border width of each text field in LUNField
 */
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;

/**
 *  @brief border color of each text field in LUNField
 */
@property (strong, nonatomic) IBInspectable UIColor *borderColor;

/**
 *  @brief border color for each textField in LUNField for edited state
 */
@property (strong, nonatomic) IBInspectable UIColor *upperBorderColor;

/**
 *  @brief underlining color, affects LUNField only when borderColor is nil
 */
@property (strong, nonatomic) IBInspectable UIColor *underliningColor;

/**
 *  @brief placeholder label's text after successfull validation
 */
@property (strong, nonatomic) IBInspectable NSString *correctLabelText;

/**
 *  @brief border color after successfull validation
 */
@property (strong, nonatomic) IBInspectable UIColor *correctStateBorderColor;

/**
 *  @brief placeholder label's textColor after successfull validation
 */
@property (strong, nonatomic) IBInspectable UIColor *correctStatePlaceholderLabelTextColor;

/**
 *  @brief state image after successfull validation
 */
@property (strong, nonatomic) IBInspectable UIImage *correctStateImage;

/**
 *  @brief placeholder label's text after failed validation
 */
@property (strong, nonatomic) IBInspectable NSString *incorrectLabelText;

/**
 *  @brief border color after failed validation
 */
@property (strong, nonatomic) IBInspectable UIColor *incorrectStateBorderColor;

/**
 *  @brief placeholder label's textColor after failed validation
 */
@property (strong, nonatomic) IBInspectable UIColor *incorrectStatePlaceholderLabelTextColor;

/**
 *  @brief state image after failed validation
 */
@property (strong, nonatomic) IBInspectable UIImage *incorrectStateImage;

/**
 *  @brief left view for LUNField, similar to textfield's leftView, affects only if dataSource's snumberOfSectionsInTextField: returns 1 for current LUNField
 */
@property (strong, nonatomic) UIView *leftView;

/**
 *  @brief accessoryView for LUNField, similar to textfield's inputAccessoryView
 */
@property (strong, nonatomic) UIView *accessoryView;

/**
 *  @brief current validation result for LUNField, see LUN_ValidationOfContent enum definition for details
 */
@property (assign, nonatomic, readonly) LUNValidationOfContent isCorrect;

/**
 *  @brief defines when accessoryView is showing, see LUN_AccessoryViewMode enum definition for details
 */
@property (assign, nonatomic) LUNAccessoryViewMode accessoryViewMode;

/**
 *  @brief defines placeholder label alignment if LUNField, if dataSource's snumberOfSectionsInTextField: returns 1 for current LUNField, defines alignment of text in LUNField, see LUN_PlaceholderAlignment enum definition for details
 */
@property (assign, nonatomic) LUNPlaceholderAlignment placeholderAlignment;

/**
 *  @brief content mode for placeholderImageView
 */
@property (assign, nonatomic) UIViewContentMode placeholderImageViewContentMode;


/**
 *  @brief returns LUNField in bordered form with templated format
 *
 *  @param dataSource The object that acts as the data source of the LUNField
 *  @param delegate   The object that acts as the delegate of the LUNField
 *
 *  @return LUNField in bordered form with templated format
 */
+ (LUNField *)LUNBorderedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate;


/**
 *  @brief returns LUNField without borders, only with underlining with templated format
 *
 *  @param dataSource The object that acts as the data source of the LUNField
 *  @param delegate   The object that acts as the delegate of the LUNField
 *
 *  @return LUNField without borders only with underlining with templated format
 */
+ (LUNField *)LUNUnderlinedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate;

/**
 *  @brief returns LUNField in bordered form with templated format with placeholderText
 *
 *  @param dataSource The object that acts as the data source of the LUNField
 *  @param delegate   The object that acts as the delegate of the LUNField
 *  @param placeholderText text for placeholder label
 *
 *  @return returns LUNField in bordered form with templated format with placeholderText
 
 */
+ (LUNField *)LUNBorderedFieldWithWithDataSource:(id<LUNFieldDataSource> )dataSource delegate:(id<LUNFieldDelegate>)delegate placeholderText:(NSString *)placeholderText;

/**
 *  @brief returns LUNField in bordered form with user's format
 *
 *  @param dataSource The object that acts as the data source of the LUNField
 *  @param delegate   The object that acts as the delegate of the LUNField
 *  @param placeholderText text for placeholder label
 *  @param borderWidth
 *  @param borderColor
 *  @param upperBorderColor
 *
 *  @return LUNField in bordered form with user's format
 */
+ (LUNField *)LUNBorderedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate placeholderText:(NSString *)placeholderText borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor upperBorderColor:(UIColor *)upperBorderColor;

/**
 *  @brief returns LUNField without borders, only with underlining with user's format
 *
 *  @param dataSource The object that acts as the data source of the LUNField
 *  @param delegate   The object that acts as the delegate of the LUNField
 *  @param underliningHeight height of underlining
 *  @param underliningColor  color of underlining
 *
 *  @return LUNField without borders, only with underlining with user's format
 */
+ (LUNField *)LUNUnderlinedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate underliningHeight:(CGFloat)underliningHeight underliningColor:(UIColor *)underliningColor;


/**
 *  @brief Returns a Boolean value indicating whether the receiver is the first responder. YES if the receiver is the first responder, NO otherwise
 *
 *  @return YES if the receiver is the first responder, NO otherwise
 */
- (BOOL)isFirstResponder;

/**
 *  @brief Notifies the receiver that it is about to become first responder in its window
 */
- (void)becomeFirstResponder;

/**
 *  @brief Notifies the receiver that it has been asked to relinquish its status as first responder in its window
 */
- (void)resignFirstResponder;

/**
 *  @brief applying changes in LUNField; doesn't affect text of LUNField
 */
- (void)reload;

@end
