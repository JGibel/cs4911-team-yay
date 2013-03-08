//
//  SettingsViewController.m
//  DealGenda
//
//  Created by Jenelle Walker on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize activeField;
@synthesize scrollView;

- (void)viewDidLoad
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateInputCallback:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
    [self registerForKeyboardNotifications];
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    
    
    // do any further configuration to the scroll view
    // add a view, or views, as a subview of the scroll view.
    
    // release scrollView as self.view retains it
    self.view = scrollView;
    
    //[db executeUpdate:@"CREATE TABLE test (email varchar(255))"];
    //[db executeUpdate:@"INSERT INTO test VALUES (?)", @"email@email.com"];
//    FMResultSet *fm = [db executeQuery:@"SELECT expdate FROM coupons WHERE retailername='Staples'"];
//    while([fm next]) {
//        NSString *result = [fm stringForColumn:@"expdate"];
//        NSLog(@"%@", result);
//    }
    
    self.emailTextField.tag = 0;
    self.verifyTextField.tag = 1;
    
    self.emailTextField.delegate = self;
    self.pwTextField.delegate = self;
    self.verifyTextField.delegate = self;

}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (BOOL)validateInputWithString:(UITextField *)aTextField {
    if(aTextField.tag == 0) {
        NSString * const regularExpression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSError *error = NULL;
        NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        NSUInteger numberOfMatches = [regEx numberOfMatchesInString:aTextField.text
                                                            options:0
                                                              range:NSMakeRange(0, [aTextField.text length])];
        return numberOfMatches > 0;
    } else {
        return [_pwTextField.text isEqualToString: _verifyTextField.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)aTextField
{
    [self validateInputWithString:aTextField];
    activeField = nil;
    return YES;
}

- (void)validateInputCallback:(id)sender
{
    
    if(_emailTextField.isFirstResponder)
    {
        if ([self validateInputWithString:_emailTextField]) {
            _emailLabel.textColor = [UIColor greenColor];
            _emailLabel.text = @"Valid Email";
        }
        else {
            _emailLabel.textColor = [UIColor redColor];
            _emailLabel.text = @"Please enter a valid email.";
        }
    }
    
    if(_pwTextField.isFirstResponder)
    {
        if(_pwTextField.text.length < 6)
        {
            _pwLengthLabel.font = [_pwLengthLabel.font fontWithSize:10];
            _pwLengthLabel.textColor = [UIColor redColor];
            _pwLengthLabel.text =@"Must be at least 6 characters long.";
        }
        else {
            _pwLengthLabel.text=@"";
        }
    }
    
    if(_verifyTextField.isFirstResponder)
    {
        if ([self validateInputWithString:_verifyTextField]) {
            _pwLabel.textColor = [UIColor greenColor];
            _pwLabel.text = @"✓";
        }
        else {
            _pwLabel.textColor = [UIColor redColor];
            _pwLabel.text = @"X";
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
