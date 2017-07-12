//
//  AKUserGroupMember.m
//  Project
//
//  Created by ankye on 2016/12/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUserGroupMember.h"
#import "UserModuleDefine.h"

@implementation AKUserGroupMember

+ (NSString *)databaseIdentifier {
    return [FileHelper getFMDBPath:KAK_USER_DBNAME];
}

+ (nullable NSString *)tableName
{
    return @"user_group_member";
}

+ (nullable NSArray<NSArray<NSString *> *> *)uniqueKeys
{
    return @[@[@"gid",@"uid"]];
}


@end
