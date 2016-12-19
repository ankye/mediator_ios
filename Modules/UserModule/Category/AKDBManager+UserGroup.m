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

AKDB_INSERT_OR_UPDATE_IMPL(user_group,AKUserGroup,KAK_TLUSER_DBNAME,TABLE_NAME_GROUP,SQL_INSERT_OR_UPDATE_GROUP)

-(BOOL)user_group_updateByID:(NSString*)uid withGid:(NSString*)gid withAttirbutes:(NSDictionary*)attributes
{
    return [self updateByParams:@{@"uid":uid,@"gid":gid} withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_GROUP withAttributes:attributes];
}


-(AKUserGroup*)user_group_queryByID:(NSString*)uid withGid:(NSString*)gid
{
    return (AKUserGroup*)[self queryRowByParams:@{@"uid":uid,@"gid":gid} withModel:[AKUserGroup class] withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_GROUP];
}

-(BOOL)user_group_deleteByUid:(NSString*)uid andGid:(NSString*)gid
{
    return [self deleteByParams:@{@"uid":uid,@"gid":gid} withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_GROUP];
}
@end
