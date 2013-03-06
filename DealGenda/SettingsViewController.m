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

enum {
    emailTag = 0,
    pwTag,
    vPwTag

};

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
    FMResultSet *fm = [db executeQuery:@"SELECT expdate FROM coupons WHERE retailername='Staples'"];
    while([fm next]) {
        NSString *result = [fm stringForColumn:@"expdate"];
        NSLog(@"%@", result);
    }

}

- (BOOL)validateInputWithString:(UITextField *)aTextField {
    if(aTextField == _emailTextField) {
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

- (void)textFieldShouldEndEditing:(UITextField *)aTextField
{
    switch(aTextField.tag) {
            
        case emailTag:
            [self validateInputWithString:aTextField];
            break;
        case vPwTag:
            [self validateInputWithString:aTextField];
            break;
    }
}

- (void)validateInputCallback:(id)sender
{
    if ([self validateInputWithString:_emailTextField]) {
        _emailLabel.textColor = [UIColor greenColor];
        _emailLabel.text = @"Valid Email";
    }
    else {
        _emailLabel.textColor = [UIColor redColor];
        _emailLabel.text = @"Please enter a valid email.";
    }
    
    if ([self validateInputWithString:_verifyTextField]) {
        _pwLabel.textColor = [UIColor greenColor];
        _pwLabel.text = @"✓";
    }
    else {
        _pwLabel.textColor = [UIColor redColor];
        _pwLabel.text = @"X";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
