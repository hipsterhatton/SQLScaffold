//
//  SQLScaffold.h
//  SQLScaffold
//
//  Created by Stephen Hatton on 24/07/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import <Foundation/Foundation.h>
#define k(__KEY__)  (NSStringFromSelector(@selector(__KEY__))) // This is used to extract the actual name from variables

typedef enum {
    Asc =   2,
    Desc =  0,
    None =  -1
} Order;
typedef enum  {
    Null =      0,
    Integer =   1,
    Real =      2,
    Text =      3,
    Blob =      4,
    DateText =  5,
    DateInt =   6
} ColumnTypes;



@interface SQLScaffold : NSObject

@property (nonatomic, retain) NSString *pathToDatabase;
@property (nonatomic, retain) NSString *tableName;
@property (nonatomic, retain) NSMutableArray *varsMonitored;

@property (nonatomic, retain) NSMutableArray *columns;
@property (nonatomic, retain) NSMutableArray *values;



- (id)initAndSetup:(NSString *)database :(NSString *)table :(NSObject *)parent :(NSArray *)vars;
- (void)setup:(NSString *)database :(NSString *)table :(NSObject *)parent :(NSArray *)vars;
- (void)takedown:(NSObject *)parent;

- (void)addColumns:(ColumnTypes)columns;
- (void)addValues:(NSString *)name;

- (void)createTable;
- (void)dropTable;

- (void)insert;
- (void)update;
- (void)destrory;
- (void)loadAll:(Order)order;
- (void)loadSubset:(Order)order;

@end
