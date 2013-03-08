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

- (void)viewDidLoad
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateInputCallback:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)aTextField
{
    [self validateInputWithString:aTextField];
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
