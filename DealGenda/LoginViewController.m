//
//  LoginViewController.m
//  DealGenda
//
//  Created by Kaitlynn Myrick on 3/11/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Queries.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    _emailTextField.text = @"";
    _passwordTextField.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Retract Keyboard Functionality for tapping in the background
// Tie this action to a button the size of the entire view, pushed to the back so that everything else sits on top
- (IBAction)dismissKeyboard:(id)sender {
    
    // Causes the keyboard to retract if the emailTextField is active
    [_emailTextField resignFirstResponder];
    
    // Causes the keyboard to retract if the passwordTextField is active
    [_passwordTextField resignFirstResponder];
}

- (IBAction)loginButton:(UIButton *)sender {
    
    //NSString *emailValue =  [[NSString alloc] initWithFormat:(@"%@", _emailTextField.text)];
    _username = _emailTextField.text;
    _passwordValue = _passwordTextField.text;
    
    
    
    //identifier to determine which button was pressed
    _buttonID = @"loginButton";
    
    //identifier to determine if the view is in a state allowed to segue
    _canSegue = @"NO";
    
    //Print statements for testing
    NSLog(@"The entered email is: %@", _username);
    NSLog(@"The entered password is: %@", _passwordValue);
    
    //Lines to open the Database
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];

    if (![db open]) {
        return;
    }
    
    if([Queries validateEmail:_username] && [Queries validatePassword:_username : _passwordValue]) {
        NSLog(@"TRUE");
        appDelegate.user = [Queries getId:_username];
        _canSegue = @"YES";
    } else {
        NSLog(@"FALSE");
        _canSegue = @"NO";
    }
    
    if([_canSegue isEqualToString:(@"NO")] && [_buttonID isEqualToString:(@"loginButton")]){
        _errorLabel.textColor = [UIColor redColor];
        _errorLabel.text = @"Incorrect Email or Password";
    }
    if([_canSegue isEqualToString:(@"YES")]){
        _errorLabel.text = @"";
    }
    
    [db close];
    
}

- (IBAction)signUpButton:(id)sender;{
    _emailTextField.text = @"";
    _passwordTextField.text = @"";
    
    _username = _emailTextField.text;
    _passwordValue = _passwordTextField.text;
    
    _canSegue = @"YES";
    
    _buttonID = @"signUpButton";
    _errorLabel.text = @"";
}

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

//Keyboard Retracting

-(BOOL)textFieldShouldReturn:(UITextView *)textField{
    if(_emailTextField.isFirstResponder){
        [_emailTextField resignFirstResponder];
    }
    
    if(_passwordTextField.isFirstResponder){
        [_passwordTextField resignFirstResponder];
    }
    
    return YES;
}





@end
