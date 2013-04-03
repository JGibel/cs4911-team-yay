//
//  TabController.h
//  DealGenda
//
//  Created by Douglas Abrams on 4/2/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabController : UITabBarController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
- (IBAction)logout:(id)sender;

@end
