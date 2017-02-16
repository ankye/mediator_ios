//
//  AKDBManager+UserGroup.m
//  Project
//
//  Created by ankye on 2016/12/13.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+UserGroup.h"

@implementation AKDBManager (UserGroup)


AKDB_CREATE_TABLE_IMPL(user_group,KAK_TLUSER_DBNAME,TABLE_NAME_GROUP,SQL_CREATE_TABLE_GROUP)

AKDB_INSERT_OR_REPLACE_IMPL(user_group,AKUserGroup,KAK_TLUSER_DBNAME,TABLE_NAME_GROUP,SQL_INSERT_OR_REPLACE_GROUP)

-(BOOL)user_group_updateByID:(NSString*)uid withGid:(NSString*)gid withAttirbutes:(NSDictionary*)attributes
{

    return [self updateByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_GROUP andWhereParams:@{@"uid":uid,@"gid":gid} withAttributes:attributes];
}


-(AKUserGroup*)user_group_queryByID:(NSString*)uid withGid:(NSString*)gid
{
    return (AKUserGroup*)[self queryRowByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_GROUP andWhereParams:@{@"uid":uid,@"gid":gid} withModel:[AKUserGroup class]];
 
}

-(BOOL)user_group_deleteByUid:(NSString*)uid andGid:(NSString*)gid
{
    return [self deleteByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_GROUP andWhereParams:@{@"uid":uid,@"gid":gid}];
    
}
@end
