//
//  DataModelTwo.m
//  SQLScaffold
//
//  Created by Stephen Hatton on 25/07/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import "DataModelTwo.h"

@implementation DataModelTwo

- (id)init
{
    _name = @"";
    _address = @"";
    _age = 0;
    
    _sql = [[SQLScaffold alloc] init];
    [_sql setup:@"name of database" :@"name of table" :self :@[
                                                               k(name), k(address), k(age)
                                                               ]];
    return self;
}

- (void)dealloc
{
    [_sql takedown:self];
}

@end
