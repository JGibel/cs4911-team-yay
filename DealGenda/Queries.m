//
//  Queries.m
//  DealGenda
//
//  Created by Jenelle Walker on 3/8/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "Queries.h"
#import "AppDelegate.h"

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
            for(NSString *sqlStmt in allLinedStrings) {
                NSString *cleanedSql = [sqlStmt stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                // Handle empty newlines.
                if(![cleanedSql isEqualToString:@""]) {
                    NSLog(@"Running SQL: %@", cleanedSql);
                    [db executeUpdate: cleanedSql];
                }
            }
            userVersion++;
            NSLog(@"Updating version to %d", userVersion);
            [db executeUpdate: @"update version set id = ?", [NSNumber numberWithInt:userVersion]];
        }
    }
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


@end
