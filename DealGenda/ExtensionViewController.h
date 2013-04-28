//
//  ExtensionViewController.h
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 4/22/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtensionViewController : UITableViewController

@property NSInteger selectedRow;
@property NSTimeInterval extensionLength;
@property (strong, nonatomic) NSString *barcode;
@property NSTimeInterval threeDays;
@property NSTimeInterval fiveDays;
@property NSTimeInterval sevenDays;

- (NSString *)calculateNewExpirationDate;

@end
