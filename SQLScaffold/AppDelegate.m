//
//  AppDelegate.m
//  SQLScaffold
//
//  Created by Stephen Hatton on 24/07/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import "AppDelegate.h"
#import "DataModelOne.h"
#import "DataModelTwo.h"
#import "DataModelThree.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DataModelOne *modelOne = [[DataModelOne alloc] init];
//    DataModelTwo *modelTwo = [[DataModelTwo alloc] init];
//    DataModelThree *modelThree = [[DataModelThree alloc] init];
    
    [modelOne setName:@"Stephen"];
    [[modelOne sql] update];
    
    [modelOne setAge:22];
    [[modelOne sql] update];
    
    [modelOne setDob:[NSDate date]];
    [[modelOne sql] update];
}

@end
