//
//  ViewController.m
//  DealGenda
//
//  Created by Douglas Abrams on 1/28/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [libraryDirectory stringByAppendingPathComponent:@"Database/DealGenda.db"];
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    
    if (![db open]) {
        return;
    }
	// Do any additional setup after loading the view, typically from a nib.
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
