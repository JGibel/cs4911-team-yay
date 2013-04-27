//
//  TabController.m
//  DealGenda
//
//  Created by Douglas Abrams on 4/2/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "TabController.h"
#import "AppDelegate.h"

@interface TabController ()

@end

@implementation TabController

/**
 *Default iOS method
 *Sets any kind of custom data when a new instance of the TabController is created
 **/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *Default iOS method
 *This method is called when the TabController is initially loaded onto the screen
**/
- (void)viewDidLoad
{
    [super viewDidLoad];
    //set the initial navbar title since the initially loaded view is the coupon list view
    self.navigationItem.title = @"Coupons";
    
    self.navigationItem.rightBarButtonItem.title = @"Logout";
}

/**
 *Default iOS method
 **/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *Custom method
 **author: Douglas Abrams
 *
 *This method is called when the logout button in the navigation bar is pressed
 *It clears the data for the current user and navigates back to the login view
 **/
- (IBAction)logout:(id)sender {    
    //reset user login status
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.user = nil;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *This method is called when an item in the tab bar is selected
 *It sets the title of the navigation bar to the corresponding view
 *
 **param:tabBar - the tab bar at the bottom of the view
 **param:item - the tab bar item that was selected
 **/
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //set the navbar title to the corresponding tab title
    self.navigationItem.title = item.title;
}

@end
