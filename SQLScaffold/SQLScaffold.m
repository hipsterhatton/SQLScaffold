//
//  SQLScaffold.m
//  SQLScaffold
//
//  Created by Stephen Hatton on 24/07/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import "SQLScaffold.h"
#define add(str1, str2) [str1 stringByAppendingString:str2]

@implementation SQLScaffold

# pragma - Core Methods

- (id)init
{
    _pathToDatabase = @"";
    _tableName = @"";
    _varsMonitored = [[NSMutableArray alloc] init];
    _columns = [[NSMutableArray alloc] init];
    _values = [[NSMutableArray alloc] init];
    return self;
}

- (id)initAndSetup:(NSString *)database :(NSString *)table :(NSObject *)parent :(NSArray *)vars
{
    _pathToDatabase = database;
    _tableName = table;
    _varsMonitored = [[NSMutableArray alloc] initWithArray:vars];

    _columns = [[NSMutableArray alloc] init];
    _values = [[NSMutableArray alloc] init];
    
    for (NSString *string in vars)
        [parent addObserver:self forKeyPath:string options:NSKeyValueObservingOptionNew context:NULL];
    
    return self;
}

- (void)setup:(NSString *)database :(NSString *)table :(NSObject *)parent :(NSArray *)vars
{
    _pathToDatabase = database;
    _tableName = table;
    [_varsMonitored addObjectsFromArray:vars];
    
    for (NSString *string in vars)
        [parent addObserver:self forKeyPath:string options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)takedown:(NSObject *)parent
{
    for (NSString *string in _varsMonitored)
        [parent removeObserver:self forKeyPath:string];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [_columns addObject:keyPath];
    [_values addObject:[object valueForKey:keyPath]];
}




# pragma - SQL Methods - Table Interaction

- (void)createTable
{
    // The #{eval} placeholder is used to indicate where the values of 2 arrays need combining together, along with another char inbetween them
    // E.g.: "arrayOne[1]=arrayTwo[1], arrayOne[2]=arrayTwo[2] ... arrayOne[n]=arrayTwo[n]"
    
    NSString *sql = @"CREATE TABLE ( #{eval} );";
    
    NSString *test = @"";
    test = [self _process:sql :@[ @"#{eval}" ] :@[ [self _evaluate:_values :_columns :@" "] ]];

    NSLog(@"Create Table: %@", test);
}

- (void)dropTable
{
    NSString *sql = @"DROP TABLE ( #{table} );";
    
    NSString *test = @"";
    test = [self _process:sql :@[ @"#{table}" ] :@[ _tableName ]];
    
    NSLog(@"Drop Table: %@", test);
}

# pragma - SQL Methods - Data Interaction

- (void)insert
{
    NSString *sql = @"INSERT INTO #{table} VALUES ( #{values} );";

    NSString *test = @"";
    test = [self _process:sql :@[ @"#{table}", @"#{values}" ] :@[ _tableName, _values] ];
    
    NSLog(@"Insert: %@", test);
}

- (void)update
{
    NSString *sql = @"UPDATE #{table} SET #{eval} ;";
    
    NSString *test = @"";
    test = [self _process:sql :@[ @"#{table}", @"#{eval}" ] :@[ _tableName, [self _evaluate:_columns :_values :@"="]] ];
    
    NSLog(@"Update: %@", test);
}

- (void)destrory
{
    NSString *sql = @"DELETE FROM #{table} WHERE #{eval} ;";
    
    NSString *test = @"";
    test = [self _process:sql :@[ @"#{table}", @"#{eval}" ] :@[ _tableName, @"Eval Goes Here!" ]];
    
    NSLog(@"Destroy: %@", test);
}

- (void)loadAll:(Order)order
{
    
}

- (void)loadSubset:(Order)order
{
    
}




# pragma - SQL Support Methods (Create Table)

- (void)addColumns:(ColumnTypes)columns
{
    NSString *columnType = @"";
    switch (columns) {
            
        case 0:
            columnType = @"NULL";
            break;
            
        case 1:
            columnType = @"Integer";
            break;
            
        case 2:
            columnType = @"Real";
            break;
            
        case 3:
            columnType = @"Text";
            break;
            
        case 4:
            columnType = @"Blob";
            break;
            
        case 5:
            columnType = @"DateText";
            break;
            
        case 6:
            columnType = @"DateInt";
            break;
            
        default:
            columnType = @"Text";
            break;
    }
    
    [_columns addObject:columnType];
}

- (void)addValues:(NSString *)name
{
    [_values addObject:name];
}




# pragma - Private SQL Processsing

- (NSString *)_evaluate:(NSArray *)arrayOne :(NSArray *)arrayTwo :(NSString *)extraValue
{
    NSString *evalStmt = @"";
    for (int a = 0; a < [arrayOne count]; a++) {
        evalStmt =  add(evalStmt, add(arrayOne[a], add(extraValue, arrayTwo[a])));
        if (a < [arrayOne count]-1)
            evalStmt = add(evalStmt, @", ");
    }
    
    return  evalStmt;
}

- (NSString *)_process:(NSString *)stmt :(NSArray *)hashMarkers :(NSArray *)actualValues
{
    for (int a = 0; a < [hashMarkers count]; a++) {
        if ([actualValues[a] isKindOfClass:[NSArray class]])
            stmt = [stmt stringByReplacingOccurrencesOfString:hashMarkers[a] withString:[self _flatten:actualValues[a] :@","]];
        else
            stmt = [stmt stringByReplacingOccurrencesOfString:hashMarkers[a] withString:actualValues[a]];
    }
    return stmt;
}

- (NSString *)_flatten:(NSArray *)array :(NSString *)extraValue
{
    NSString *flatten = @"";
    for (int a = 0; a < [array count]; a++) {
        flatten = add(flatten, array[a]);
        if (a < [array count]-1)
            flatten = add(flatten, extraValue);
    }
    
    return flatten;
}

@end














































































