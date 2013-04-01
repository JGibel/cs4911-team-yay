//
//  CouponListViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "CouponListViewController.h"
#import "Queries.h"

@interface CouponListViewController ()

@end

@implementation CouponListViewController
@synthesize couponList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.hidesBackButton=YES;
    
    //set up database variables for query 
    NSString *email = [Queries getEmail];
    couponList = [[NSMutableArray alloc] init];
    NSMutableArray *tempRetailers = [[NSMutableArray alloc] init];
    NSMutableArray *tempItems = [[NSMutableArray alloc] init];
    
    //open database connection
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return;
    }
    //Query for retailers that match the logged-in user's preferences
    FMResultSet *queryResult = [db executeQuery:@"SELECT coupons.barcode, coupons.expdate, coupons.retailerName, coupons.offer, userRetailerPreferences.user FROM coupons JOIN userRetailerPreferences ON coupons.retailerName = userRetailerPreferences.retailer WHERE userRetailerPreferences.user = ? ORDER BY coupons.expdate", email];
    //For each result of the query, add to the array of retailers to be displayed
    while ([queryResult next]) {
        NSString *barcode = [queryResult stringForColumn:@"barcode"];
        NSString *expdate = [queryResult stringForColumn:@"expdate"];
        NSString *retailer = [queryResult stringForColumn:@"retailerName"];
        NSString *offer = [queryResult stringForColumn:@"offer"];
        [tempRetailers addObject:[NSArray arrayWithObjects:barcode, expdate, retailer, offer, nil]];
    }
    [queryResult close];
    //Query for items that match the logged-in user's preferences
    FMResultSet *queryResultItem = [db executeQuery:@"SELECT coupons.barcode, coupons.expdate, coupons.retailerName, coupons.offer, userItemPreferences.user FROM coupons JOIN userItemPreferences ON coupons.itemCategory1 = userItemPreferences.itemCategory WHERE userItemPreferences.user = ? ORDER BY coupons.expdate", email];
    //Add results that match preference category 1
    while([queryResultItem next]) {
        NSString *barcode = [queryResultItem stringForColumn:@"barcode"];
        NSString *expdate = [queryResultItem stringForColumn:@"expdate"];
        NSString *retailer = [queryResultItem stringForColumn:@"retailerName"];
        NSString *offer = [queryResultItem stringForColumn:@"offer"];
        if (![tempItems containsObject:[NSArray arrayWithObjects:barcode, expdate, retailer, offer, nil]]) {
            [tempItems addObject:[NSArray arrayWithObjects:barcode, expdate, retailer, offer, nil]];
        }
    }
    //requery for category 2
    queryResultItem = [db executeQuery:@"SELECT coupons.barcode, coupons.expdate, coupons.retailerName, coupons.offer, userItemPreferences.user FROM coupons JOIN userItemPreferences ON coupons.itemCategory2 = userItemPreferences.itemCategory WHERE userItemPreferences.user = ? ORDER BY coupons.expdate", email];
    //Add results that match preference category 2
    while([queryResultItem next]) {
        NSString *barcode = [queryResultItem stringForColumn:@"barcode"];
        NSString *expdate = [queryResultItem stringForColumn:@"expdate"];
        NSString *retailer = [queryResultItem stringForColumn:@"retailerName"];
        NSString *offer = [queryResultItem stringForColumn:@"offer"];
        if (![tempItems containsObject:[NSArray arrayWithObjects:barcode, expdate, retailer, offer, nil]]) {
            [tempItems addObject:[NSArray arrayWithObjects:barcode, expdate, retailer, offer, nil]];
        }
    }
    //requery for category 3
    queryResultItem = [db executeQuery:@"SELECT coupons.barcode, coupons.expdate, coupons.retailerName, coupons.offer, userItemPreferences.user FROM coupons JOIN userItemPreferences ON coupons.itemCategory3 = userItemPreferences.itemCategory WHERE userItemPreferences.user = ? ORDER BY coupons.expdate", email];
    //Add results that match preference category 3
    while([queryResultItem next]) {
        NSString *barcode = [queryResultItem stringForColumn:@"barcode"];
        NSString *expdate = [queryResultItem stringForColumn:@"expdate"];
        NSString *retailer = [queryResultItem stringForColumn:@"retailerName"];
        NSString *offer = [queryResultItem stringForColumn:@"offer"];
        if (![tempItems containsObject:[NSArray arrayWithObjects:barcode, expdate, retailer, offer, nil]]) {
            [tempItems addObject:[NSArray arrayWithObjects:barcode, expdate, retailer, offer, nil]];
        }
    }
    [queryResultItem close];
    //loop through retailers and items and save any that match both user preferences
    for (int i = 0; i < [tempRetailers count]; i++) {
        for (int j = 0; j < [tempItems count]; j++) {
            if ([[tempRetailers objectAtIndex:i] isEqual:[tempItems objectAtIndex:j]] && ![couponList containsObject:[tempRetailers objectAtIndex:i]]) {
                [couponList addObject:[tempRetailers objectAtIndex:i]];
            }
        }
    }
    //reload the information in the table when the user returns to the view
    [_table reloadData];
    
    //close database connection
    [db close];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES]; 
	// Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"%lu", (unsigned long)[couponList count]);
    if ([couponList count] == 0) {
        _table.hidden = YES;
    } else {
        _table.hidden = NO;
    }
    return [couponList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    cell = [_table dequeueReusableCellWithIdentifier:@"couponCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"couponCell"];
    }
    NSArray *temp = [couponList objectAtIndex:indexPath.row];
    
    //set cell information
    UILabel *expLabel, *retailerLabel, *offerLabel;
    
    //generate subview locations for cell text
    expLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 15.0, 90.0, 15.0)];
    [cell.contentView addSubview:expLabel];
    retailerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 5.0, 185.0, 20.0)];
    retailerLabel.font = [UIFont boldSystemFontOfSize:16];
    [cell.contentView addSubview:retailerLabel];
    offerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 25.0, 185.0, 15.0)];
    offerLabel.font = [UIFont systemFontOfSize:12.0];
    [cell.contentView addSubview:offerLabel];
    
    //set cell text
    expLabel.text = [temp objectAtIndex:1];
    retailerLabel.text = [temp objectAtIndex:2];
    offerLabel.text = [temp objectAtIndex:3];
    cell.tag = [temp objectAtIndex:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set row to be deselected after selection so when you return to the view it is not in a selected state
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)returned:(UIStoryboardSegue *)segue {
}
@end
