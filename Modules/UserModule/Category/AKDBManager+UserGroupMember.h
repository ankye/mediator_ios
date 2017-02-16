//
//  AKDBManager+UserGroupMember.h
//  Project
//
//  Created by ankye on 2016/12/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"
#import "TLDBUserGroupMemberSQL.h"
#import "AKUserGroupMember.h"

@interface AKDBManager (UserGroupMember)

AKDB_CREATE_TABLE_INTR(user_group_member)

AKDB_INSERT_OR_REPLACE_INTR(user_group_member,AKUserGroupMember)



-(NSArray*)user_group_member_queryRowsByID:(NSString*)uid withGid:(NSString*)gid;

-(AKUserGroupMember*)user_group_member_queryRowByID:(NSString*)uid withGid:(NSString*)gid withFid:(NSString*)fid;


-(BOOL)user_group_memeber_deleteByUid:(NSString*)uid andGid:(NSString*)gid andFid:(NSString*)fid;

@end
