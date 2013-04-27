//
//  LoginViewController.h
//  DealGenda
//
//  Created by Kaitlynn Myrick on 3/11/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *passwordValue;
@property (strong, nonatomic) NSString *canSegue;
@property (strong, nonatomic) NSString *buttonID;


- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)loginButton:(UIButton *)sender;
- (IBAction)signUpButton:(id)sender;

@end
