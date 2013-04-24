//
//  ExtensionViewController.h
//  DealGenda
//
//  Created by Douglas Abrams on 4/22/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtensionViewController : UITableViewController

@property NSInteger selectedRow;
@property NSTimeInterval extensionLength;
@property (strong, nonatomic) NSString *barcode;
@property NSTimeInterval threeDays;
@property NSTimeInterval fiveDays;
@property NSTimeInterval sevenDays;

@end
