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

AKDB_INSERT_OR_UPDATE_IMPL(user_detail,AKUserDetail,KAK_TLUSER_DBNAME,TABLE_NAME_USERDETAIL,SQL_INSERT_OR_UPDATE_USERDETAIL)

-(BOOL)user_detail_updateByID:(NSString*)uid withAttirbutes:(NSDictionary*)attributes
{
    return [self updateByParams:@{@"uid":uid} withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL withAttributes:attributes];
}


-(AKUserDetail*)user_detail_queryByID:(NSString*)uid
{
    return (AKUserDetail*)[self queryRowByParams:@{@"uid":uid} withModel:[AKUserDetail class] withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL];
}

-(BOOL)user_detail_deleteByID:(NSString*)uid
{
    return [self deleteByParams:@{@"uid":uid} withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USERDETAIL];
}

@end
