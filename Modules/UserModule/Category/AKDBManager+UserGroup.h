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

AKDB_UPDATE_BY_ID_AND_ANOTHER_ID_INTR(user_group)

AKDB_QUERY_ROWS_BY_ID_INTR(user_group)

AKDB_QUERY_ROW_BY_ID_INTR(user_group,AKUserGroup)

AKDB_DELETE_BY_ID_AND_ANOTHER_ID_INTR(user_group)

@end
