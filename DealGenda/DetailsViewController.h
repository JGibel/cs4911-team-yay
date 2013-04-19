//
//  DetailsViewController.h
//  DealGenda
//
//  Created by Douglas Abrams on 4/7/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) NSString *barcode;
@property (strong, nonatomic) IBOutlet UILabel *retailerLabel;
@property (strong, nonatomic) IBOutlet UILabel *offerLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailsTextView;
@property (strong, nonatomic) IBOutlet UILabel *expDateLabel;
- (IBAction)addPass:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *openButton;
- (IBAction)openPassbook:(id)sender;

@end
