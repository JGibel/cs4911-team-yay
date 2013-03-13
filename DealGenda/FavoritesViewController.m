//
//  FavoritesViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "FavoritesViewController.h"
#import "AppDelegate.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController
@synthesize retailersList;
@synthesize itemsList;
@synthesize state;
//@synthesize username;

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
    
    
    //test to see where the user comes from and move the done button off screen if they are logged in
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        _doneButton.bounds = CGRectMake(_doneButton.bounds.origin.x, 0, _doneButton.bounds.size.width, _doneButton.bounds.size.height);
    }
    else {
        _doneButton.bounds = CGRectMake(_doneButton.bounds.origin.x, 71, _doneButton.bounds.size.width, _doneButton.bounds.size.height);

    }
    
    
    //open database connection
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return;
    }
    //Query database
    FMResultSet *queryResult = [db executeQuery:@"SELECT name FROM retailers ORDER BY name"];
    //For each result of the query, add to the array of retailers to be displayed
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"name"];
        [retailersList addObject: result];
    }
    queryResult = [db executeQuery:@"SELECT category FROM items ORDER BY category"];
    //For each result of the query, add to the array of items to be displayed
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"category"];
        [itemsList addObject: result];        
    }
    //close database connection
    [db close];
    
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
        [cell.detailTextLabel setText:(@"test description")];
        [cell setAccessoryView:retailerSwitch];
        
        //load switch states
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        FMDatabase* db = [appDelegate db];
        if (![db open]) {
            return 0;
        }
        FMResultSet *queryResult = [db executeQuery:@"SELECT * FROM userRetailerPreferences WHERE user LIKE ?", appDelegate.username];
        NSMutableArray *resultPrefs = [[NSMutableArray alloc] init];;
        while ([queryResult next]) {
            NSString *result = [queryResult stringForColumn:@"retailer"];
            [resultPrefs addObject:result];
        }
        for (int i = 0; i < [resultPrefs count]; i++) {
            if ([cell.textLabel.text isEqualToString: [resultPrefs objectAtIndex:i]]) {
                [retailerSwitch setOn:TRUE];
                break;
            }
            else {
                [retailerSwitch setOn:FALSE];
            }
        }
        [db close];
        
    } else {
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
        [cell.detailTextLabel setText:(@"test description")];
        [cell setAccessoryView:itemsSwitch];
        
        //load switch states
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        FMDatabase* db = [appDelegate db];
        if (![db open]) {
            return 0;
        }
        FMResultSet *queryResult = [db executeQuery:@"SELECT * FROM userItemPreferences WHERE user LIKE ?", appDelegate.username];
        NSMutableArray *resultPrefs = [[NSMutableArray alloc] init];;
        while ([queryResult next]) {
            NSString *result = [queryResult stringForColumn:@"itemCategory"];
            [resultPrefs addObject:result];
        }
        for (int i = 0; i < [resultPrefs count]; i++) {
            if ([cell.textLabel.text isEqualToString: [resultPrefs objectAtIndex:i]]) {
                [itemsSwitch setOn:TRUE];
                break;
            }
            else {
                [itemsSwitch setOn:FALSE];
            }
        }
        [db close];
        
    }
    
    return cell;
    
}

//what happens whenever a switch is toggled
- (void) switchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return;
    }
    if (state == 0) {
        if ([mySwitch isOn]) {
            FMResultSet *queryResult = [db executeQuery:@"INSERT INTO userRetailerPreferences (user, retailer) VALUES (?,?)", appDelegate.username, [retailersList objectAtIndex:mySwitch.tag]];
            while ([queryResult next]) {
                NSString *result = [queryResult stringForColumn:@"name"];
                [retailersList addObject: result];
                
            }

    //        NSLog(@"%@ is on",[retailersList objectAtIndex:mySwitch.tag]);
        } else {
            FMResultSet *queryResult = [db executeQuery:@"DELETE FROM userRetailerPreferences WHERE user LIKE ? AND retailer LIKE ?", appDelegate.username, [retailersList objectAtIndex:mySwitch.tag]];
            while ([queryResult next]) {
                NSString *result = [queryResult stringForColumn:@"name"];
                [retailersList addObject: result];
                
            }
    //        NSLog(@"%@ is off",[retailersList objectAtIndex:mySwitch.tag]);
        }
    } else {
        if ([mySwitch isOn]) {
            FMResultSet *queryResult = [db executeQuery:@"INSERT INTO userItemPreferences (user, itemCategory) VALUES (?,?)", appDelegate.username, [itemsList objectAtIndex:mySwitch.tag]];
            while ([queryResult next]) {
                NSString *result = [queryResult stringForColumn:@"user"];
                [itemsList addObject: result];
                
            }
        } else {
            FMResultSet *queryResult = [db executeQuery:@"DELETE FROM userItemPreferences WHERE user LIKE ? AND itemCategory LIKE ?", appDelegate.username, [itemsList objectAtIndex:mySwitch.tag]];
            while ([queryResult next]) {
                NSString *result = [queryResult stringForColumn:@"user"];
                [itemsList addObject: result];
            }
        }
    }
    [db close];
}

@end
