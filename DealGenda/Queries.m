//
//  Queries.m
//  DealGenda
//
//  Created by Jenelle Walker on 3/8/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "Queries.h"
#import "AppDelegate.h"
#import "Coupon.h"

@implementation Queries


+(void) migrateToAppFromSchema
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return;
    }
    
    NSInteger userVersion = 0;
    FMResultSet *fm = [db executeQuery:@"SELECT id FROM version"];
    if([fm next]) {
        userVersion = [fm intForColumn:@"id"];
    }
 
    NSArray *files = [[NSBundle mainBundle] pathsForResourcesOfType:@"sql" inDirectory:@""];
    

    int count = [files count];
    NSLog(@"%d", count);
    NSLog(@"%d", userVersion);
    
    for (NSString *file in files) {
        NSInteger version = [[[file lastPathComponent] stringByDeletingPathExtension] intValue];        
        if(userVersion < version) {
            NSString* fileContents = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];

            NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
            NSString *cleanedSql = @"";
            for(NSString *sqlStmt in allLinedStrings) {
                if(![sqlStmt hasPrefix: @"-"] && ![sqlStmt isEqualToString:@""]) {
                        NSString *sqlPart = [sqlStmt stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        cleanedSql = [cleanedSql stringByAppendingString: sqlPart];
                        if([sqlPart hasSuffix:@";"]) {
                            NSLog(@"Running SQL: %@", cleanedSql);
                            [db executeUpdate: cleanedSql];
                            cleanedSql = @"";
                        }
                }
                
            }
            userVersion++;
            NSLog(@"Updating version to %d", userVersion);
            [db executeUpdate: @"update version set id = ?", [NSNumber numberWithInt:userVersion]];
        }

    }
    [fm close];
    [db close];
}


+(BOOL) validateEmail: (NSString *) email
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return YES;
    }
    bool emailExists = false;
    FMResultSet *fm = [db executeQuery:@"SELECT email FROM users"];
    while([fm next]) {
        NSString* result = [fm stringForColumn:@"email"];
        if([result isEqualToString: email]) {
            emailExists = true;
            break;
        }
    }
    [fm close];
    [db close];
    
    return emailExists;
}

+(BOOL) validatePassword: (NSString *) email : (NSString *) password
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return YES;
    }
    bool passwordCorrect = false;
    FMResultSet *fm = [db executeQuery:@"SELECT password FROM users WHERE email = ?", email];
    while([fm next]) {
        NSString* result = [fm stringForColumn:@"password"];
        if([result isEqualToString: password]) {
            passwordCorrect = true;
            break;
        }
    }
    [fm close];
    [db close];
    return passwordCorrect;
    
}

+(void) updateEmail: (NSString *) email : (NSString *) newEmail
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return;
    }
    
    [db executeUpdate:@"UPDATE users SET email = ? WHERE email = ?", newEmail, email];
    FMResultSet *fm = [db executeQuery:@"SELECT email FROM users WHERE email = ?", newEmail];
    while([fm next]) {
        //NSString* result = [fm stringForColumn:@"email"];
        //NSLog(result);
    }
    [fm close];
    [db close];
}

+(void) updatePassword: (NSString *) email : (NSString *) password
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return;
    }
    [db executeUpdate:@"UPDATE users SET password = ? WHERE email = ?", password, email];
    FMResultSet *fm = [db executeQuery:@"SELECT password FROM users WHERE email = ?", email];
    while([fm next]) {
        //NSString* result = [fm stringForColumn:@"password"];
        //NSLog(result);
    }
    [fm close];
    [db close];
}

+(void) addUserWithFName:(NSString *)firstName LName:(NSString *)lastName Birthday:(NSString *)birthday Email:(NSString *)email Password:(NSString *)password Gender:(NSString *)gender
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return;
    }
    
    [db executeUpdate:@"insert into users values(null, ? , ?, ? ,?, ?, ?)", email, password, firstName, lastName, gender, birthday];
//    appDelegate.user = [Queries getId:[Queries getEmail]];
//    NSLog(@"%@", appDelegate.user);
    [db close];
}

+(NSNumber *) getId: (NSString *) email
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return NULL;
    }
    FMResultSet *fm = [db executeQuery:@"select id from users where email = ?", email];
    NSNumber *user;
    if([fm next]) {
        user = [NSNumber numberWithInt:[fm intForColumn:@"id"]];
    }
    
    [fm close];
    [db close];
    return user;
}

+(NSString *) getEmail
{

    NSString *email;
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return NULL;
    }
    FMResultSet *fm = [db executeQuery:@"select email from users where id = ?", appDelegate.user];
    if([fm next]) {
        email = [fm stringForColumn:@"email"];
    }
    [fm close];
    [db close];
    return email;
}

+(NSString *) getCouponRetailer:(NSString *)barcode
{
    NSString *retailer;
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return NULL;
    }
    FMResultSet *fm = [db executeQuery:@"select * from coupons where barcode = ?", barcode];
    if([fm next]) {
        retailer = [fm stringForColumn:@"retailerName"];
    }
    [fm close];
    [db close];
    return retailer;
}

+(NSString *) getCouponOffer:(NSString *)barcode
{
    NSString *offer;
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return NULL;
    }
    FMResultSet *fm = [db executeQuery:@"select * from coupons where barcode = ?", barcode];
    if([fm next]) {
        offer = [fm stringForColumn:@"offer"];
    }
    [fm close];
    [db close];
    return offer;
}

+(NSString *) getCouponExpirationDate:(NSString *)barcode
{
    NSString *expDate;
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return NULL;
    }
    FMResultSet *fm = [db executeQuery:@"select * from coupons where barcode = ?", barcode];
    if([fm next]) {
        expDate = [fm stringForColumn:@"expdate"];
    }
    [fm close];
    [db close];
    return expDate;
}

+(NSString *) getCouponDetails:(NSString *)barcode
{
    NSString *details;
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return NULL;
    }
    FMResultSet *fm = [db executeQuery:@"select * from coupons where barcode = ?", barcode];
    if([fm next]) {
        details = [fm stringForColumn:@"details"];
    }
    [fm close];
    [db close];
    return details;
}

+(NSMutableArray *) getRetailers
{
    NSMutableArray *retailersList = [[NSMutableArray alloc] init];
    //open database connection
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return 0;
    }
    //Query database
    FMResultSet *queryResult = [db executeQuery:@"SELECT name FROM retailers ORDER BY name"];
    //For each result of the query, add to the array of retailers to be displayed
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"name"];
        [retailersList addObject: result];
    }
    
    return retailersList;
}

+(NSMutableArray *) getItems
{
    NSMutableArray *itemsList = [[NSMutableArray alloc] init];
    //open database connection
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return 0;
    }
    //Query database
    FMResultSet *queryResult = [db executeQuery:@"SELECT category FROM items ORDER BY category"];
    //For each result of the query, add to the array of items to be displayed
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"category"];
        [itemsList addObject: result];
    }
    
    return itemsList;
}

+(NSMutableArray *) getRetailerPrefs
{
    NSMutableArray *retailerPrefs = [[NSMutableArray alloc] init];
    
    //open database
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return 0;
    }
    //query for retailer prefs by name
    FMResultSet *queryResult = [db executeQuery:@"select name from retailers left join userretailerpreferences on retailers.id = userretailerpreferences.retailerid where userretailerpreferences.id = ?", appDelegate.user];
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"name"];
        [retailerPrefs addObject:result];
    }
    [queryResult close];
    //close database
    [db close];
    
    return retailerPrefs;
    
}

+(NSMutableArray *) getItemPrefs
{
    NSMutableArray *itemPrefs = [[NSMutableArray alloc] init];
    //open database
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return 0;
    }
    //query for item prefs
    FMResultSet *queryResult = [db executeQuery:@"SELECT * FROM userItemPreferences WHERE id = ?", appDelegate.user];
    while ([queryResult next]) {
        NSString *result = [queryResult stringForColumn:@"itemCategory"];
        [itemPrefs addObject:result];
    }
    [queryResult close];
    //close database
    [db close];
    
    return itemPrefs;
}

+(void) addRetailerPref : (NSNumber *) retailer : (NSMutableArray *) retailersList
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return;
    }
    [db executeUpdate:@"INSERT INTO userRetailerPreferences (id, retailerID) VALUES (?,?)", appDelegate.user, retailer];
        
    [db close];
}

+(void) removeRetailerPref : (NSNumber *) retailer : (NSMutableArray *) retailersList
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return;
    }
    
    [db executeUpdate:@"DELETE FROM userRetailerPreferences WHERE retailerID = ? AND id = ?", retailer, appDelegate.user];
    
    [db close];
}

+(void) addItemPref : (NSString *) category : (NSMutableArray *) itemsList
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return;
    }
    
    [db executeUpdate:@"INSERT INTO userItemPreferences (id, itemcategory) VALUES (?,?)", appDelegate.user, category];
    
    [db close];
}

+(void) removeItemPref : (NSString *) category : (NSMutableArray *) itemsList
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return;
    }
    
    [db executeUpdate:@"DELETE FROM userItemPreferences WHERE itemcategory = ? AND id = ?", category, appDelegate.user];
    
    [db close];
}

+(NSNumber *) getRetailerID : (NSString *) retailerName
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return 0;
    }
    NSNumber* retailerID;
    FMResultSet *result = [db executeQuery:@"SELECT id FROM retailers WHERE name = ?", retailerName];
    if([result next]) {
        retailerID = [NSNumber numberWithInt:[result intForColumn:@"id"]];
    }
    [result close];
    [db close];
    return retailerID;
}

+(NSString *) getRetailerName : (NSNumber *) retailerID
{
    NSString* name;
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return 0;
    }
    FMResultSet *result = [db executeQuery:@"SELECT name FROM retailers WHERE id = ?", retailerID];
    if([result next]) {
        name = [result stringForColumn:@"name"];
    }
    [result close];
    [db close];
    return name;
}

+(NSMutableArray *) getCoupons
{
    NSMutableArray* tempRetailers = [[NSMutableArray alloc] init];
    NSMutableArray* tempItems = [[NSMutableArray alloc] init];
    NSMutableArray* couponList = [[NSMutableArray alloc] init];

    //open database connection
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return 0;
    }
    //Query for retailers that match the logged-in user's preferences
    FMResultSet *queryResult = [db executeQuery:@"SELECT coupons.barcode, coupons.expdate, coupons.retailerName, coupons.offer, userRetailerPreferences.id FROM coupons JOIN userRetailerPreferences ON coupons.retailerid = userRetailerPreferences.retailerid WHERE userRetailerPreferences.id = ? ORDER BY coupons.expdate", appDelegate.user];
    //For each result of the query, add to the array of retailers to be displayed
    while ([queryResult next]) {
        NSString *barcode = [queryResult stringForColumn:@"barcode"];
        NSString *expdate = [queryResult stringForColumn:@"expdate"];
        NSString *retailer = [queryResult stringForColumn:@"retailerName"];
        NSString *offer = [queryResult stringForColumn:@"offer"];
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:expdate];
        
        Coupon *tempCoupon = [[Coupon alloc] initWithBarcode:barcode Expiration:dateFromString Retailer:retailer Offer:offer];
        [tempRetailers addObject:tempCoupon];

    }
    
    //Query for items that match the logged-in user's preferences
    FMResultSet *queryResultItem1 = [db executeQuery:@"SELECT coupons.barcode, coupons.expdate, coupons.retailerName, coupons.offer, userItemPreferences.id FROM coupons JOIN userItemPreferences ON coupons.itemCategory1 = userItemPreferences.itemCategory WHERE userItemPreferences.id = ? ORDER BY coupons.expdate", appDelegate.user];
    //Add results that match preference category 1
    while([queryResultItem1 next]) {
        NSString *barcode = [queryResultItem1 stringForColumn:@"barcode"];
        NSString *expdate = [queryResultItem1 stringForColumn:@"expdate"];
        NSString *retailer = [queryResultItem1 stringForColumn:@"retailerName"];
        NSString *offer = [queryResultItem1 stringForColumn:@"offer"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:expdate];
        
        Coupon *tempCoupon = [[Coupon alloc] initWithBarcode:barcode Expiration:dateFromString Retailer:retailer Offer:offer];
        
        if (![tempItems containsObject:tempCoupon]) {
            [tempItems addObject:tempCoupon];
        }
    }
    //requery for category 2
    FMResultSet *queryResultItem2 = [db executeQuery:@"SELECT coupons.barcode, coupons.expdate, coupons.retailerName, coupons.offer, userItemPreferences.id FROM coupons JOIN userItemPreferences ON coupons.itemCategory2 = userItemPreferences.itemCategory WHERE userItemPreferences.id = ? ORDER BY coupons.expdate", appDelegate.user];
    //Add results that match preference category 2
    while([queryResultItem2 next]) {
        NSString *barcode = [queryResultItem2 stringForColumn:@"barcode"];
        NSString *expdate = [queryResultItem2 stringForColumn:@"expdate"];
        NSString *retailer = [queryResultItem2 stringForColumn:@"retailerName"];
        NSString *offer = [queryResultItem2 stringForColumn:@"offer"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:expdate];
        
        Coupon *tempCoupon = [[Coupon alloc] initWithBarcode:barcode Expiration:dateFromString Retailer:retailer Offer:offer];
        
        if (![tempItems containsObject:tempCoupon]) {
            [tempItems addObject:tempCoupon];
        }
    }
    //requery for category 3
    FMResultSet *queryResultItem3 = [db executeQuery:@"SELECT coupons.barcode, coupons.expdate, coupons.retailerName, coupons.offer, userItemPreferences.id FROM coupons JOIN userItemPreferences ON coupons.itemCategory3 = userItemPreferences.itemCategory WHERE userItemPreferences.id = ? ORDER BY coupons.expdate", appDelegate.user];
    //Add results that match preference category 3
    while([queryResultItem3 next]) {
        NSString *barcode = [queryResultItem3 stringForColumn:@"barcode"];
        NSString *expdate = [queryResultItem3 stringForColumn:@"expdate"];
        NSString *retailer = [queryResultItem3 stringForColumn:@"retailerName"];
        NSString *offer = [queryResultItem3 stringForColumn:@"offer"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:expdate];
        
        Coupon *tempCoupon = [[Coupon alloc] initWithBarcode:barcode Expiration:dateFromString Retailer:retailer Offer:offer];
        
        if (![tempItems containsObject:tempCoupon]) {
            [tempItems addObject:tempCoupon];
        }
    }
    [queryResultItem1 close];
    [queryResultItem2 close];
    [queryResultItem3 close];

    [db close];
    //loop through retailers and items and save any that match both user preferences
    for (int i = 0; i < [tempRetailers count]; i++) {
        for (int j = 0; j < [tempItems count]; j++) {
            
            NSString *retBar = [[tempRetailers objectAtIndex:i] getBarcode];
            NSString *itemBar = [[tempItems objectAtIndex:j] getBarcode];
            if ([retBar isEqualToString:itemBar] && ![couponList containsObject:[tempRetailers objectAtIndex:i]]) {
                [couponList addObject:[tempRetailers objectAtIndex:i]];
            }
        }
    }

    return couponList;
}

+(void) setLoggedInUser:(NSNumber *)userId {
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return;
    }
    appDelegate.user = userId;
    NSLog(@"%@", appDelegate.user);
    [db close];
}


@end
