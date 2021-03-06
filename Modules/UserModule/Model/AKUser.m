//
//  AKUser.m
//  Project
//
//  Created by ankye on 2016/12/9.
//  Copyright © 2016年 ankye. All rights reserved.
//
#import "UserModuleDefine.h"
#import "AKUser.h"
#import "AKUserDetail.h"
#import "ALModel+ActiveRecord.h"

@implementation AKUser

+ (NSString *)databaseIdentifier {
    return [FileHelper getFMDBPath:KAK_USER_DBNAME];
}

+ (nullable NSString *)tableName
{
    return @"user";
}

+ (nullable NSArray<NSArray<NSString *> *> *)uniqueKeys
{
    return @[@[@"uid"]];
}



//-(id)init
//{
//    self = [super init];
//    if(self){
//        self.detail = [[AKUserDetail alloc] init];
//    }
//    return self;
//}
//
//-(void)setUid:(NSString *)uid
//{
//    _uid = uid;
//    if(_detail){
//        _detail.uid = uid;
//    }
//    
//}
//
//-(void)fillData:(AKUser*)user
//{
//    if([user conformsToProtocol:@protocol(AKUserProtocol)]){
//       [self fillUserData:user];
//        
//    }
//    if(user.detail && [user.detail conformsToProtocol:@protocol(AKUserDetailProtocol)]){
//        if([self.detail.uid isEqualToString: self.uid]){
//            [self.detail fillData:user.detail];
//        }
//        
//    }
//    
//    
//}
//
//
//-(void)fillUserData:(id<AKUserProtocol>)user
//{
//    self.uid = user.uid;
//    self.usernum = user.usernum;
//    self.username = user.username;
//    self.nickname = user.nickname;
//    self.avatar = user.avatar;
//    self.avatarHD = user.avatarHD;
//    self.avatarPath = user.avatarPath;
//    self.remarkName = user.remarkName;
//    self.money = user.money;
//    self.coin = user.coin;
//    self.lastNicknameModifyTime = user.lastNicknameModifyTime;
//    self.lastLoginTime = user.lastLoginTime;
//    self.lastPayTime = user.lastPayTime;
//    self.pinyin = user.pinyin;
//    self.pinyinInitial = user.pinyinInitial;
//    
//}
//
//-(void)resultSetToModel:(FMResultSet*)retSet
//{
//    self.uid =  [retSet stringForColumn:@"uid"];
//    self.usernum =  [retSet stringForColumn:@"usernum"];
//    self.username =  [retSet stringForColumn:@"username"];
//    self.nickname =  [retSet stringForColumn:@"nickname"];
//    self.avatar =  [retSet stringForColumn:@"avatar"];
//    self.avatarHD =  [retSet stringForColumn:@"avatarHD"];
//    self.avatarPath =  [retSet stringForColumn:@"avatarPath"];
//    self.remarkName =  [retSet stringForColumn:@"remarkName"];
//    self.money =  @([retSet doubleForColumn:@"money"]);
//    self.coin =  @([retSet doubleForColumn:@"coin"]);
//    self.lastNicknameModifyTime =  @([retSet intForColumn:@"lastNicknameModifyTime"]);
//    self.lastLoginTime =  @([retSet intForColumn:@"lastLoginTime"]);
//    self.lastPayTime =  @([retSet intForColumn:@"lastPayTime"]);
//    self.pinyin =  [retSet stringForColumn:@"pinyin"];
//    self.pinyinInitial =  [retSet stringForColumn:@"pinyinInitial"];
//}
//
//-(NSArray*)modelToDBRecord
//{
//    NSArray *arrPara = [NSArray arrayWithObjects:
//                        self.uid,
//                        AKNoNilString(self.usernum),
//                        AKNoNilString(self.username),
//                        AKNoNilString(self.nickname),
//                        AKNoNilString(self.avatar),
//                        AKNoNilString(self.avatarHD),
//                        AKNoNilString(self.avatarPath),
//                        AKNoNilString(self.remarkName),
//                        AKNoNilNumber(self.money),
//                        AKNoNilNumber(self.coin),
//                        AKNoNilNumber(self.lastNicknameModifyTime),
//                        AKNoNilNumber(self.lastLoginTime),
//                        AKNoNilNumber(self.lastPayTime),
//                        AKNoNilString(self.pinyin),
//                        AKNoNilString(self.pinyinInitial),
//                        @"", @"", @"", @"", @"", nil];
//    return arrPara;
//}
@end
