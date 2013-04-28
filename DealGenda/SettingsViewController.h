//
//  SettingsViewController.h
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 2/11/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwLengthLabel;
@property (weak) UITextField *activeField;
@property (weak) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (retain) IBOutlet UIButton *saveButton;
@property (retain) IBOutlet UIButton *resignButton;

- (IBAction)saveSettings:(id)sender;
- (IBAction)resignButton:(id)sender;

@end
