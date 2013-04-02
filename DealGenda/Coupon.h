//
//  Coupon.h
//  DealGenda
//
//  Created by Douglas Abrams on 4/1/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject

@property NSString *barcode;
@property NSDate *expdate;
@property NSString *retailer;
@property NSString *offer;

- (id) initWithBarcode:(NSString *)bcd Expiration:(NSDate *)date Retailer:(NSString *)ret Offer:(NSString *)off;
-(NSString *) getBarcode;
-(NSDate *) getExpirationDate;
-(NSString *) getRetailer;
-(NSString *) getOffer;
-(BOOL) equals:(Coupon *)coup;

@end
