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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    retailersList = [[NSMutableArray alloc] init];
    [super viewDidLoad];
    
    //Query database
    FMResultSet *queryResult = [db executeQuery:@"SELECT name FROM retailers"];
    //For each result of the query, add to the array of retailers to be displayed
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"name"];
        [retailersList addObject: result];
        
    }
    
//    [db close];

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
            _itemSubView.hidden = true;
            _retailerSubView.hidden = false;
            break;
        //Items is selected
        case 1:
            _itemSubView.hidden = false;
            _retailerSubView.hidden = true;
            break;
        default:
            _itemSubView.hidden = true;
            _retailerSubView.hidden = false;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [retailersList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    cell = [_retailersTable dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    //cell switches
    UISwitch *retailerSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(215.0, 10.0, 94.0, 27.0)];
    [retailerSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    [retailerSwitch setTag:indexPath.row];
    
    //load switch states
    [retailerSwitch setOn:TRUE];
    
    
    //set cell information
    [cell.textLabel setText:[retailersList objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setText:(@"test description")];
    [cell setAccessoryView:retailerSwitch];
    return cell;
    
}

//what happens whenever a switch is toggled
- (void) switchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        NSLog(@"%ld is on!", (long)mySwitch.tag);
    } else {
        NSLog(@"%ld is off!", (long)mySwitch.tag);
    }
}

@end
