//
//  AppDelegate.h
//  DealGenda
//
//  Created by Douglas Abrams on 1/28/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    FMDatabase *db;   
}

@property (nonatomic, retain) FMDatabase *db;
@property (nonatomic, retain) NSString *username;

@property (strong, nonatomic) UIWindow *window;

@end
