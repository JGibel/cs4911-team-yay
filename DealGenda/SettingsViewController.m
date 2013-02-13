//
//  SettingsViewController.m
//  DealGenda
//
//  Created by Jenelle Walker on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateInputCallback:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
}

- (BOOL)validateInputWithString:(NSString *)emailField {
    NSString * const regularExpression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSError *error = NULL;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    NSUInteger numberOfMatches = [regEx numberOfMatchesInString:emailField
                                                        options:0
                                                            range:NSMakeRange(0, [emailField length])];
    return numberOfMatches > 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)aTextField
{
    return [self validateInputWithString:aTextField.text];
}

- (void)validateInputCallback:(id)sender
{
    if ([self validateInputWithString:_emailTextField.text]) {
        _emailLabel.textColor = [UIColor greenColor];
        _emailLabel.text = @"Valid Email";
    }
    else {
        _emailLabel.textColor = [UIColor redColor];
        _emailLabel.text = @"Please enter a valid email.";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
