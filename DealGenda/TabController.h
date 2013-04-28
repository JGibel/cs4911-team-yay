//
//  TabController.h
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 4/2/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabController : UITabBarController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
- (IBAction)logout:(id)sender;

@end
