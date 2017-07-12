//
//  AKDBManager+Book.m
//  Project
//
//  Created by ankye on 2017/2/15.
//  Copyright © 2017年 ankye. All rights reserved.
//
#import "ReaderModuleDefine.h"
#import "AKDBManager+Book.h"
#import "AKDBBookSQL.h"

@implementation AKDBManager (Book)


//
//AKDB_CREATE_TABLE_IMPL(book,KAK_READER_DBNAME,KAK_TABLE_NAME_BOOK,SQL_CREATE_TABLE_BOOK)
//
//AKDB_INSERT_OR_REPLACE_IMPL(book,Book,KAK_READER_DBNAME,KAK_TABLE_NAME_BOOK,SQL_INSERT_OR_REPLACE_BOOK)


-(BOOL)book_updateByID:(NSString*)bookid withAttirbutes:(NSDictionary*)attributes
{
//    return [self updateByParamsWithDBName:KAK_READER_DBNAME withTableName:KAK_TABLE_NAME_BOOK andWhereParams:@{@"novel_id":bookid} withAttributes:attributes];
    return YES;
}

-(Book*)book_queryByID:(NSString*)bookid
{
//    return (Book*)[self queryRowByParamsWithDBName:KAK_READER_DBNAME withTableName:KAK_TABLE_NAME_BOOK andWhereParams:@{@"novel_id":bookid} withModel:[AKUser class]];

    return nil;
    
}



-(BOOL)book_deleteByID:(NSString*)bookid
{
//    return [self deleteByParamsWithDBName:KAK_READER_DBNAME withTableName:KAK_TABLE_NAME_BOOK andWhereParams:@{@"novel_id":bookid}];
    
    return YES;
}

-(NSArray*)book_queryAll
{
  //  return [self queryAllRowsWithDBName:KAK_READER_DBNAME withTableName:KAK_TABLE_NAME_BOOK withModel:[Book class]];
    return nil;
}

@end
