//
//  DetailsViewController.m
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 4/7/13.
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
@synthesize passes;

/**
 *Default iOS method
 *Sets any kind of custom data when a new instance of the DetailsViewController is created
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
    
    //create pass file
    NSString *passName = [[NSString alloc] initWithFormat:@"%@.pkpass", barcode];
    NSString* passFile = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:passName];
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
 *This method is called when the DetailsView is initially loaded onto the screen
 **/
- (void)viewDidLoad
{
    [super viewDidLoad];
    passes = [[NSMutableArray alloc] init];
    
    //2 load the passes from the resource folder
    NSString* resourcePath =
    [[NSBundle mainBundle] resourcePath];
    
    NSArray* passFiles = [[NSFileManager defaultManager]
                          contentsOfDirectoryAtPath:resourcePath
                          error:nil];
    
    //3 loop over the resource files
    for (NSString* passFile in passFiles) {
        if ( [passFile hasSuffix:@".pkpass"] ) {
            [passes addObject: passFile];
        }
    }
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
    NSString *passName = [[NSString alloc] initWithFormat:@"%@.pkpass", barcode];
    if ([self hasPassWithName:passName]) {
        _addButton.hidden = YES;
    }
}

/**
 *Custom method
 **author: Douglas Abrams
 *
 *This method is called when the Add to Passbook button is pressed
 *It calls the openPassWithName method - currently hardcoded to display one pass
 **/
- (IBAction)addPass:(id)sender {
    NSString *passName = [[NSString alloc] initWithFormat:@"%@.pkpass", barcode];
    [self openPassWithName:passName];
}

/**
 *Custom method
 **author: Douglas Abrams
 *
 *This method is called when the Open in Passbook button is pressed
 *It creates an instance of a pass based on the hardcoded test pass and then
 *launches the Passbook application to the location of that pass
 **/
- (IBAction)openPassbook:(id)sender {
    NSString *passName = [[NSString alloc] initWithFormat:@"%@.pkpass", barcode];
    NSString* passFile = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:passName];
    
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

/**
 *Custom method
 **author: Douglas Abrams
 *
 *This method detects if a pass is currently downloaded to Passbook
 *
 **param:NSString - the name of the pass being tested
 *
 **return:BOOL - TRUE if the pass is currently in Passbook
 **/
- (BOOL)hasPassWithName:(NSString *)name {
    NSString* passFile = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:name];
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

/**
 *This method is called when a segue is triggered
 *It determines whether to allow the segue based on if the coupon has already been extended
 *
 **param:identifier - the string identifier of the segue being triggered
 **param: sender - the id sending the call for a segue
 *
 **return:BOOL - TRUE if the coupon has not already been extended
 **/
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([identifier isEqualToString:@"extensionSegue"]){
        if (![Queries couponHasBeenExtended:self.barcode]) {
            return YES;
        } else {
            NSString *extendMessage = [[NSString alloc] initWithFormat:@"The coupon with barcode %@ has already been extended.  Coupons can only be extended once.", self.barcode];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coupon Already Extended" message:extendMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

/**
 *This method is called when a segue is triggered
 *It creates an instance of the ExtensionViewController and sets the parameters 
 *for that view controller to the appropriate values based on the current coupon
 *
 **param:segue - the segue being triggered
 **param:sender - the id sending the call for a segue
 **/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
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
