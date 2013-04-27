//
//  DetailsViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 4/7/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "DetailsViewController.h"
#import "Queries.h"
#import <PassKit/PassKit.h>
#import "ExtensionViewController.h"

@interface DetailsViewController () <PKAddPassesViewControllerDelegate>

@end

@implementation DetailsViewController

@synthesize barcode;

/**
 *Default iOS method
 *Sets any kind of custom data when a new instance of the ExtensionViewController is created
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
 *the title of the previous view.  It then tests to see if the pass has already been 
 *downloaded to Passbook and adjusts the visible controls accordingly.  It then sets
 *the label texts based on the current coupon.
 **/
-(void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    backButton = nil;
    
    //create pass file - hardcoded based on name
    NSString* passFile = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"PassSource.pkpass"];
    NSData *passData = [NSData dataWithContentsOfFile:passFile];
    NSError* error = nil;
    PKPass *newPass = [[PKPass alloc] initWithData:passData
                                             error:&error];
    //test to see if the pass is in Passbook already
    if ([PKPassLibrary isPassLibraryAvailable]) {
        PKPassLibrary *lib = [[PKPassLibrary alloc] init];
        if ([lib containsPass:newPass]) {
            _addButton.hidden = YES;
        }
    }
    
    //set label texts
    _retailerLabel.text = [Queries getCouponRetailer:barcode];
    _offerLabel.text = [Queries getCouponOffer:barcode];
    _expDateLabel.text = [Queries getCouponExpirationDate:barcode];
    _detailsTextView.text = [Queries getCouponDetails:barcode];
}

/**
 *Default iOS method
 *This method is called when the PaymentView is initially loaded onto the screen
 **/
- (void)viewDidLoad
{
    [super viewDidLoad];
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
 **author: Douglas Abrams - based on tutorial by Marin Todorov
 *
 *This method creates an instance of a pass based on the input file name
 *and displays that pass in a PKAddPassesViewController
 *
 **param:name - the filename of the pass file
 **/
-(void)openPassWithName:(NSString*)name
{
    //create pass file - hardcoded based on name
    NSString* passFile = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent: name];
    NSData *passData = [NSData dataWithContentsOfFile:passFile];
    NSError* error = nil;
    PKPass *newPass = [[PKPass alloc] initWithData:passData
                                             error:&error];
    //tests to see if there was an error retrieving the pass
    if (error!=nil) {
        [[[UIAlertView alloc] initWithTitle:@"Passes error"
                                    message:[error
                                             localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"Ooops"
                          otherButtonTitles: nil] show];
        return;
    }
    
    //view pass
    PKAddPassesViewController *addController =
    [[PKAddPassesViewController alloc] initWithPass:newPass];
    
    addController.delegate = self;
    [self presentViewController:addController
                       animated:YES
                     completion:nil];
}

/**
 *This method is called when either the Add or Cancel buttons of the 
 *PKPassesViewController is pressed
 *
 **param:controller - the view controller displaying the pass
 **/
-(void)addPassesViewControllerDidFinish: (PKAddPassesViewController*) controller
{
    //pass added
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self hasPassWithName:@"PassSource.pkpass"]) {
        _addButton.hidden = YES;
    }
}

/**
 *Custom method
 **author: Douglas Abrams
 **/
- (IBAction)addPass:(id)sender {
    [self openPassWithName:@"PassSource.pkpass"];
}

- (IBAction)openPassbook:(id)sender {
    NSString* passFile = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"PassSource.pkpass"];
    
    NSData *passData = [NSData dataWithContentsOfFile:passFile];
    
    NSError* error = nil;
    PKPass *newPass = [[PKPass alloc] initWithData:passData
                                             error:&error];
    if ([PKPassLibrary isPassLibraryAvailable]) {
        PKPassLibrary *lib = [[PKPassLibrary alloc] init];
        if ([lib containsPass:newPass]) {
            [[UIApplication sharedApplication] openURL:[[lib passWithPassTypeIdentifier:[newPass passTypeIdentifier] serialNumber:[newPass serialNumber]] passURL]];

        }
    }
}

- (BOOL)hasPassWithName:(NSString *)name {
    NSString* passFile = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"PassSource.pkpass"];
    
    NSData *passData = [NSData dataWithContentsOfFile:passFile];
    
    NSError* error = nil;
    PKPass *newPass = [[PKPass alloc] initWithData:passData
                                             error:&error];
    if ([PKPassLibrary isPassLibraryAvailable]) {
        PKPassLibrary *lib = [[PKPassLibrary alloc] init];
        if ([lib containsPass:newPass]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([identifier isEqualToString:@"extensionSegue"]){
        if (![Queries couponHasBeenExtended:self.barcode]) {
            return YES;
        } else {
            NSString *extendMessage = [[NSString alloc] initWithFormat:@"The coupon with barcode %@ has already been extended", self.barcode];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coupon Extended" message:extendMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    /* If the segue is pushing to the CouponDetailsView*/
    if([segue.identifier isEqualToString:@"extensionSegue"]){
        if (![Queries couponHasBeenExtended:self.barcode]) {
            //get instance of view controller we are pushing to
            ExtensionViewController *controller = segue.destinationViewController;
            //set the barcode value for the view controller we are navigating to
            controller.barcode = self.barcode;
        } 
    }
}

@end
