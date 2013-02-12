//
//  FavoritesViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

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
    [super viewDidLoad];
	_itemSubView.hidden = true;
    _retailerSubView.hidden = false;
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
    _testLabel.text = [_segmentControl titleForSegmentAtIndex:_segmentControl.selectedSegmentIndex];
}

@end
