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

AKDB_INSERT_OR_REPLACE_IMPL(user,AKUser,KAK_TLUSER_DBNAME,TABLE_NAME_USER,SQL_INSERT_OR_REPLACE_USER)


-(BOOL)user_updateByID:(NSString*)uid withAttirbutes:(NSDictionary*)attributes
{
    return [self updateByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER andWhereParams:@{@"uid":uid} withAttributes:attributes];
    
}

-(AKUser*)user_queryByID:(NSString*)uid
{
    return (AKUser*)[self queryRowByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER andWhereParams:@{@"uid":uid} withModel:[AKUser class]];

    
}



-(BOOL)user_deleteByID:(NSString*)uid
{
    return [self deleteByParamsWithDBName:KAK_TLUSER_DBNAME withTableName:TABLE_NAME_USER andWhereParams:@{@"uid":uid}];
    

}



@end
