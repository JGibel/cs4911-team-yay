//
//  DetailsViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 4/7/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "DetailsViewController.h"
#import "Queries.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize barcode;

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
    //set the labels based on the barcode value passed from the CouponListView
    _retailerLabel.text = [Queries getCouponRetailer:barcode];
    _offerLabel.text = [Queries getCouponOffer:barcode];
    _expDateLabel.text = [Queries getCouponExpirationDate:barcode];
    _detailsTextView.text = [Queries getCouponDetails:barcode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
