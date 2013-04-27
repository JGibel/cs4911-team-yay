//
//  Coupon.m
//  DealGenda
//
//  Created by Douglas Abrams on 4/1/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon

@synthesize barcode;
@synthesize expdate;
@synthesize retailer;
@synthesize offer;

- (id) initWithBarcode:(NSString *)bcd Expiration:(NSDate *)date Retailer:(NSString *)ret Offer:(NSString *)off {
    if (self = [super init]) {
        self.barcode = bcd;
        self.expdate = date;
        self.retailer = ret;
        self.offer = off;
    }
    return self;
}

-(NSString *) getBarcode {
    return self.barcode;
}

-(NSDate *) getExpirationDate {
    return self.expdate;
}

-(NSString *) getRetailer {
    return self.retailer;
}

-(NSString *) getOffer {
    return self.offer;
}

-(BOOL) equals:(Coupon *)coup {
    if (self.barcode == coup.barcode) {
        return YES;
    }
    return NO;
}

@end
