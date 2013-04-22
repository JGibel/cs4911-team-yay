//
//  ExtensionViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 4/22/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "ExtensionViewController.h"

@interface ExtensionViewController ()

@end

@implementation ExtensionViewController

@synthesize selectedRow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    }    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    [tableView reloadData];
}

@end
