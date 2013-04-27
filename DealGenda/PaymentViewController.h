//
//  PaymentViewController.h
//  DealGenda
//
//  Created by Douglas Abrams on 4/24/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController

@property NSString *barcode;
@property NSString *expDate;
@property NSString *extendedExpDate;
@property NSString *paymentMethod;

@property (strong, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *expLabel;
@property (strong, nonatomic) IBOutlet UILabel *extendedExpLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentLabel;

- (IBAction)extendCoupon:(id)sender;
@end
