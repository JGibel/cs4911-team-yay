//
//  SignUpViewController.h
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 2/11/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritesViewController.h"

@interface SignUpViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UIScrollView *scrollView;
    
}

//Storyboard Elements
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


-(IBAction) dismissKeyboard:(id)sender;
-(IBAction) slideFrameUp;
-(IBAction) slideFrameDown;
-(IBAction)continueButton:(UIButton *)sender;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *birthDate;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *verifyPassword;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *canSegue;
@property (strong, nonatomic) NSString *errorCode;
@property (nonatomic, retain) NSArray *pickerViewArray;



@end
