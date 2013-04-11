//
//  SignUpViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "SignUpViewController.h"
#import "Queries.h"


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

    //Set up scroll functionaity to prevent keyboard from hiding fields
    [scrollView setScrollEnabled:YES];
    scrollView.contentSize = CGSizeMake(320, 320);
    
    //Set up birth date date picker
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [_birthDateTextField setInputView:datePicker];
    
    //Set up Gender Picker
    self.pickerViewArray = [NSArray arrayWithObjects:
                            @"Undisclosed", @"Male", @"Female",
                            nil];
    UIPickerView *genderPicker = [[UIPickerView alloc] init];
    
    genderPicker.delegate = self;
    genderPicker.dataSource = self;
    
    [_genderTextField setInputView:genderPicker];
    

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
            _errorLabel.text = @"Missing Information in Required Fields";
            return NO;
        }

        //Set label for invalid email address
        if([_errorCode isEqualToString:(@"ValidEmail")]){
            _errorLabel.textColor = [UIColor redColor];
            _errorLabel.text = @"Please enter a valid email address";
            return NO;
        }
        
        //Set label for invalid email address
        if([_errorCode isEqualToString:(@"EmailExists")]){
            _errorLabel.textColor = [UIColor redColor];
            _errorLabel.text = @"Email Address already has an account";
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
    if ([self validateInputWithString:_emailTextField] == NO) {
        _canSegue = @"NO";
        _errorCode = @"ValidEmail";
        return;
    }
    
    //Email address already has an account
    if ([Queries validateEmail:_email] == YES) {
        _canSegue = @"NO";
        _errorCode = @"EmailExists";
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

//Validates email address format
- (BOOL)validateInputWithString:(UITextField *)aTextField {
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
    NSLog(@"Number of Matches: %d", numberOfMatches);
    return numberOfMatches > 0;
}

//Pulls up the Pickers instead of keyboard when appropriate
-(void)updateTextField:(id)sender
{
    if([_birthDateTextField isFirstResponder]){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        
        UIDatePicker *picker = (UIDatePicker*)_birthDateTextField.inputView;
        NSString *theDate = [dateFormat stringFromDate:picker.date];
        _birthDateTextField.text = theDate;

    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerViewArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_pickerViewArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {    
    _genderTextField.text = [_pickerViewArray objectAtIndex:row];
}

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

//close keyboard when return key is pressed
-(BOOL)textFieldShouldReturn:(UITextView *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
