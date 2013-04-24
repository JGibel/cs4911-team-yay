//
//  ExtensionViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 4/22/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "ExtensionViewController.h"
#import "Queries.h"

@interface ExtensionViewController ()

@end

@implementation ExtensionViewController

@synthesize selectedRow;
@synthesize extensionLength;
@synthesize barcode;
@synthesize threeDays;
@synthesize fiveDays;
@synthesize sevenDays;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    threeDays = 24 * 60 * 60 * 3;
    fiveDays = 24 * 60 * 60 * 5;
    sevenDays = 24 * 60 * 60 * 7;
    extensionLength = threeDays;
    selectedRow = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"extensionLengthCell";
    static NSString *CellIdentifier2 = @"expirationDateCell";
    static NSString *CellIdentifier3 = @"paymentMethodCell";
    NSString *identityString = @"";
    
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
    
    if ([indexPath section] == 0) {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier1];
        }
        if (self.selectedRow == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
    
    else if ([indexPath section] == 1) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier2];
        }
    }
    
    else {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier3];
        }
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *header;
    if (section == 0) {
        header = @"Extension Length:";
    } else if (section == 1) {
        NSString *expdate = [Queries getCouponExpirationDate:self.barcode];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:expdate];
        dateFromString = [dateFromString dateByAddingTimeInterval:extensionLength];
        NSString *stringFromDate = [[NSString alloc] init];
        stringFromDate = [dateFormatter stringFromDate:dateFromString];
        header = [[NSString alloc] initWithFormat:@"New Expiration Date: %@", stringFromDate];
    } else if (section == 2) {
        header = @"Payment Method:";
    }
    return header;
}

@end
