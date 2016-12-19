//
//  AKDBManager+User.m
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager+User.h"

#import "AKDBManager+UserDetail.h"

@implementation AKDBManager (User)



AKDB_CREATE_TABLE_IMPL(user,KAK_TLUSER_DBNAME,TABLE_NAME_USER,SQL_CREATE_TABLE_USER)

AKDB_INSERT_OR_UPDATE_IMPL(user,AKUser,KAK_TLUSER_DBNAME,TABLE_NAME_USER,SQL_INSERT_OR_UPDATE_USER)


-(BOOL)user_updateByID:(NSString*)uid withAttirbutes:(NSDictionary*)attributes
{
    return [self updateByParams:@{@"uid":uid} withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER withAttributes:attributes];
    
}

-(AKUser*)user_queryByID:(NSString*)uid
{
    return (AKUser*)[self queryRowByParams:@{@"uid":uid} withModel:[AKUser class] withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER];
    
}



-(BOOL)user_deleteByID:(NSString*)uid
{
    return [ self deleteByParams:@{@"uid":uid} withDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER];
    
}



@end
