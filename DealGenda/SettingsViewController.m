//
//  SettingsViewController.m
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 2/11/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "Queries.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize activeField;
@synthesize scrollView;

- (void)viewWillAppear:(BOOL)animated
{
    _emailTextField.placeholder = [Queries getEmail];
    _pwTextField.text = @"";
    _verifyTextField.text = @"";
    _emailLabel.text = @"";
    _pwLengthLabel.text = @"";
    _pwLabel.text = @"";
    _loginLabel.text = @"";
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateInputCallback:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
    
    
    self.emailTextField.tag = 0;
    self.verifyTextField.tag = 1;
    
    self.emailTextField.delegate = self;
    self.pwTextField.delegate = self;
    self.verifyTextField.delegate = self;
    
    _emailTextField.placeholder = [Queries getEmail];
    //displays the user's current email address in the email text field
    [_saveButton setEnabled:NO];
    //disables the save button until the correct fields are filled
}

- (BOOL)validateInputWithString:(UITextField *)aTextField {
    if(aTextField.tag == 0) {
        NSString * const regularExpression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        //regex for email address checking. does not check for valid email address
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
        return [_verifyTextField.text isEqualToString: _pwTextField.text];
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
    if([_emailTextField.text isEqual: @""]) {
        _emailLabel.text = @"";
        
    }
    [self validateInputWithString:aTextField];
    activeField = nil;
    return YES;
}

- (void)validateInputCallback:(id)sender
{
    bool emailGo = true;
    bool passwordGo = true;
    
    //reset this label when changing input
    _loginLabel.text = @"";
    
    if(_emailTextField.isFirstResponder)
        //if the user has the email text field in focus
    {
        _emailTextField.textColor = [UIColor blackColor];
        if ([self validateInputWithString:_emailTextField] && _emailTextField.text.length > 5) {
            //removes any warnings if the email is formatted correctly
            _emailLabel.text = @"";
            emailGo = true;
        }
        else {
            //displays a warning if the email is not formatted correctly
            _emailLabel.textColor = [UIColor redColor];
            _emailLabel.font = [_loginLabel.font fontWithSize:12];
            _emailLabel.text = @"Please enter a valid email.";
            emailGo = false;
        }
    } 
    
    if(_pwTextField.isFirstResponder || _verifyTextField.isFirstResponder)
    {
        if(_pwTextField.text.length < 6)
        {
            //if the password or verify password fields are in focus, and if the password is less than 6 characters
            //display error message
            _pwLengthLabel.font = [_pwLengthLabel.font fontWithSize:12];
            _pwLengthLabel.textColor = [UIColor redColor];
            _pwLengthLabel.text =@"Must be at least 6 characters long.";
            _pwLabel.textColor = [UIColor redColor];
            _pwLabel.text = @"X";
            passwordGo = false;
        } else {
            //otherwise remove error message
            _pwLengthLabel.text=@"";
            if ([self validateInputWithString:_verifyTextField]) {
                _pwLabel.textColor = [UIColor greenColor];
                _pwLabel.text = @"✓";
                passwordGo = true;
            }
        }
    }
    if(emailGo == true || passwordGo == true) {
        //if either email or passwords fields are correctly formatted, enable the save button
        [_saveButton setEnabled:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveSettings:(id)sender {
    bool validEmail = (_emailTextField.text.length > 3) && ![Queries validateEmail:_emailTextField.text];
    bool validPassword = (_verifyTextField.text.length > 5) && [self validateInputWithString:_verifyTextField];
    
    if(validEmail && [_pwTextField.text isEqualToString:@""]) {
        //if email is appropriate length, doesn't already exist, and the password field is empty, update email only
        [Queries updateEmail: [Queries getEmail] : _emailTextField.text];
        _loginLabel.font = [_loginLabel.font fontWithSize:14];
        _loginLabel.textColor = [UIColor blackColor];
        _loginLabel.text = @"Save Successful";
        _emailTextField.text = @"";
        _emailTextField.placeholder = [Queries getEmail];
    } else if ([_emailTextField.text isEqualToString:@""] && validPassword){
        //if the email field is empty and the password field is at least 6 characters, update password only
        [Queries updatePassword:[Queries getEmail] : _pwTextField.text];
        _loginLabel.font = [_loginLabel.font fontWithSize:14];
        _loginLabel.textColor = [UIColor blackColor];
        _loginLabel.text = @"Save Successful";
        _pwTextField.text = @"";
        _verifyTextField.text = @"";
    } else if (validPassword && validEmail) {
        //if both email and password are valid, update both
        [Queries updateEmail: [Queries getEmail] : _emailTextField.text];
        [Queries updatePassword:[Queries getEmail] : _pwTextField.text];
        _loginLabel.font = [_loginLabel.font fontWithSize:14];
        _loginLabel.textColor = [UIColor blackColor];
        _loginLabel.text = @"Save Successful";
        _pwTextField.text = @"";
        _verifyTextField.text = @"";
        _emailTextField.text = @"";
        _emailTextField.placeholder = [Queries getEmail];
    } else if ((validPassword || [_pwTextField.text isEqualToString:@""]) && !validEmail){
        //if no password and email is not valid, show error text
    _loginLabel.font = [_loginLabel.font fontWithSize:14];
    _loginLabel.textColor = [UIColor redColor];
    _loginLabel.text = @"Email exists or is not valid";
    } else if (validEmail && !validPassword){
        //if email is valid, but password is not, show error text
        _loginLabel.font = [_loginLabel.font fontWithSize:14];
        _loginLabel.textColor = [UIColor redColor];
        _loginLabel.text = @"Password is not valid";
    } else {
        //if neither email or password are valid, show error text
        _loginLabel.font = [_loginLabel.font fontWithSize:14];
        _loginLabel.textColor = [UIColor redColor];
        _loginLabel.text = @"Email/Password combination is not valid";
    }
}
- (IBAction)resignButton:(id)sender {
    [_emailTextField resignFirstResponder];
    [_pwTextField resignFirstResponder];
    [_verifyTextField resignFirstResponder];
    
    if(_emailTextField.text.length == 0) {
        //if email text is empty, don't show error text
        _emailLabel.text = @"";
    }
    
    if(_pwTextField.text.length == 0 && _verifyTextField.text.length == 0) {
        //if password or verify password text are empty, don't show error text
        _pwLengthLabel.text = @"";
        _pwLabel.text = @"";
    }
}
@end
