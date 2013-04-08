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

@end
