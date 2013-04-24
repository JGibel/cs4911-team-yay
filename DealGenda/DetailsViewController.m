//
//  DetailsViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 4/7/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "DetailsViewController.h"
#import "Queries.h"
#import <PassKit/PassKit.h>
#import "ExtensionViewController.h"

@interface DetailsViewController () <PKAddPassesViewControllerDelegate>

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
    
    NSString* passFile = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"PassSource.pkpass"];
    
    NSData *passData = [NSData dataWithContentsOfFile:passFile];
    
    NSError* error = nil;
    PKPass *newPass = [[PKPass alloc] initWithData:passData
                                             error:&error];
    if ([PKPassLibrary isPassLibraryAvailable]) {
        PKPassLibrary *lib = [[PKPassLibrary alloc] init];
        if ([lib containsPass:newPass]) {
            _addButton.hidden = YES;
        }
    }
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

-(void)openPassWithName:(NSString*)name
{
    //2
    NSString* passFile = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent: name];
    
    //3
    NSData *passData = [NSData dataWithContentsOfFile:passFile];
    
    //4
    NSError* error = nil;
    PKPass *newPass = [[PKPass alloc] initWithData:passData
                                             error:&error];
    //5
    if (error!=nil) {
        [[[UIAlertView alloc] initWithTitle:@"Passes error"
                                    message:[error
                                             localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"Ooops"
                          otherButtonTitles: nil] show];
        return;
    }
    
    //6
    PKAddPassesViewController *addController =
    [[PKAddPassesViewController alloc] initWithPass:newPass];
    
    addController.delegate = self;
    [self presentViewController:addController
                       animated:YES
                     completion:nil];
}

#pragma mark - Pass controller delegate

-(void)addPassesViewControllerDidFinish: (PKAddPassesViewController*) controller
{
    //pass added
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self hasPassWithName:@"PassSource.pkpass"]) {
        _addButton.hidden = YES;
    }
}

- (IBAction)addPass:(id)sender {
//    [self openPassWithName:@"GenericPass.pkpass"];
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
