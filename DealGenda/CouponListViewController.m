//
//  CouponListViewController.m
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 2/11/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "CouponListViewController.h"
#import "Queries.h"
#import "Coupon.h"
#import "DetailsViewController.h"

@interface CouponListViewController ()

@end

@implementation CouponListViewController
@synthesize couponList;

/**
 *Default iOS method
 *Sets any kind of custom data when a new instance of the CouponListViewController is created
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
 *It currently hides the back button in the navigation bar and queries the 
 *database for the list of coupons applicable to the logged-in user.  This 
 *method also contains the commented out codeblock that will filter the coupon
 *list to exclude coupons that have expired
 **/
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.hidesBackButton=YES;
    couponList = [Queries getCoupons];
    
/**
 *The following codeblock will filter the coupon list to only include
 *coupons that do not have an expiration date before today's date
 *
 *Uncomment this block to turn on the filtering
*/

/*
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 0; i < [couponList count]; i++) {
        if ([[[couponList objectAtIndex:i] getExpirationDate] compare:[NSDate date]] == NSOrderedAscending) {
            [temp addObject:[couponList objectAtIndex:i]];
        }
    }
    for (int i = 0; i < [temp count]; i++) {
        if ([couponList containsObject:[temp objectAtIndex:i]]) {
            [couponList removeObjectIdenticalTo:[temp objectAtIndex:i]];
        }
    }
*/

    //reload the information in the table when the user returns to the view
    [_table reloadData];
}

/**
 *Default iOS method
 *This method is called when the CouponListView is initially loaded onto the screen
 *It hides the back button and sets the navigation bar title
 **/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES]; 
	// Do any additional setup after loading the view.
    
    self.title = @"Coupons";
    self.navigationItem.title = @"Coupons";
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
 *It determines how many rows are needed in the table based on the current
 *length of the preference arrays
 *
 **param:tableView - the table view in the CouponListView
 **param:section - the grouped section of the table view
 *
 **return:NSInteger - the number of rows in each given section of the table view
 **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"%lu", (unsigned long)[couponList count]);
    if ([couponList count] == 0) {
        _table.hidden = YES;
    } else {
        _table.hidden = NO;
    }
    return [couponList count];
}

/**
 *This method is called whenever the table view is loaded
 *
 **param:tableView - the table view in the CouponListView
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
 **param:tableView - the table view in the CouponListView
 **param:indexPath - the node path leading to each section of the table view
 *
 **return:UITableViewCell - the formatted cell for the table view
 **/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    cell = [_table dequeueReusableCellWithIdentifier:@"couponCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"couponCell"];
    }
//    NSArray *temp = [couponList objectAtIndex:indexPath.row];
    
    //set cell information
    UILabel *expLabel, *retailerLabel, *offerLabel;
    
    //generate subview locations for cell text
    expLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 15.0, 90.0, 15.0)];
    expLabel.backgroundColor = cell.backgroundColor;
    [cell.contentView addSubview:expLabel];
    retailerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 5.0, 185.0, 20.0)];
    retailerLabel.font = [UIFont boldSystemFontOfSize:16];
    retailerLabel.backgroundColor = cell.backgroundColor;
    [cell.contentView addSubview:retailerLabel];
    offerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 25.0, 185.0, 15.0)];
    offerLabel.font = [UIFont systemFontOfSize:12.0];
    offerLabel.backgroundColor = cell.backgroundColor;
    [cell.contentView addSubview:offerLabel];
    
    //set cell text
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:[[couponList objectAtIndex:indexPath.row] getExpirationDate]];

    expLabel.text = strDate;
    retailerLabel.text = [[couponList objectAtIndex:indexPath.row] getRetailer];
    offerLabel.text = [[couponList objectAtIndex:indexPath.row] getOffer];
    //sets the cell's tag property to the row number in the table
    //this is used later when determining which coupon to load in the DetailsView
    cell.tag = indexPath.row;
    
    return cell;
}

/**
 *This method is called when a row is selected inside the table view
 *It sets the cell that was just selected to be not selected so when
 *the user navigates backwards to this view it is not still selected
 *
 **param:tableView - the table view in the CouponListView
 **param:indexPath - the node path leading to each section of the table view
 **/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set row to be deselected after selection so when you return to the view it is not in a selected state
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *This method is called when a segue is triggered
 *It creates an instance of the DetailsViewController and sets the parameters
 *for that view controller to the appropriate values based on the current coupon
 *
 **param:segue - the segue being triggered
 **param:sender - the id sending the call for a segue
 **/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showDetailSegue"] || [segue.identifier isEqualToString:@"showDetailSegueAcc"]){
        //detect which cell was pressed
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.table indexPathForCell:cell];
        //get instance of view controller we are pushing to
        DetailsViewController *controller = segue.destinationViewController;
        //set the barcode value for the view controller we are navigating to
        controller.barcode = [[couponList objectAtIndex:indexPath.row] getBarcode];
    }
}

/**
 *This method allows for the segue to be reversed so that the view can
 *navigate back to the CouponListView
 *
 **param:segue - the segue being returned
 **/
-(IBAction)returned:(UIStoryboardSegue *)segue {
}
@end
