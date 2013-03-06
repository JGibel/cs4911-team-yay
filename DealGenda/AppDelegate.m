//
//  AppDelegate.m
//  DealGenda
//
//  Created by Douglas Abrams on 1/28/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize db;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self createAndCheckDatabase];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [db close];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (![db open]) {
        return;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [db close];
}

-(void) createAndCheckDatabase
{
    NSError *error;
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"DealGenda" ofType:@"db"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *databaseDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"Database"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseDirectory])	//Does datbase already exist?
	{
		if (![[NSFileManager defaultManager] createDirectoryAtPath:databaseDirectory
									   withIntermediateDirectories:NO
														attributes:nil
															 error:&error])
		{
			NSLog(@"Create directory error: %@", error);
		}
	}
    
    NSString *writableDBPath = [databaseDirectory stringByAppendingPathComponent:@"DealGenda.db"];
    db = [FMDatabase databaseWithPath:writableDBPath];
    [[NSFileManager defaultManager] copyItemAtPath:databasePath toPath:writableDBPath error:nil];
    
    if(!db)
    {
        NSLog(@"Failed moving database... %@",[error localizedDescription]);
        return;
    }
}

@end
