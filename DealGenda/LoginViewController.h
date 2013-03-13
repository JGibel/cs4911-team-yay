//
//  LoginViewController.h
//  DealGenda
//
//  Created by Kaitlynn Myrick on 3/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

//temp
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *loggedIn;



- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)loginButton:(UIButton *)sender;

@end
