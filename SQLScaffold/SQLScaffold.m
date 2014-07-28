//
//  SQLScaffold.m
//  SQLScaffold
//
//  Created by Stephen Hatton on 24/07/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import "SQLScaffold.h"
#define add(str1, str2)     [str1 stringByAppendingString:str2]
#define sqlite_date_format  @"YYYY-MM-DD HH:MM:SS"

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
    NSLog(@"Class: %@", [[object valueForKey:keyPath] class]);
    NSString *str = @"";
    
    if ([[object valueForKey:keyPath] isKindOfClass:[NSString class]]) {
    
        NSLog(@"String...");
        str = [NSString stringWithFormat:@"%@", [[object valueForKey:keyPath] valueForKey:@"description"]];
        str = add(@"\"", add(str, @"\""));
        
        
    } else if ([[object valueForKey:keyPath] isKindOfClass:[NSNumber class]]) {
        
        NSLog(@"Numbers...");
        str = [NSString stringWithFormat:@"%@", [[object valueForKey:keyPath] valueForKey:@"description"]];
        
        
    } else if ([[object valueForKey:keyPath] isKindOfClass:[NSDate class]]) {
        
        NSLog(@"Date...");        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:sqlite_date_format];
        str = [formatter stringFromDate:[object valueForKey:keyPath]];
        str = add(@"\"", add(str, @"\""));
        
    }
    
    [_columns addObject:keyPath];
    [_values addObject:str];
    
    NSLog(@"Values: %@", _values);
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
        
        NSString *arrayOneStr = [NSString stringWithFormat:@"%@", [[arrayOne objectAtIndex:a] valueForKey:@"description"]];
        NSString *arrayTwoStr = [NSString stringWithFormat:@"%@", [[arrayTwo objectAtIndex:a] valueForKey:@"description"]];
        
        evalStmt =  add(evalStmt, add(arrayOneStr, add(extraValue, arrayTwoStr)));
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


/*
 
 CODE TO DO:
 
 - Add support for FMDB / get the loading statements done
 
 - Add where statement support -- not sure about this one!
 
 - Completely test this through! Write read me and push to GitHub
 
*/











































































