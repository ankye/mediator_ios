//
//  AKDBManager+UserDetail.m
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+UserDetail.h"
#import "UserModuleDefine.h"
#import "TLDBUserDetailSQL.h"
#import "AKUserDetail.h"

@implementation AKDBManager (UserDetail)


AKDB_CREATE_TABLE_IMPL(user_detail,KAK_TLUSER_DBNAME,TABLE_NAME_USERDETAIL,SQL_CREATE_TABLE_USERDETAIL)

AKDB_INSERT_OR_REPLACE_IMPL(user_detail,AKUserDetail,KAK_TLUSER_DBNAME,TABLE_NAME_USERDETAIL,SQL_INSERT_OR_REPLACE_USERDETAIL)

-(BOOL)user_detail_updateByID:(NSString*)uid withAttirbutes:(NSDictionary*)attributes
{
    return [self updateByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL andWhereParams:@{@"uid":uid} withAttributes:attributes];

}


-(AKUserDetail*)user_detail_queryByID:(NSString*)uid
{
    return (AKUserDetail*)[self queryRowByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL andWhereParams:@{@"uid":uid} withModel:[AKUserDetail class]];

}

-(BOOL)user_detail_deleteByID:(NSString*)uid
{
    return [self deleteByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL andWhereParams:@{@"uid":uid}];

}

@end
