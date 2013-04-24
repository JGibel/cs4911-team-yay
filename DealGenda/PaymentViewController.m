//
//  PaymentViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 4/24/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

@synthesize barcode;
@synthesize expDate;
@synthesize extendedExpDate;
@synthesize paymentMethod;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    backButton = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_barcodeLabel.text = barcode;
    _expLabel.text = expDate;
    _extendedExpLabel.text = extendedExpDate;
    _paymentLabel.text = paymentMethod;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)extendCoupon:(id)sender {
    NSString *extendMessage = [[NSString alloc] initWithFormat:@""];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coupon Extended" message:extendMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
@end
