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
    
    [modelOne setName:@"Stephen"];
    [modelOne setAddress:@"My Address Will Go Here..."];
    [modelOne setAge:22];
    [modelOne setDob:[NSDate date]];
    
    [[modelOne sql] update];
}

@end
