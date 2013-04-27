//
//  FavoritesViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "FavoritesViewController.h"
#import "AppDelegate.h"
#import "Queries.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController
@synthesize retailersList;
@synthesize itemsList;
@synthesize retailerListFull;
@synthesize itemListFull;
@synthesize state;

/**
 *Default iOS method
 *Sets any kind of custom data when a new instance of the FavoritesViewController is created
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
 *This method is called before the FavoritesView is loaded onto the screen
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
 *This method is called when the FavoritesView is initially loaded onto the screen
 *It sets queries for the logged-in user's preferences and sets the visibility of 
 *the Done button dependant on which view the app navigated here from
 **/
- (void)viewDidLoad
{
    state = 0;//retailer
    retailersList = [Queries getRetailerPrefs];
    itemsList = [Queries getItemPrefs];
    [super viewDidLoad];
    
    self.title = @"Favorites";

    //test to see where the user comes from and move the done button off screen if they are logged in
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        _doneButton.bounds = CGRectMake(_doneButton.bounds.origin.x, 0, _doneButton.bounds.size.width, _doneButton.bounds.size.height);
    }
    else {
        _doneButton.bounds = CGRectMake(_doneButton.bounds.origin.x, 69, _doneButton.bounds.size.width, _doneButton.bounds.size.height);
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
 *This method is called whenever the retailer/item bar is switched
 *It reloads the table view so the data will match what was selected
 **/
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

/**
 *This method is called whenever the table view is loaded
 *It determines how many rows are needed in the table based on the current
 *length of the preference arrays
 *
 **param:tableView - the table view in the FavoritesView
 **param:section - the grouped section of the table view
 *
 **return:NSInteger - the number of rows in each given section of the table view
 **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    retailerListFull = [Queries getRetailers];
    itemListFull = [Queries getItems];
    //detect table length dependent on which tab is active
    if (state == 0) {
        return [retailerListFull count];
    } else {
        return [itemListFull count];
    }
}

/**
 *This method is called whenever the table view is loaded
 *
 **param:tableView - the table view in the FavoritesView
 *
 **return:NSInteger - the number of grouped sections in the table view
 **/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/**
 *This method is called whenever the table view is loaded
 *It determines what is loaded in each cell of the table view
 *
 **param:tableView - the table view in the FavoritesView
 **param:indexPath - the node path leading to each section of the table view
 *
 **return:UITableViewCell - the formatted cell for the table view
 **/
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
        [cell.textLabel setText:[retailerListFull objectAtIndex:indexPath.row]];
        [cell setAccessoryView:retailerSwitch];
        
        //set switch state based on preferences
        for (int i = 0; i < [retailersList count]; i++) {
            if ([cell.textLabel.text isEqualToString: [retailersList objectAtIndex:i]]) {
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
        [cell.textLabel setText:[itemListFull objectAtIndex:indexPath.row]];
        [cell setAccessoryView:itemsSwitch];
        
        //set switch state based on preferences
        for (int i = 0; i < [itemsList count]; i++) {
            if ([cell.textLabel.text isEqualToString: [itemsList objectAtIndex:i]]) {
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

/**
 *This method is called whenever one of the preference switches is toggled on/off
 *If the toggle is set to on that preference is added to the user's preferences
 *in the database.  If the toggle is set to off that preference is removed from the 
 *user's preferences in the database
 *
 **param:sender - the id for the switch that was toggled
 **/
- (void) switchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;

    //retailers
    if (state == 0) {
        if ([mySwitch isOn]) {
            NSString* retailer = [retailerListFull objectAtIndex:mySwitch.tag];
            NSNumber* retailerID = [Queries getRetailerID: retailer];
            [Queries addRetailerPref: retailerID : retailersList];
            [retailersList addObject: retailer];

        } else {
            NSString* retailer = [retailerListFull objectAtIndex:mySwitch.tag];
            NSNumber* retailerID = [Queries getRetailerID: retailer];
            [Queries removeRetailerPref:retailerID :retailersList];
            NSMutableArray* tempList = [[NSMutableArray alloc] init];
            for (NSString *retailers in retailersList) {
                if(![retailers isEqualToString: retailer]) {
                    [tempList addObject: retailers];
                }
            }
            [retailersList removeAllObjects];
            retailersList = tempList;
        }
    }
    //items
    else {
        if ([mySwitch isOn]) {
            NSString* category = [itemListFull objectAtIndex:mySwitch.tag];
            [Queries addItemPref: category : itemsList];
            [itemsList addObject: category];
        } else {
            NSString* category = [itemListFull objectAtIndex:mySwitch.tag];
            [Queries removeItemPref: category : itemsList];
            NSMutableArray* tempList = [[NSMutableArray alloc] init];
            for (NSString *categories in itemsList) {
                if(![categories isEqualToString:category]) {
                    [tempList addObject: categories];
                }
            }
            [itemsList removeAllObjects];
            itemsList = tempList;
        }
    }
}

@end
