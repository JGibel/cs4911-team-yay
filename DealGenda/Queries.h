//
//  Queries.h
//  DealGenda
//
//  Created by Jenelle Walker on 3/8/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
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
+(void) addRetailerPref : (NSNumber *) retailer : (NSMutableArray *) retailersList;
+(void) addItemPref : (NSString *) category : (NSMutableArray *) itemsList;
+(void) addUserWithFName:(NSString *)firstName LName:(NSString *)lastName Birthday:(NSString *)birthday Email:(NSString *)email Password:(NSString *)password Gender:(NSString *)gender;
+(NSNumber *) getRetailerID : (NSString *) retailerName;
+(void) removeRetailerPref : (NSNumber *) retailer : (NSMutableArray *) retailersList;
+(void) removeItemPref : (NSString *) category : (NSMutableArray *) itemsList;
+(void) setLoggedInUser:(NSNumber *)userId;
+(void) updateCoupon:(NSString *)barcode expDate:(NSString *)exp;

@end
