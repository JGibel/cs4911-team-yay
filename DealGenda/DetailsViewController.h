//
//  DetailsViewController.h
//  DealGenda
//
//  Created by Douglas Abrams on 4/7/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property int barcode;
@property (strong, nonatomic) IBOutlet UILabel *retailerLabel;

@end
