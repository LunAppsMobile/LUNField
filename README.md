# LUNField
This project aims to provide simple customizable nice textfield with grouping. 
Please check this [article](https://lunapps.com/blog/lunfield/) on our blog.
[![Foo](https://lunapps.com/img/craftedInLunapps.png)](https://lunapps.com/)

Purpose
-------
LUNField is class designed to simplify the implementation of textfield's group with nice animation. It includes possibillity to validate content to pay user's attention. Also you can use it as normal textfield, but with moving placeholder and nice border animation. For example, you can use it as input element for credit-cards numbers or mobile phones.

Supported OS & SDK Versions
---------------------------

* Supported build target - iOS 8.0

ARC Compatibility
-----------------

LUNField requires ARC.

Thread Safety
-------------

LUNField is derived from UIView and - as with all UIKit components - it should only be accessed from the main thread.

Examples
--------

### Basic usage:
![1_video.gif](https://i1.wp.com/lunapps.com/blog/wp-content/uploads/2016/02/68747470733a2f2f67696679752e636f6d2f696d616765732f315f766964656f2e676966.gif)

### Highlighting correct input:
![2_video.gif](https://i2.wp.com/lunapps.com/blog/wp-content/uploads/2016/02/68747470733a2f2f67696679752e636f6d2f696d616765732f325f766964656f2e676966.gif)

Installation
------------

To use the LUNField class in an app, just drag the LUNField class files (demo files and assets are not needed) into your project.

Also you can use CocoaPods 
### Сocoapods version

```ruby
pod 'LUNField'
```

Properties
----------

@property (weak, nonatomic) IBOutlet id <LUNFieldDataSource> dataSource;

An object that supports the `LUNFieldDataSource` protocol and provide possibility to construct and modify LUNField.

@property (weak, nonatomic) IBOutlet id <LUNFieldDelegate> delegate;

An object that supports the `LUNFieldDelegate` protocol and can respond to LUNField events.

@property (strong, nonatomic) NSString *text;

The text displayed by the text field.

@property (assign, nonatomic) UIKeyboardType keyboardType;

The keyboard style associated with the text object.

@property (strong, nonatomic) UIFont *placeholderFont;

@property (strong, nonatomic) IBInspectable NSString *placeholderText;

@property (strong, nonatomic) IBInspectable UIColor *placeholderFontColor;

@property (strong, nonatomic) IBInspectable UIColor *upperPlaceholderFontColor;

@property (strong, nonatomic) IBInspectable UIImage *placeholderImage;

These properties customize placeholder of LUNField.

@property (strong, nonatomic) UIFont *textFont;

@property (strong, nonatomic) IBInspectable UIColor *textFontColor;

@property (strong, nonatomic) IBInspectable UIColor *tintColor;

These properties customize text in LUNField.

@property (assign, nonatomic) IBInspectable CGFloat borderWidth;

@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@property (strong, nonatomic) IBInspectable UIColor *upperBorderColor;

These properties customize borders in LUNField.

@property (strong, nonatomic) IBInspectable UIColor *underliningColor;

If borderColor is nil, this property customizes underlining in LUNField.

@property (strong, nonatomic) IBInspectable NSString *correctLabelText;

@property (strong, nonatomic) IBInspectable UIColor *correctStateBorderColor;

@property (strong, nonatomic) IBInspectable UIColor *correctStatePlaceholderLabelTextColor;

@property (strong, nonatomic) IBInspectable UIImage *correctStateImage;

These properties customize state of LUNField after successful validation.

@property (strong, nonatomic) IBInspectable NSString *incorrectLabelText;

@property (strong, nonatomic) IBInspectable UIColor *incorrectStateBorderColor;

@property (strong, nonatomic) IBInspectable UIColor *incorrectStatePlaceholderLabelTextColor;

@property (strong, nonatomic) IBInspectable UIImage *incorrectStateImage;

These properties customize state of LUNField after failed validation.

@property (strong, nonatomic) UIView *leftView;

This property is similar to textfield’s leftView. It affects LUNField only when numberOfSections in LUNField is equal to 1.

@property (strong, nonatomic) UIView *accessoryView;

This property is similar to textfield’s inputAccessoryView.

@property (assign, nonatomic, readonly) LUNValidationOfContent isCorrect;

This property contains validation result.

@property (assign, nonatomic) LUNAccessoryViewMode accessoryViewMode;

This property is responsible for showing accessoryView. Defines would it be shown at each section or only at last section.

@property (assign, nonatomic) LUNPlaceholderAlignment placeholderAlignment;

This property defines placeholder label’s alignment in LUNField.

Methods
--------

The LUNField class has the following methods:

- (BOOL)isFirstResponder;

Returns a Boolean value indicating whether the LUNField is the first responder.

- (void)becomeFirstResponder;

LUNField’s first unfilled text field becomes first responder.

- (void)resignFirstResponder;

LUNField’s textfields resign first responder.

- (void)reload;

This reloads LUNField from the dataSource and refreshes the display. Doesn’t affect text.

Also LUNField has several fabric methods that helps customize LUNField with default templates:

+ (LUNField *)LUNBorderedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate;

+ (LUNField *)LUNUnderlinedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate;

+ (LUNField *)LUNBorderedFieldWithWithDataSource:(id<LUNFieldDataSource> )dataSource delegate:(id<LUNFieldDelegate>)delegate placeholderText:(NSString *)placeholderText;

+ (LUNField *)LUNBorderedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate placeholderText:(NSString *)placeholderText borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor upperBorderColor:(UIColor *)upperBorderColor;

+ (LUNField *)LUNUnderlinedFieldWithDataSource:(id<LUNFieldDataSource>)dataSource delegate:(id<LUNFieldDelegate>)delegate underliningHeight:(CGFloat)underliningHeight underliningColor:(UIColor *)underliningColor;

Protocols
---------

The LUNField follows the Apple convention for data-driven views by providing two protocol interfaces, `LUNFieldDataSource` and `LUNFieldDelegate`.

### LUNFieldDataSource 

The LUNFieldDataSource protocol has the following required methods:

- (NSUInteger)numberOfSectionsInTextField:(LUNField *)LUNField;

Returns the number of sections (UITextFields) in LUNField.

- (NSUInteger)numberOfCharactersInSection:(NSInteger)section inTextField:(LUNField *)LUNField;

Returns maximum number of symbols in requested section in LUNField. LUNField’s sections are constructed proportionally to this numbers. 

### LUNFieldDelegate

The LUNFieldDelegate protocol has the following optional methods:

- (void)LUNFieldTextChanged:(LUNField *)LUNField;

Notifies that text in LUNField has been changed.

- (void)LUNFieldHasEndedEditing:(LUNField *)LUNField;

Notifies that LUNField has ended editing.

- (BOOL)LUNField:(LUNField *)LUNField containsValidText:(NSString *)text;

Asks if the text in LUNField is valid; called when LUNField ended editing.

License
-------
Usage is provided under the [MIT License](http://opensource.org/licenses/MIT)