//
//  CouponListViewController.h
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritesViewController.h"
#import "SettingsViewController.h"

@interface CouponListViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *couponList;

@end
