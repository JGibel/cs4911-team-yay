//
//  CouponListViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "CouponListViewController.h"
#import "Queries.h"
#import "Coupon.h"
#import "DetailsViewController.h"

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
    couponList = [Queries getCoupons];

    //reload the information in the table when the user returns to the view
    [_table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES]; 
	// Do any additional setup after loading the view.
    
    self.title = @"Coupons";
    self.navigationItem.title = @"Coupons";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set row to be deselected after selection so when you return to the view it is not in a selected state
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    /* If the segue is pushing to the CouponDetailsView*/
    if([segue.identifier isEqualToString:@"showDetailSegue"] || [segue.identifier isEqualToString:@"showDetailSegueAcc"]){
        //detect which cell was pressed
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.table indexPathForCell:cell];
        //get instance of view controller we are pushing to
        DetailsViewController *controller = segue.destinationViewController;
        //set the barcode value for the view controller we are navigating to
        controller.barcode = [[couponList objectAtIndex:indexPath.row] getBarcode];
//        NSLog(@"%@", controller.barcode);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)returned:(UIStoryboardSegue *)segue {
}
@end
