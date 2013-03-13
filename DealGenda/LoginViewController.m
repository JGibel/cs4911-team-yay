//
//  LoginViewController.m
//  DealGenda
//
//  Created by Kaitlynn Myrick on 3/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

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
    NSString *passwordValue =  [[NSString alloc] initWithFormat:(@"%@", _passwordTextField.text)];
    
    
    
    //identifier to determine which button was pressed
    _buttonID = @"loginButton";
    
    //identifier to determine if the view is in a state allowed to segue
    _canSegue = @"NO";
    
    //Print statements for testing
    NSLog(@"The entered email is: %@", _username);
    NSLog(@"The entered password is: %@", passwordValue);
    
    //Lines to open the Database
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];

    if (![db open]) {
        return;
    }

    //Query pulls all passwords from the users table where the email is equal to the emailValue, set above
    FMResultSet *queryResult = [db executeQuery:@"SELECT * FROM users WHERE email LIKE ?", _username];
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"password"];
        NSLog(@"%@",result);
        if([passwordValue isEqualToString:(result)]) {
            NSLog(@"TRUE");
            appDelegate.username = _username;
            _canSegue = @"YES";
            
        }
        else{
            NSLog(@"FALSE");
            _canSegue = @"NO";

        }
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
