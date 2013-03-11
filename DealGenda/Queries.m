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


+(BOOL) validateEmail: (NSString *) email : (FMDatabase *) db
{
    bool emailExists = false;
    FMResultSet *fm = [db executeQuery:@"SELECT email FROM users"];
    while([fm next]) {
        NSString* result = [fm stringForColumn:@"email"];
        if(result == email) {
            emailExists = true;
        }
    }
    return emailExists;
}

+(BOOL) validatePassword: (NSString *) password : (FMDatabase *) db
{
    bool passwordCorrect = false;
    FMResultSet *fm = [db executeQuery:@"SELECT password FROM users"];
    while([fm next]) {
        NSString* result = [fm stringForColumn:@"password"];
        if(result == password) {
            passwordCorrect = true;
        }
    }
    return passwordCorrect;
    
}

@end
