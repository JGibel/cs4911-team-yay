//
//  SignUpViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    backButton = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [scrollView setScrollEnabled:YES];
    scrollView.contentSize = CGSizeMake(320, 320);
    
    /*
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [_birthDateTextField setInputView:datePicker];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyboard:(id)sender {
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_birthDateTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_verifyPasswordTextField resignFirstResponder];
    [_genderTextField resignFirstResponder];
    
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

- (IBAction)continueButton:(UIButton *)sender{
    _firstName = _firstNameTextField.text;
    _lastName = _lastNameTextField.text;
    _birthDate = _birthDateTextField.text;
    _email = _emailTextField.text;
    _password = _passwordTextField.text;
    _verifyPassword = _verifyPasswordTextField.text;
    _gender = _genderTextField.text;
    
    NSLog(@"The entered first name is: %@", _firstName);
    NSLog(@"The entered last name is: %@", _lastName);
    NSLog(@"The entered birthdate is: %@", _birthDate);
    NSLog(@"The entered email is: %@", _email);
    NSLog(@"The entered password is: %@", _password);
    NSLog(@"The entered verify password is: %@", _verifyPassword);
    NSLog(@"The entered gender is: %@", _gender);
    
    [self validateSignUp];
    
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_birthDateTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_verifyPasswordTextField resignFirstResponder];
    [_genderTextField resignFirstResponder];

}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    // If the can segue variable has been set to yes, allow a segue
    if([_canSegue isEqualToString:(@"YES")]){
        _errorLabel.text = @"";
        return YES;
    }
    
    // If the can segue variable has been set to no in order to prevent a segue
    if([_canSegue isEqualToString:(@"NO")]){
        
        //Set label for missing required fields
        if([_errorCode isEqualToString:(@"Required")]){
            _errorLabel.textColor = [UIColor redColor];
            _errorLabel.text = @"Missing Required Fields";
            return NO;
        }

        //Set label for password being too short
        if([_errorCode isEqualToString:(@"PasswordLength")]){
            _errorLabel.textColor = [UIColor redColor];
            _errorLabel.text = @"Password must be at least 6 characters";
            return NO;
        }
        
        //Set label for password not matching verify password
        if([_errorCode isEqualToString:(@"VerifyPassword")]){
            _errorLabel.textColor = [UIColor redColor];
            _errorLabel.text = @"Password must match Verify Password";
            return NO;
        }
        
        //Set label for invalid email address
        if([_errorCode isEqualToString:(@"ValidEmail")]){
            _errorLabel.textColor = [UIColor redColor];
            _errorLabel.text = @"Please enter a valid email address";
            return NO;
        }
        
        else{
            return NO;
        }
    }
    
    else{
        return NO;
    }
}

-(void) validateSignUp {
    NSLog(@"validate conditions");
    
    //Determine whether there is information in the required fields
    if([_firstName isEqual: @""] || [_lastName isEqual: @""] || [_email isEqual: @""] || [_password isEqual:@""] || [_verifyPassword isEqual: @""]){
        _canSegue = @"NO";
        _errorCode = @"Required";
        return;
    }
    
    //Email address is not valid
    if (_emailTextField.text.length < 5) {
        _canSegue = @"NO";
        _errorCode = @"ValidEmail";
        return;
    }
    
    //Ensure the password is at least 6 characters long
    if((_password.length < 6)){
        _canSegue = @"NO";
        _errorCode = @"PasswordLength";
        return;
    }
    
    //Password does not match verify passwords
    if(![_password isEqualToString: _verifyPassword]){
        _canSegue = @"NO";
        _errorCode = @"VerifyPassword";
        return;
    }
    
    else{
        _canSegue = @"YES";
    }
    
}

/*
-(void)updateTextField:(id)sender
{
    if([_birthDateTextField isFirstResponder]){
        UIDatePicker *picker = (UIDatePicker*)_birthDateTextField.inputView;
        _birthDateTextField.text = [NSString stringWithFormat:@"%@",picker.date];
    }

}*/


//Code to perform the sliding when the bottom text fields are selected so they are not blocked by the keyboard
-(IBAction) slideFrameUp;
{
    [self slideFrame:YES];
}

-(IBAction) slideFrameDown;
{
    [self slideFrame:NO];
}

-(void) slideFrame:(BOOL) up
{
    const int movementDistance = 213; 
    const float movementDuration = 0.3f; 
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextView *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
