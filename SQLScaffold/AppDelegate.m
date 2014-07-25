//
//  AppDelegate.m
//  SQLScaffold
//
//  Created by Stephen Hatton on 24/07/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import "AppDelegate.h"
#import "DataModelOne.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DataModelOne *modelOne = [[DataModelOne alloc] init];
    [modelOne setName:@"Stephen"];
    [[modelOne sql] update];
}

@end
