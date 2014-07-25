//
//  DataModelOne.h
//  SQLScaffold
//
//  Created by Stephen Hatton on 25/07/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLScaffold.h"

@interface DataModelOne : NSObject

@property (nonatomic, retain) SQLScaffold *sql;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic) int age;

@end
