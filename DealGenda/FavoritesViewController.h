//
//  FavoritesViewController.h
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 2/11/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIView *favoritesView;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *retailersList;
@property (strong, nonatomic) NSMutableArray *itemsList;
@property (strong, nonatomic) NSMutableArray *retailerListFull;
@property (strong, nonatomic) NSMutableArray *itemListFull;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property NSInteger *state;

-(IBAction)segmentedChartButtonChanged:(id)sender;


@end
