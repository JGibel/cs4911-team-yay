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

+(void) addUser: (NSString *) firstName : (NSString *) lastName : (NSDate *) birthDate : (NSString *) email : (NSString *) password :(NSString *) gender
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if(![db open]) {
        return;
    }
    
    [db executeUpdate:@"insert into users values(? , ?, ? ,?, ?, ?)", email, password, firstName, lastName, gender, birthDate];
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
    
    [db executeUpdate:@"INSERT INTO userItemPreferences (id, category) VALUES (?,?)", appDelegate.user, category];
    
    [db close];
}

+(void) removeItemPref : (NSString *) category : (NSMutableArray *) itemsList
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* db = [appDelegate db];
    if (![db open]) {
        return;
    }
    
    [db executeUpdate:@"DELETE FROM userItemPreferences WHERE category = ? AND id = ?", category, appDelegate.user];
    
    [db close];
}

+(NSNumber *) getRetailerID : (NSString *) retailerName
{
    NSLog(@"Passing retailer name %@", retailerName);
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
    NSLog(@"Getting retailer id %@", retailerID);
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


@end
