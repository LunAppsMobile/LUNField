//
//  ViewController.m
//  LUNFields
//
//  Created by Vladimir Sharavara on 1/8/16.
//  Copyright © 2016 gmgroup. All rights reserved.
//

#import "ViewController.h"
#import "LUNField.h"

@interface ViewController () <LUNFieldDataSource, LUNFieldDelegate>
@property (weak, nonatomic) IBOutlet LUNField *nameField;
@property (weak, nonatomic) IBOutlet LUNField *priceField;
@property (weak, nonatomic) IBOutlet LUNField *cardNumberField;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation ViewController

NSUInteger lengthOfSections[4] = {1,1,1,1};


- (IBAction)viewTapped:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark LUN_RectangleFieldDataSource

- (NSUInteger)numberOfSectionsInTextField:(LUNField *)LUNField {
    if (LUNField == self.nameField) {
        return 1;
    }
    if (LUNField == self.priceField) {
        return 1;
    }
    return 4;
}


- (NSUInteger)numberOfCharactersInSection:(NSInteger)section inTextField:(LUNField *)LUNField {
    if (LUNField == self.nameField) {
        return 20;
    }
    if (LUNField == self.priceField) {
        return 6;
    }
    return lengthOfSections[section];
}

- (BOOL)LUNField:(LUNField *)LUNField containsValidText:(NSString *)text {
    if (LUNField == self.nameField) {
        return text.length>4;
    }
    if (LUNField == self.cardNumberField) {
        return text.length==16;
    }
    return YES;
}


- (void)nextFieldTapped:(UIButton *)sender {
    if (sender == self.nameField.accessoryView && [self.nameField isFirstResponder]) {
        [self.cardNumberField becomeFirstResponder];
    } else {
        if (sender == self.cardNumberField.accessoryView && [self.cardNumberField isFirstResponder]) {
            [self.priceField becomeFirstResponder];
        } else {
            [self.view endEditing:YES];
        }
    }
}

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog (@"Font families: %@", [UIFont familyNames]);
    NSLog (@"Courier New family fonts: %@", [UIFont fontNamesForFamilyName:@"SF UI Text"]);
    self.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:85.0f / 255.0f green:85.0f / 255.0f blue:85.0f / 255.0f alpha:1.0f],
       NSFontAttributeName:[UIFont fontWithName:@"SFUIText-Bold" size:16]}];
    self.navigationBar.topItem.title = @"TEXT FIELD STYLE 1";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60.0f)];
    button.backgroundColor = [UIColor colorWithRed:29.0f/255.0f green:170.0f/255.0f blue:252.0f/255.0f alpha:1];
    [button setTitle:@"NEXT FIELD" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:18.0f];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(nextFieldTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.nameField.textFont = [UIFont fontWithName:@"SFUIText-Regular" size:16.0f];
    self.nameField.placeholderFont = [UIFont fontWithName:@"SFUIText-Regular" size:16.0f];
    self.nameField.keyboardType = UIKeyboardTypeAlphabet;
    self.nameField.accessoryView = button;
    self.nameField.placeholderAlignment = LUNPlaceholderAlignmentLeft;
    self.nameField.placeholderText = @"Name";
    
    self.cardNumberField.keyboardType = UIKeyboardTypeNumberPad;
    self.cardNumberField.textFont = [UIFont fontWithName:@"SFUIText-Regular" size:16.0f];
    self.cardNumberField.placeholderFont = [UIFont fontWithName:@"SFUIText-Regular" size:16.0f];
    self.cardNumberField.accessoryView = button;
    self.cardNumberField.accessoryViewMode = LUNAccessoryViewModeAlways;
    self.cardNumberField.placeholderText = @"Card number";
    self.cardNumberField.placeholderAlignment = LUNPlaceholderAlignmentLeft;
    
    self.priceField.keyboardType = UIKeyboardTypeNumberPad;
    self.priceField.textFont = [UIFont fontWithName:@"SFUIText-Regular" size:16.0f];
    self.priceField.placeholderFont = [UIFont fontWithName:@"SFUIText-Regular" size:16.0f];
    self.priceField.accessoryView = button;
    self.priceField.placeholderText = @"Price";
    self.priceField.placeholderAlignment = LUNPlaceholderAlignmentLeft;
    
    UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"priceIcon"]];
    leftView.clipsToBounds = YES;
    leftView.contentMode = UIViewContentModeScaleAspectFill;
    leftView.frame = CGRectMake(0, 0, self.cardNumberField.frame.size.height + 2 *self.cardNumberField.borderWidth, self.cardNumberField.frame.size.height + 2 *self.cardNumberField.borderWidth);
    self.priceField.leftView = leftView;
    [self.nameField reload];
    for (NSInteger i = 0; i < 4; ++i) {
        lengthOfSections[i] = 4;
    }
    [self.cardNumberField reload];
    [self.priceField reload];
}

@end
