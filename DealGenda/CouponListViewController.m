//
//  CouponListViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "CouponListViewController.h"

@interface CouponListViewController ()

@end

@implementation CouponListViewController
@synthesize couponList;
@synthesize shouldSegue;

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
}

- (void)viewDidLoad
{
    couponList = [[NSMutableArray alloc] init];
    NSMutableArray *tempRetailers = [[NSMutableArray alloc] init];
    NSMutableArray *tempItems = [[NSMutableArray alloc] init];
    shouldSegue = YES;
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES]; 
	// Do any additional setup after loading the view.
    
    
    //open database connection
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return;
    }
    //Query database
    FMResultSet *queryResult = [db executeQuery:@"SELECT coupons.barcode, coupons.expdate, coupons.retailerName, coupons.offer, userRetailerPreferences.user FROM coupons JOIN userRetailerPreferences ON coupons.retailerName = userRetailerPreferences.retailer WHERE userRetailerPreferences.user = ? ORDER BY coupons.expdate", appDelegate.username];
    //For each result of the query, add to the array of retailers to be displayed
    while ([queryResult next]) {
        NSString *barcode = [queryResult stringForColumn:@"barcode"];
        NSString *expdate = [queryResult stringForColumn:@"expdate"];
        NSString *retailer = [queryResult stringForColumn:@"retailerName"];
        NSString *offer = [queryResult stringForColumn:@"offer"];
        [tempRetailers addObject:[NSArray arrayWithObjects:barcode, expdate, retailer, offer, nil]];
    }
    queryResult = [db executeQuery:@"SELECT coupons.barcode, coupons.expdate, coupons.retailerName, coupons.offer, userItemPreferences.user FROM coupons JOIN userItemPreferences ON coupons.itemCategory = userItemPreferences.itemCategory WHERE userItemPreferences.user = ? ORDER BY coupons.expdate", appDelegate.username];
    while([queryResult next]) {
        NSString *barcode = [queryResult stringForColumn:@"barcode"];
        NSString *expdate = [queryResult stringForColumn:@"expdate"];
        NSString *retailer = [queryResult stringForColumn:@"retailerName"];
        NSString *offer = [queryResult stringForColumn:@"offer"];
        [tempItems addObject:[NSArray arrayWithObjects:barcode, expdate, retailer, offer, nil]];
    }
    for (int i = 0; i < [tempRetailers count]; i++) {
        for (int j = 0; j < [tempItems count]; j++) {
            NSLog(@"ret: %@", [tempRetailers objectAtIndex:i]);
            NSLog(@"item: %@", [tempItems objectAtIndex:j]);
            NSLog(@"eq: %d", [[tempRetailers objectAtIndex:i] isEqual:[tempItems objectAtIndex:j]]);
            NSLog(@"---------");
            if ([[tempRetailers objectAtIndex:i] isEqual:[tempItems objectAtIndex:j]]) {
                NSLog(@"equals");
                [couponList addObject:[tempRetailers objectAtIndex:i]];
            }
        }
    }
    NSLog(@"%@", couponList);
    NSLog(@"%@", appDelegate.username);
    //close database connection
    [db close];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
    if ([couponList count] > 0) {
        NSArray *temp = [couponList objectAtIndex:indexPath.row];
        
        //set cell information
        UILabel *expLabel, *retailerLabel, *offerLabel;
        
        expLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 15.0, 80.0, 15.0)];
        [cell.contentView addSubview:expLabel];
        retailerLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 5.0, 195.0, 20.0)];
        retailerLabel.font = [UIFont boldSystemFontOfSize:16];
        [cell.contentView addSubview:retailerLabel];
        offerLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 25.0, 195.0, 15.0)];
        offerLabel.font = [UIFont systemFontOfSize:12.0];
        [cell.contentView addSubview:offerLabel];
        
        expLabel.text = [temp objectAtIndex:1];
        retailerLabel.text = [temp objectAtIndex:2];
        offerLabel.text = [temp objectAtIndex:3];
        cell.tag = [temp objectAtIndex:0];
        shouldSegue = YES;
    } else {
        UILabel *noneLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, 350.0, 44.0)];
        noneLabel.font = [UIFont systemFontOfSize:13.0];
        noneLabel.text = @"No coupons currently match your preferences";
        [cell.contentView addSubview:noneLabel];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        shouldSegue = NO;
    }
    

    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return shouldSegue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
