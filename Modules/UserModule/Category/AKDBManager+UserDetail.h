//
//  AKDBManager+UserDetail.h
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"
#import "TLDBUserDetailSQL.h"
#import "AKUserDetail.h"

@interface AKDBManager (UserDetail)


AKDB_CREATE_TABLE_INTR(user_detail)

AKDB_INSERT_OR_REPLACE_INTR(user_detail,AKUserDetail)

-(BOOL)user_detail_updateByID:(NSString*)uid withAttirbutes:(NSDictionary*)attributes;


-(AKUserDetail*)user_detail_queryByID:(NSString*)uid;


-(BOOL)user_detail_deleteByID:(NSString*)uid;


@end
