//
//  AKDBManager+UserGroupMember.m
//  Project
//
//  Created by ankye on 2016/12/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+UserGroupMember.h"

@implementation AKDBManager (UserGroupMember)


AKDB_CREATE_TABLE_IMPL(user_group_member,KAK_TLUSER_DBNAME,TABLE_NAMGE_GROUP_MEMBER,SQL_CREATE_TABLE_GROUP_MEMBER)

AKDB_INSERT_OR_REPLACE_IMPL(user_group_member,AKUserGroupMember,KAK_TLUSER_DBNAME,TABLE_NAMGE_GROUP_MEMBER,SQL_INSERT_OR_REPLACE_GROUP_MEMBER)


-(NSArray*)user_group_member_queryRowsByID:(NSString*)uid withGid:(NSString*)gid
{
    
    return [self queryRowsByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAMGE_GROUP_MEMBER andWhereParams:@{@"uid":uid,@"gid":gid} withModel:[AKUserGroupMember class]];
}

-(AKUserGroupMember*)user_group_member_queryRowByID:(NSString*)uid withGid:(NSString*)gid withFid:(NSString*)fid
{
    return (AKUserGroupMember*)[self queryRowByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAMGE_GROUP_MEMBER andWhereParams:@{@"uid":uid,@"gid":gid,@"fid":fid} withModel:[AKUserGroupMember class]];

}


-(BOOL)user_group_memeber_deleteByUid:(NSString*)uid andGid:(NSString*)gid andFid:(NSString*)fid
{
    return [self deleteByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAMGE_GROUP_MEMBER andWhereParams:@{@"uid":uid,@"gid":gid,@"fid":fid}];
   
}

@end
