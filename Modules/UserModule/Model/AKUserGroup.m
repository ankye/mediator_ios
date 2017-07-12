//
//  TLUserGroup.m
//  TLChat
//
//  Created by 李伯坤 on 16/1/26.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "AKUserGroup.h"
#import "UserModuleDefine.h"

@implementation AKUserGroup

+ (NSString *)databaseIdentifier {
    return [FileHelper getFMDBPath:KAK_USER_DBNAME];
}

+ (nullable NSString *)tableName
{
    return @"user_group";
}

+ (nullable NSArray<NSArray<NSString *> *> *)uniqueKeys
{
    return @[@[@"gid",@"uid"]];
}


//- (id) initWithGroupName:(NSString *)name members:(NSMutableArray *)members
//{
//    if (self = [super init]) {
//        self.name = name;
//        if(members == nil){
//            self.members = [[NSMutableArray alloc] init];
//        }else{
//            self.members = members;
//        }
//    }
//    return self;
//}
//
//
//
//- (NSInteger) count
//{
//    return self.members.count;
//}
//
//- (void)addMember:(id)anObject
//{
//    [self.members addObject:anObject];
//}
//
//- (id) memberAtIndex:(NSUInteger)index
//{
//    return [self.members objectAtIndex:index];
//}

@end
