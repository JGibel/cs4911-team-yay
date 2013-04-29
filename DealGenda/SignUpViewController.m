//
//  SignUpViewController.m
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 2/11/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "SignUpViewController.h"
#import "Queries.h"


@interface SignUpViewController ()

@end

@implementation SignUpViewController


/**
 *Default iOS method
 *Sets any kind of custom data when a new instance of the SignUpViewController is created
 **/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


/**
 *Default iOS method
 *This method is called before the SignUp is loaded onto the screen
 *It currently sets the back button on the navigation bar to display "Back" instead of
 *the title of the previous view.
 **/
-(void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    backButton = nil;
}


/**
 *Default iOS method
 *This method is called when the SignUp is initially loaded onto the screen.  This sets the initial scroll view
 * which will be used to shift the view to prevent the keyboard from covering text fields.  
 *Initializes picker views which will be used for the gender and birth date text fields
 **/
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
    
    
    //Set up Gender Picker with an array. Contains the values "Undisclosed, Male, & Female"
    self.pickerViewArray = [NSArray arrayWithObjects:
                            @"Undisclosed", @"Male", @"Female",
                            nil];
    UIPickerView *genderPicker = [[UIPickerView alloc] init];
    
    genderPicker.delegate = self;
    genderPicker.dataSource = self;
    
    [_genderTextField setInputView:genderPicker];
    

}

/**
 *Default iOS method
 **/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Custom method
 Retract Keyboard Functionality for tapping in the background
 Tie this action to a button the size of the entire view, pushed to the back so that everything else sits on top
 **/
- (IBAction)dismissKeyboard:(id)sender {
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_birthDateTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_verifyPasswordTextField resignFirstResponder];
    [_genderTextField resignFirstResponder];
    
}

/**
 Defailt iOS method.  Listens for the Keyboard notifications in order to prepare the view to scroll when text fields are blocked by the keyboard
 **/

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


/**
 Custom method called when the "Continue Button" is pressed
 Sets the variables from all of the text fields presented to the user.  Runs the validation method in order to validate the user input.  Adds the the information to the database.
 **/

- (IBAction)continueButton:(UIButton *)sender{
    
    //Sets the variables from the information input in the text fields
    _firstName = _firstNameTextField.text;
    _lastName = _lastNameTextField.text;
    _birthDate = _birthDateTextField.text;
    _email = _emailTextField.text;
    _password = _passwordTextField.text;
    _verifyPassword = _verifyPasswordTextField.text;
    _gender = _genderTextField.text;
    
    // Print statements to test the values entered in the input fields are properly assigned to the correct variables
    /*
    NSLog(@"The entered first name is: %@", _firstName);
    NSLog(@"The entered last name is: %@", _lastName);
    NSLog(@"The entered birthdate is: %@", _birthDate);
    NSLog(@"The entered email is: %@", _email);
    NSLog(@"The entered password is: %@", _password);
    NSLog(@"The entered verify password is: %@", _verifyPassword);
    NSLog(@"The entered gender is: %@", _gender);
    */
    [self validateSignUp];
    
    //Resigns first responder to lower the keyboard or date picker
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_birthDateTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_verifyPasswordTextField resignFirstResponder];
    [_genderTextField resignFirstResponder];
    
    //If the can segue variable is set to yes, uses the insert statements contined Queries file to add the user to the database
    if([_canSegue isEqualToString:(@"YES")]){
        
        //Print statement to check if the adding to the database works
        //NSLog(@"added to database");
        
        [Queries addUserWithFName:_firstName LName:_lastName Birthday:_birthDate Email:_email Password:_password Gender:_gender];
        NSNumber *userId = [Queries getId:_email];
        [Queries setLoggedInUser:userId];
    }

}

/**
 This method is called when a segue is triggered
 It determines whether to allow the segue based on the canSegue variable.  The canSegue variable is defined with the buttons based on the state of the information set by the user.  Uses the error code variable to set the appropriate error label
 
 param:identifier - the string identifier of the segue being triggered
 param: sender - the id sending the call for a segue
 
 return:BOOL - YES if the validation method passes. NO if the validation method fails.
 **/

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    // If the can segue variable has been set to yes, allow a segue
    if([_canSegue isEqualToString:(@"YES")]){
        _errorLabel.text = @"";
     //   [Queries addUser: _firstName : _lastName : _birthDate : _email : _password : _gender];
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


/* Custom Method to validate signup
 Takes the user input and validates against several constraints - 
 1. There is information in all required fields
 2. The email is in a valid format
 3. Email already has an account
 4. Password is 6 characters long
 5. Password does not match verify password
 
 Sets the cansegue variable to No if it does not pass the constraints.  Sets the error code to display the correct error code.
 */
-(void) validateSignUp {
//    NSLog(@"validate conditions");
    
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

/*
 Custom Method to Validate email address format
 */
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
//    NSLog(@"Number of Matches: %d", numberOfMatches);
    return numberOfMatches > 0;
}

/*
 Pulls up the Pickers instead of keyboard when appropriate.  
 */
-(void)updateTextField:(id)sender
{
    //Pulls the date picker up for the birth date field
    if([_birthDateTextField isFirstResponder]){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        
        UIDatePicker *picker = (UIDatePicker*)_birthDateTextField.inputView;
        NSString *theDate = [dateFormat stringFromDate:picker.date];
        _birthDateTextField.text = theDate;

    }
    
}

//Set up the custom gender picker.  Sets the number of components to 1
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

//Set up the custom gender picker.  Sets the number of items in each row to 1
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerViewArray count];
}

//Set up the custom gender picker.  Sets the items in the picker to be the variables in the pickerViewArray
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_pickerViewArray objectAtIndex:row];
}

//Sets the text in the gender text field to be equal to that contained within the picker
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {    
    _genderTextField.text = [_pickerViewArray objectAtIndex:row];
}



//Code to perform the sliding when the bottom text fields are selected so they are not blocked by the keyboard
//Slides the frame up when covered text fields are active
-(IBAction) slideFrameUp;
{
    [self slideFrame:YES];
}

//Code to perform the sliding when the bottom text fields are selected so they are not blocked by the keyboard
//Slides the frame down when covered text fields become inactive
-(IBAction) slideFrameDown;
{
    [self slideFrame:NO];
}

//Code to determine length of view slide when keyboard blocks currently active text fields.
-(void) slideFrame:(BOOL) up
{
    const int movementDistance = 205;
    const float movementDuration = 0.3f; 
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

/**
 This method will retract the keyboard when the return button is pressed on the keyboard
 
 param: textField - the textField attached to the keyboard which is visible
 
 return:BOOL - YES if the keyboard is retracted
 
 **/

-(BOOL)textFieldShouldReturn:(UITextView *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
