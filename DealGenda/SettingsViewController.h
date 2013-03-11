//
//  SettingsViewController.h
//  DealGenda
//
//  Created by Jenelle Walker on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
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
@property (nonatomic) FMDatabase *db;

- (IBAction)saveSettings:(id)sender;


@end
