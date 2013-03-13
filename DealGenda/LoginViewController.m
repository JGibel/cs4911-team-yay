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

//Keyboard Retracting
- (IBAction)dismissKeyboard:(id)sender {
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (IBAction)loginButton:(UIButton *)sender {
    
    NSString *emailValue =  [[NSString alloc] initWithFormat:(@"%@", _emailTextField.text)];
    NSString *passwordValue =  [[NSString alloc] initWithFormat:(@"%@", _passwordTextField.text)];
    _buttonID = @"loginButton";
     _canSegue = @"NO";
    
    NSLog(@"The entered email is: %@", emailValue);
    NSLog(@"The entered password is: %@", passwordValue);
    
    //Lines to open the Database
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];

    if (![db open]) {
        return;
    }

    FMResultSet *queryResult = [db executeQuery:@"SELECT * FROM users WHERE email LIKE ?", emailValue];
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"password"];
        NSLog(result);
        if([passwordValue isEqualToString:(result)]) {
            NSLog(@"TRUE");
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
