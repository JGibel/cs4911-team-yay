//
//  Coupon.m
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 4/1/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "Coupon.h"

/**
 *This class represents a single coupon in the database
 **/
@implementation Coupon

@synthesize barcode;
@synthesize expdate;
@synthesize retailer;
@synthesize offer;

/**
 *This is a custom initialization of a coupon instance
 *It will create a new instance of a coupon object with the passed in data
 *
 **param:bcd - barcode
 **param:date - expiration date
 **param:ret - retailer
 **param:off - offer
 **/
- (id) initWithBarcode:(NSString *)bcd Expiration:(NSDate *)date Retailer:(NSString *)ret Offer:(NSString *)off {
    if (self = [super init]) {
        self.barcode = bcd;
        self.expdate = date;
        self.retailer = ret;
        self.offer = off;
    }
    return self;
}

/**
 *This method gets the barcode for an instance of a coupon object
 *
 **return:NSString - the coupon's barcode
 **/
-(NSString *) getBarcode {
    return self.barcode;
}

/**
 *This method gets the expiration date for an instance of a coupon object
 *
 **return:NSDate - the coupon's expiration date
 **/
-(NSDate *) getExpirationDate {
    return self.expdate;
}

/**
 *This method gets the retailer for an instance of a coupon object
 *
 **return:NSString - the coupon's retailer
 **/
-(NSString *) getRetailer {
    return self.retailer;
}

/**
 *This method gets the offer for an instance of a coupon object
 *
 **return:NSString - the coupon's offer
 **/
-(NSString *) getOffer {
    return self.offer;
}

/**
 *This method tests to see if two coupon instances are equal
 *Two coupons are said to be equal if their barcode is the same
 *
 **param:coup - an instance of a coupon object to compare to
 *
 **return:BOOL - TRUE if the two coupons have the same barcode
 **/
-(BOOL) equals:(Coupon *)coup {
    if (self.barcode == coup.barcode) {
        return YES;
    }
    return NO;
}

@end
