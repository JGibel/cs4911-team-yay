//
//  Queries.h
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 3/8/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "FMDatabase.h"

@interface Queries : FMDatabase <UIApplicationDelegate>

+(void) migrateToAppFromSchema;
+(BOOL) validateEmail: (NSString *) email;
+(BOOL) validatePassword: (NSString *) email : (NSString *) password;
+(void) updateEmail: (NSString *) email : (NSString *) newEmail;
+(void) updatePassword: (NSString *) email : (NSString *) password;
+(NSNumber *) getId: (NSString *) email;
+(NSString *) getEmail;
+(NSString *) getCouponRetailer:(NSString *)barcode;
+(NSString *) getCouponOffer:(NSString *)barcode;
+(NSString *) getCouponExpirationDate:(NSString *)barcode;
+(NSString *) getCouponDetails:(NSString *)barcode;
+(BOOL) couponHasBeenExtended:(NSString *)barcode;
+(NSMutableArray *) getCoupons;
+(NSMutableArray *) getRetailers;
+(NSMutableArray *) getItems;
+(NSMutableArray *) getRetailerPrefs;
+(NSMutableArray *) getItemPrefs;
+(void) addRetailerPref : (NSNumber *) retailer;
+(void) addItemPref : (NSString *) category;
+(void) addUserWithFName:(NSString *)firstName LName:(NSString *)lastName Birthday:(NSString *)birthday Email:(NSString *)email Password:(NSString *)password Gender:(NSString *)gender;
+(NSNumber *) getRetailerID : (NSString *) retailerName;
+(NSString *) getRetailerName : (NSNumber *) retailerID;
+(void) removeRetailerPref : (NSNumber *) retailer;
+(void) removeItemPref : (NSString *) category;
+(void) setLoggedInUser:(NSNumber *)userId;
+(void) updateCoupon:(NSString *)barcode expDate:(NSString *)exp;

@end
