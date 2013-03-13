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

- (IBAction)dismissKeyboard:(id)sender {
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (IBAction)loginButton:(UIButton *)sender {
    NSString *emailValue =  [[NSString alloc] initWithFormat:(@"%@", _emailTextField.text)];
    NSString *passwordValue =  [[NSString alloc] initWithFormat:(@"%@", _passwordTextField.text)];

    NSLog(@"The entered email is: %@", emailValue);
    NSLog(@"The entered password is: %@", passwordValue);

    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];

    if (![db open]) {
        return;
    }
    
    
//    BOOL userExists = NO;
//    BOOL passwordCorrect = NO;
//    FMResultSet *queryResult = [db executeQuery:@"SELECT email FROM users"];
//    
//    while ([queryResult next]) {
//        NSString *users = [queryResult stringForColumn:@"email"];
//        NSLog(users);
//        if([users isEqualToString:(emailValue)]) {
//            userExists = YES;
//            
//            FMResultSet *passwordQueryResult = [db executeQuery:@"SELECT * FROM user WHERE password LIKE ?", queryResult];
//
//            NSString* passwords = [queryResult stringForColumn:@"password"];
//            if([passwords isEqualToString:passwordValue]) {
//            BOOL passwordCorrect = YES;
//        }
//        
//    }
//
//    NSLog(@"Email Bool value: %d",userExists);
//    NSLog(@"Password Bool value: %d",passwordCorrect);
//
//
//    }

    
    
//    FMResultSet *queryResult = [db executeQuery:@"SELECT * FROM users WHERE user LIKE ?", emailValue];
//    NSString *result = [queryResult stringForColumn:@"password"];
//    NSLog(result);

    FMResultSet *queryResult = [db executeQuery:@"SELECT * FROM users WHERE email LIKE ?", emailValue];
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"password"];
        NSLog(result);
        if([passwordValue isEqualToString:(result)]) {
            NSLog(@"TRUE");
            _loggedIn = @"YES";
        }
        else{
            NSLog(@"FALSE");
            _loggedIn = @"NO";

        }
    }
    
    [db close];
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([_loggedIn isEqualToString:(@"YES")]){
        return YES;
    }
    
    else{
        return NO;
    }
}


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
