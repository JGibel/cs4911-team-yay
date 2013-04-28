//
//  ExtensionViewController.m
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 4/22/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "ExtensionViewController.h"
#import "Queries.h"
#import "PaymentViewController.h"

@interface ExtensionViewController ()

@end

@implementation ExtensionViewController

@synthesize selectedRow;
@synthesize extensionLength;
@synthesize barcode;
@synthesize threeDays;
@synthesize fiveDays;
@synthesize sevenDays;

/**
 *Default iOS method
 *Sets any kind of custom data when a new instance of the ExtensionViewController is created
 **/
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

/**
 *Default iOS method
 *This method is called before the ExtensionView is loaded onto the screen
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
 *This method is called when the ExtensionView is initially loaded onto the screen
 *It currently sets the default extension time to 3 days
 **/
- (void)viewDidLoad
{
    [super viewDidLoad];
    threeDays = 24 * 60 * 60 * 3;
    fiveDays = 24 * 60 * 60 * 5;
    sevenDays = 24 * 60 * 60 * 7;
    extensionLength = threeDays;
    selectedRow = 0;
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
 *This method is called whenever the table view is loaded
 *
 **param:tableView - the table view in the ExtensionView
 *
 **return:NSInteger - the number of grouped sections in the table view
 **/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

/**
 *This method is called whenever the table view is loaded
 *
 **param:tableView - the table view in the ExtensionView
 **param:section - the grouped section of the table view
 *
 **return:NSInteger - the number of rows in each given section of the table view
 **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 0;
    } else if (section == 2) {
        return 2;
    }
    return 1;
}

/**
 *This method is called whenever the table view is loaded
 *It determines what is loaded in each cell of the table view
 *
 **param:tableView - the table view in the ExtensionView
 **param:indexPath - the node path leading to each section of the table view
 *
 **return:UITableViewCell - the formatted cell for the table view
 **/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"extensionLengthCell";
    static NSString *CellIdentifier2 = @"expirationDateCell";
    static NSString *CellIdentifier3 = @"paymentMethodCell";
    NSString *identityString = @"";
    
    //sets the identifiers for each grouped section of the table view
    switch ([indexPath section]) {
        case 0: {
            identityString = CellIdentifier1;
            break;
        }
        case 1: {
            identityString = CellIdentifier2;
            break;
        }
        case 2: {
            identityString = CellIdentifier3;
            break;
        }
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityString];
    
    //sets the static data for the first grouped section
    if ([indexPath section] == 0) {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier1];
        }
        //sets the selected row's accessory type to a checkmark
        if (self.selectedRow == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        //sets the lable text for the first section's cells
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"3 Days - $xx.xx";
                break;
            case 1 :
                cell.textLabel.text = @"5 Days - $xx.xx";
                break;
            case 2:
                cell.textLabel.text = @"7 Days - $xx.xx";
                break;
            default:
                break;
        }
    }
    
    //sets the static data for the second grouped section
    else if ([indexPath section] == 1) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier2];
        }
    }
    
    //sets the static data for the third grouped section
    else {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier3];
        }
        
        //sets the accessory types for both cells to a detail disclosure button (blue arrow)
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        //sets the lable text for the third section's cells
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Apple ID";
                break;
            case 1:
                cell.textLabel.text = @"PayPal";
                break;
            default:
                break;
        }
    }    
    return cell;
}

/**
 *This method is called when a row is selected inside the table view.
 *It sets the view controller's properties based on which row was
 *selected from the first grouped section, or triggers a segue if
 *a row was selected from the second grouped section
 *
 **param:tableView - the table view in the ExtensionView
 **param:indexPath - the node path leading to each section of the table view
 **/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if a cell is selected from the first section
    if ([indexPath section] == 0) {
        self.selectedRow = indexPath.row;
        if (self.selectedRow == 0) {
            extensionLength = threeDays;
        } else if (self.selectedRow == 1) {
            extensionLength = fiveDays;
        } else if (self.selectedRow == 2) {
            extensionLength = sevenDays;
        }
    }
    //if a cell is selected from the third section
    else if ([indexPath section] == 2) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"payWithAppleIdSegue" sender:self.view];
        } else if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"payWithPayPalSegue" sender:self.view]; 
        }
    }
    [tableView reloadData];
}

/**
 *This method is called when an accessory button is pressed in a cell
 *It is currently set to trigger the same segue as if the cell was pressed
 *
 **param:tableView - the table view in the ExtensionView
 **param:indexPath - the node path leading to each section of the table view
 **/
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 2) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"payWithAppleIdSegueAcc" sender:self.view];
        } else if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"payWithPayPalSegueAcc" sender:self.view];
        }
    }
}

/**
 *This method is called when the table view is loaded
 *It sets the headers for each grouped section of the table view
 *
 **param:tableView - the table view in the ExtensionView
 **param:section - the grouped section of the table view
 *
 **return:NSString - the string used as the section's header text
 **/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *header;
    if (section == 0) {
        header = @"Extension Length:";
    } else if (section == 1) {
        
        header = [[NSString alloc] initWithFormat:@"New Expiration Date: %@", [self calculateNewExpirationDate]];
    } else if (section == 2) {
        header = @"Payment Method:";
    }
    return header;
}

/**
 *This method is called when a segue is triggered
 *It creates an instance of the PaymentViewController and passes
 *the necessary information to that controller before performing the segue
 *
 **param:segue - the segue that has been triggered
 **/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //if the segue is triggered by the Apple ID cell
    if([segue.identifier isEqualToString:@"payWithAppleIdSegue"] || [segue.identifier isEqualToString:@"payWithAppleIdSegueAcc"]){
        //get instance of view controller we are pushing to
        PaymentViewController *controller = segue.destinationViewController;
        
        //set the information we need to pass to the next view controller
        controller.barcode = self.barcode;
        controller.expDate = [Queries getCouponExpirationDate:self.barcode];
        controller.extendedExpDate = [self calculateNewExpirationDate];
        controller.paymentMethod = @"Apple ID";
    }
    //if the segue is triggered by the PayPal cell
    else if([segue.identifier isEqualToString:@"payWithPayPalSegue"] || [segue.identifier isEqualToString:@"payWithPayPalSegueAcc"]){
        //get instance of view controller we are pushing to
        PaymentViewController *controller = segue.destinationViewController;
        
        //set the information we need to pass to the next view controller
        controller.barcode = self.barcode;
        controller.expDate = [Queries getCouponExpirationDate:self.barcode];
        controller.extendedExpDate = [self calculateNewExpirationDate];
        controller.paymentMethod = @"PayPal";
    }
}

/**
 *Custom method
 **author: Douglas Abrams
 *
 *This method queries the database for the expiration date based on 
 *the current coupon's barcode and determines the new expiration date
 *based on what the user has selected from the first grouped section 
 *of the table view.
 *
 **return:NSString - the formatted string of the new expiration date
 **/
- (NSString *)calculateNewExpirationDate {
    NSString *expdate = [Queries getCouponExpirationDate:self.barcode];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:expdate];
    dateFromString = [dateFromString dateByAddingTimeInterval:extensionLength];
    NSString *stringFromDate = [[NSString alloc] init];
    stringFromDate = [dateFormatter stringFromDate:dateFromString];
    
    return stringFromDate;
}

@end
