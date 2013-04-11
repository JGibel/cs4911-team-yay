//
//  FavoritesViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "FavoritesViewController.h"
#import "AppDelegate.h"
#import "Queries.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController
@synthesize retailersList;
@synthesize itemsList;
@synthesize state;

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
    state = 0;//retailer
    retailersList = [[NSMutableArray alloc] init];
    itemsList = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    
    self.title = @"Favorites";
    
    
    
    //test to see where the user comes from and move the done button off screen if they are logged in
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        _doneButton.bounds = CGRectMake(_doneButton.bounds.origin.x, 0, _doneButton.bounds.size.width, _doneButton.bounds.size.height);
    }
    else {
        _doneButton.bounds = CGRectMake(_doneButton.bounds.origin.x, 69, _doneButton.bounds.size.width, _doneButton.bounds.size.height);

    }
    
    retailersList = [Queries getRetailers];
    itemsList = [Queries getItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)segmentedChartButtonChanged:(id)sender
{
    //switch between selected states of the segment control
    switch (_segmentControl.selectedSegmentIndex) {
        //Retailers is selected
        case 0:
            state = 0;
            [_table reloadData];
            break;
        //Items is selected
        case 1:
            state = 1;
            [_table reloadData];
            break;
        default:
            state = 0;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //detect table length dependent on which tab is active
    if (state == 0) {
        return [retailersList count];
    } else {
        return [itemsList count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    //on retailer tab
    if (state == 0) {
        cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
        
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        //cell switches
        UISwitch *retailerSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(215.0, 10.0, 94.0, 27.0)];
        [retailerSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
        [retailerSwitch setTag:indexPath.row];
        
        //set cell information
        [cell.textLabel setText:[retailersList objectAtIndex:indexPath.row]];
        [cell setAccessoryView:retailerSwitch];
        
        NSMutableArray *resultPrefs = [[NSMutableArray alloc] init];
        
        //query for retailer prefs
        resultPrefs = [Queries getRetailerPrefs];
        
        //set switch state based on preferences
        for (int i = 0; i < [resultPrefs count]; i++) {
            if ([cell.textLabel.text isEqualToString: [resultPrefs objectAtIndex:i]]) {
                [retailerSwitch setOn:TRUE];
                break;
            }
            else {
                [retailerSwitch setOn:FALSE];
            }
        }
        
    } else {//on items tab
        cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
        
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        //cell switches
        UISwitch *itemsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(215.0, 10.0, 94.0, 27.0)];
        [itemsSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
        [itemsSwitch setTag:indexPath.row];
        
        //set cell information
        [cell.textLabel setText:[itemsList objectAtIndex:indexPath.row]];
        [cell setAccessoryView:itemsSwitch];
        
        //query for item prefs
        NSMutableArray *resultPrefs = [[NSMutableArray alloc] init];
        resultPrefs = [Queries getItemPrefs];
        
        //set switch state based on preferences
        for (int i = 0; i < [resultPrefs count]; i++) {
            if ([cell.textLabel.text isEqualToString: [resultPrefs objectAtIndex:i]]) {
                [itemsSwitch setOn:TRUE];
                break;
            }
            else {
                [itemsSwitch setOn:FALSE];
            }
        }        
    }
    
    return cell;
    
}

//what happens whenever a switch is toggled
- (void) switchToggled:(id)sender {
    //NSString *email = [Queries getEmail];
    UISwitch *mySwitch = (UISwitch *)sender;

    if (state == 0) {
        if ([mySwitch isOn]) {
            NSString* retailer = [retailersList objectAtIndex:mySwitch.tag];
            NSNumber* retailerID = [Queries getRetailerID: retailer];
            [Queries addRetailerPref: retailerID : retailersList];
            [retailersList addObject: retailer];

        } else {
            NSString* retailer = [retailersList objectAtIndex:mySwitch.tag];
            NSNumber* retailerID = [Queries getRetailerID: retailer];
            [Queries removeRetailerPref:retailerID :retailersList];
            [retailersList removeObject: retailer];
        }
    } else {
        if ([mySwitch isOn]) {
            NSString* category = [itemsList objectAtIndex:mySwitch.tag];
            [Queries addItemPref: category : itemsList];
            [itemsList addObject: category];
        } else {
            NSString* category = [itemsList objectAtIndex:mySwitch.tag];
            [Queries removeItemPref: category : itemsList];
            [itemsList removeObject: category];

        }
    }
}

@end
