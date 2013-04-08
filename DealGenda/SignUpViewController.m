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
    _scrollView.contentSize = CGSizeMake(320, 640);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)returned:(UIStoryboardSegue *)segue {
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
    _birthDate = _birthDateTextField.text;
    
    NSLog(@"The entered first name is: %@", _firstName);
    NSLog(@"The entered last name is: %@", _lastName);
    NSLog(@"The entered birthdate is: %@", _birthDate);
    NSLog(@"The entered email is: %@", _email);
    NSLog(@"The entered password is: %@", _password);
    NSLog(@"The entered verify password is: %@", _verifyPassword);
    NSLog(@"The entered gender is: %@", _gender);
    
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
    const int movementDistance = 213; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
