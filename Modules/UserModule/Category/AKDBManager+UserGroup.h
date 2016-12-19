//
//  AKDBManager+UserGroup.h
//  Project
//
//  Created by ankye on 2016/12/13.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"
#import "AKUserGroup.h"
#import "TLDBUserGroupSQL.h"

@interface AKDBManager (UserGroup)

AKDB_CREATE_TABLE_INTR(user_group)

AKDB_INSERT_OR_UPDATE_INTR(user_group,AKUserGroup)

-(BOOL)user_group_updateByID:(NSString*)uid withGid:(NSString*)gid withAttirbutes:(NSDictionary*)attributes;


-(AKUserGroup*)user_group_queryByID:(NSString*)uid withGid:(NSString*)gid;


-(BOOL)user_group_deleteByUid:(NSString*)uid andGid:(NSString*)gid;


@end
