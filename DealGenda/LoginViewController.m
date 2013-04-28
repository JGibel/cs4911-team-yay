//
//  LoginViewController.m
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 3/11/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Queries.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


/**
 *Default iOS method
 *Sets any kind of custom data when a new instance of the LoginViewController is created
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
 *This method is called before the LoginView is loaded onto the screen
 *It currently sets the back button on the navigation bar to display "Back" instead of
 *the title of the previous view. Resets the email and password textfields to be blank
 **/
-(void)viewWillAppear:(BOOL)animated{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    backButton = nil;
    
    //Reset the email and password text fields to be blank
    _emailTextField.text = @"";
    _passwordTextField.text = @"";
}

/**
 *Default iOS method
 *This method is called when the LoginView is initially loaded onto the screen
 **/

- (void)viewDidLoad
{
    [super viewDidLoad];    

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
    
    // Causes the keyboard to retract if the emailTextField is active
    [_emailTextField resignFirstResponder];
    
    // Causes the keyboard to retract if the passwordTextField is active
    [_passwordTextField resignFirstResponder];
}

/**
Custom method called when the "Login Button" is pressed
Takes the data input in the email and password and checks against the database
If the login information matchs what is contained within the database, it will push the user to the coupon list view.  
If the information does match, it prevents the segue and displays error text to provide feedback to the user.
**/

- (IBAction)loginButton:(UIButton *)sender {
    
    //Sets the variables username and passwordValue to the information contained within the email text field and the password text field
    
    _username = _emailTextField.text;
    _passwordValue = _passwordTextField.text;
    
    //identifier to determine which button was pressed
    _buttonID = @"loginButton";
    
    //identifier to determine if the view is in a state allowed to segue
    _canSegue = @"NO";
    
    /**Print statements for testing the values of usernme and passwordValue
    NSLog(@"The entered email is: %@", _username);
    NSLog(@"The entered password is: %@", _passwordValue);
    **/
    
    //Lines to open the test Database
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];

    if (![db open]) {
        return;
    }
    
    /** 
    Runs the validateEmail query contained within Queries.m against the username variable
    Runs the validatePassword query contained within Queries.m against the passwordValue variable
     
    If the queries return True, set the global user variable to the username & set the canSegue variable to YES.  This will allow segues to be performed.
     
    If the queries return False, set the canSegue variable to NO.  This will prevent segues from being performed.
    **/
    if([Queries validateEmail:_username] && [Queries validatePassword:_username : _passwordValue]) {
        //Print statement used to test queries are properly validating
        //NSLog(@"TRUE");
        
        appDelegate.user = [Queries getId:_username];
        _canSegue = @"YES";
        
    } else {
        //Print statement used to test queries are properly failing validation
        //NSLog(@"FALSE");
        
        _canSegue = @"NO";
    }
    
    //If the canSegue variable is set to No, display error text to the user.  
    if([_canSegue isEqualToString:(@"NO")] && [_buttonID isEqualToString:(@"loginButton")]){
        
        //Sets the color and text of the error label that will appear if the segue is prevented
        _errorLabel.textColor = [UIColor redColor];
        _errorLabel.text = @"Incorrect Email or Password";
    }
    
    //If the segue is allowed, set the error label to be blank.
    if([_canSegue isEqualToString:(@"YES")]){
        _errorLabel.text = @"";
    }
    
    [db close];
    
}

/**
 Custom method called when the "Sign Up Button" is pressed
 This erases the email and password text fields, reset the variables, and sets the canSegue variable to be YES.  Also removes all error text that is currently displayed 
 **/

- (IBAction)signUpButton:(id)sender;{
    _emailTextField.text = @"";
    _passwordTextField.text = @"";
    
    _username = _emailTextField.text;
    _passwordValue = _passwordTextField.text;
    
    _canSegue = @"YES";
    
    _buttonID = @"signUpButton";
    _errorLabel.text = @"";
}

/**
This method is called when a segue is triggered
It determines whether to allow the segue based on the canSegue variable.  The canSegue variable is defined with the buttons based on the state of the information set by the user

param:identifier - the string identifier of the segue being triggered
param: sender - the id sending the call for a segue

return:BOOL - YES if the login information is valid or if the signup button is pushed. NO if the login information is not valid
**/

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([_buttonID isEqualToString:(@"signUpButton")]){
        return YES;
    }
    
    if([_canSegue isEqualToString:(@"YES")] && [_buttonID isEqualToString:(@"loginButton")]){
        return YES;
    }
    
    if([_canSegue isEqualToString:(@"NO")] && [_buttonID isEqualToString:(@"loginButton")]){
        return NO;
    }
    
    else{        
        return YES;
    }
}

/**
This method will retract the keyboard when the return button is pressed on the keyboard 
 
 param: textField - the textField attached to the keyboard which is visible
 
 return:BOOL - YES if the keyboard is retracted
 
 **/

-(BOOL)textFieldShouldReturn:(UITextView *)textField{
    
    // Causes the keyboard to retract if the emailTextField is active
    if(_emailTextField.isFirstResponder){
        [_emailTextField resignFirstResponder];
    }
    
    // Causes the keyboard to retract if the passwordTextField is active
    if(_passwordTextField.isFirstResponder){
        [_passwordTextField resignFirstResponder];
    }
    
    return YES;
}

@end
