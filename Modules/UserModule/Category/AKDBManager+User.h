//
//  AKDBManager+User.h
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//
#import "UserModuleDefine.h"
#import "AKDBManager.h"
#import "TLDBUserSQL.h"


@interface AKDBManager (User)

AKDB_CREATE_TABLE_INTR(user)

AKDB_INSERT_OR_UPDATE_INTR(user,AKUser)


-(BOOL)user_updateByID:(NSString*)uid withAttirbutes:(NSDictionary*)attributes;


-(AKUser*)user_queryByID:(NSString*)uid;


-(BOOL)user_deleteByID:(NSString*)uid;


@end
