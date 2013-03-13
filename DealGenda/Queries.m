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
    FMResultSet *fm = [db executeQuery:@"SELECT password FROM users WHERE email LIKE ?", email];
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
        NSString* result = [fm stringForColumn:@"email"];
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
        NSString* result = [fm stringForColumn:@"password"];
        //NSLog(result);
    }
    [db close];
}


@end
