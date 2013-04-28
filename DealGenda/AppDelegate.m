//
//  AppDelegate.m
//  DealGenda
//
//  Created by Douglas Abrams, Kaitlynn Myrick & Jenelle Walker on 1/28/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
//

#import "AppDelegate.h"
#import "Queries.h"

@implementation AppDelegate
@synthesize db;
@synthesize user;

/**
 * Default iOS method
 * Calls database creationg and migration methods. This happens every time the app launches
 **/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self createDatabase];
    [Queries migrateToAppFromSchema];
    
    // Override point for customization after application launch.
    return YES;
}

/**
 * Default iOS method
 **/
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 * Default iOS method
 * Makes sure database is closed when the application loses focus
 **/
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [db close];
}

/**
 * Default iOS method
 **/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/**
 * Default iOS method
 **/
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

/**
 * Default iOS method
 * Makes sure the database is closed when the application closes
 **/
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [db close];
}

/**
 * if database does not exist, create a new directory Database in the Library directory and create a database DealGenda.db
 * return:void
 **/
-(void)createDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    //path in app data Library directory
    NSString *databaseDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"Database/"];
    //extends path from Library directory to Library/Database
    NSString *dbPath = [databaseDirectory stringByAppendingPathComponent:@"DealGenda.db"];
    //full path of database: Library/Database/DealGenda.db
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath])
        //checks if database exists
	{
        if (![[NSFileManager defaultManager] createDirectoryAtPath:databaseDirectory
              //create directory if files doesn't exist
									   withIntermediateDirectories:NO
														attributes:nil
															 error:&error])
		{
			NSLog(@"Create directory error: %@", error);
		}
	}
    
    db = [FMDatabase databaseWithPath:dbPath];
    //set global directory variable to database in user's app data Library/Database/DealGenda.db
}


@end
