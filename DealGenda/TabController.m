//
//  TabController.m
//  DealGenda
//
//  Created by Douglas Abrams on 4/2/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "TabController.h"
#import "AppDelegate.h"
#import "CouponListViewController.h"
#import "FavoritesViewController.h"
#import "SettingsViewController.h"

@interface TabController ()

@end

@implementation TabController

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
    //set the initial navbar title since the initially loaded view is the coupon list view
    self.navigationItem.title = @"Coupons";
    
    self.navigationItem.rightBarButtonItem.title = @"Logout";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {    
    //reset user login status
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.user = nil;
    //pop view to the login view
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //set the navbar title to the corresponding tab title
    self.navigationItem.title = item.title;
    if ([item.title isEqualToString:@"Coupons"]) {
        //Coupon List is active
        NSLog(@"Coupons");
    } else if ([item.title isEqualToString:@"Favorites"]) {
        //Favorites is active
        NSLog(@"Favorites");
    
    } else if ([item.title isEqualToString:@"Settings"]) {
        //Settings is active
        NSLog(@"Settings");
    }

}

@end
