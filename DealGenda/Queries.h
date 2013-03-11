//
//  Queries.h
//  DealGenda
//
//  Created by Jenelle Walker on 3/8/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "FMDatabase.h"

@interface Queries : FMDatabase

+(BOOL) validateEmail: (NSString *) email : (FMDatabase *) db;
+(BOOL) validatePassword: (NSString *) password : (FMDatabase *) db;

@end
