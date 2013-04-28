//
//  AppDelegate.h
//  DealGenda
//
//  Created by Douglas Abrams on 1/28/13.
//  Copyright (c) 2013 DealGenda. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    FMDatabase *db;   
}

@property (nonatomic, retain) FMDatabase *db;
@property (nonatomic, retain) NSNumber *user;

@property (strong, nonatomic) UIWindow *window;

@end
