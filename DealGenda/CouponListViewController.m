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
    FMResultSet *queryResult = [db executeQuery:@"SELECT * FROM coupons ORDER BY expdate"];
    //For each result of the query, add to the array of retailers to be displayed
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"barcode"];
        [couponList addObject: result];
    }
    //close database connection
    [db close];
    NSLog(@"%@", couponList);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)returned:(UIStoryboardSegue *)segue {
}
@end
