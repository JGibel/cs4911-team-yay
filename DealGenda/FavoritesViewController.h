//
//  FavoritesViewController.h
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIView *favoritesView;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *retailersList;
@property (strong, nonatomic) NSMutableArray *itemsList;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property NSInteger *state;

//freakin get rid of these...  they're temporary
//@property (strong, nonatomic) NSString *username;

-(IBAction)segmentedChartButtonChanged:(id)sender;


@end
