//
//  PaymentViewController.m
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 4/24/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "PaymentViewController.h"
#import "CouponListViewController.h"
#import "Queries.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

@synthesize barcode;
@synthesize expDate;
@synthesize extendedExpDate;
@synthesize paymentMethod;

/**
 *Default iOS method
 *Sets any kind of custom data when a new instance of the PaymentViewController is created
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
 *This method is called before the PaymentView is loaded onto the screen
 *It currently sets the back button on the navigation bar to display "Back" instead of
 *the title of the previous view.
 **/
-(void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    backButton = nil;
}

/**
 *Default iOS method
 *This method is called when the PaymentView is initially loaded onto the screen
 *It currently sets the label text based on the view controller properties that 
 *were set when creating an instance of this view controller
 **/
- (void)viewDidLoad
{
    [super viewDidLoad];
	_barcodeLabel.text = barcode;
    _expLabel.text = expDate;
    _extendedExpLabel.text = extendedExpDate;
    _paymentLabel.text = paymentMethod;
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
 *This method is called when the "Assume payment and extend" button is pressed
 *It runs a query to update the coupon's barcode and expiration date columns then
 *displays an alert to the user that the coupon's barcode has been extended and navigates
 *back to the details for that coupon
 **/
- (IBAction)extendCoupon:(id)sender {
    //run query to extend coupon
    [Queries updateCoupon:barcode expDate:extendedExpDate];
    
    //display alert
    NSString *extendMessage = [[NSString alloc] initWithFormat:@""];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coupon Extended" message:extendMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
    //pop view controllers back to details
    int count = [self.navigationController.viewControllers count];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count-3] animated:YES];
}
@end
