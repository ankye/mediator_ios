//
//  AKUser.m
//  Project
//
//  Created by ankye on 2016/12/9.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUser.h"
#import "AKUserDetail.h"

@implementation AKUser

-(id)init
{
    self = [super init];
    if(self){
        self.detail = [[AKUserDetail alloc] init];
    }
    return self;
}

-(void)setUid:(NSString *)uid
{
    _uid = uid;
    if(_detail){
        _detail.uid = uid;
    }
    
}

-(void)fillData:(AKUser*)user
{
    if([user conformsToProtocol:@protocol(AKUserProtocol)]){
       [self fillUserData:user];
        
    }
    if(user.detail && [user.detail conformsToProtocol:@protocol(AKUserDetailProtocol)]){
        if([self.detail.uid isEqualToString: self.uid]){
            [self.detail fillData:user.detail];
        }
        
    }
    
    
}


-(void)fillUserData:(id<AKUserProtocol>)user
{
    self.uid = user.uid;
    self.usernum = user.usernum;
    self.username = user.username;
    self.nickname = user.nickname;
    self.avatar = user.avatar;
    self.avatarHD = user.avatarHD;
    self.avatarPath = user.avatarPath;
    self.remarkName = user.remarkName;
    self.money = user.money;
    self.coin = user.coin;
    self.lastNicknameModifyTime = user.lastNicknameModifyTime;
    self.lastLoginTime = user.lastLoginTime;
    self.lastPayTime = user.lastPayTime;
    self.pinyin = user.pinyin;
    self.pinyinInitial = user.pinyinInitial;
    
}

-(void)resultSetToModel:(FMResultSet*)retSet
{
    self.uid =  [retSet stringForColumn:@"uid"];
    self.usernum =  [retSet stringForColumn:@"usernum"];
    self.username =  [retSet stringForColumn:@"username"];
    self.nickname =  [retSet stringForColumn:@"nickname"];
    self.avatar =  [retSet stringForColumn:@"avatar"];
    self.avatarHD =  [retSet stringForColumn:@"avatarHD"];
    self.avatarPath =  [retSet stringForColumn:@"avatarPath"];
    self.remarkName =  [retSet stringForColumn:@"remarkName"];
    self.money =  @([retSet doubleForColumn:@"money"]);
    self.coin =  @([retSet doubleForColumn:@"coin"]);
    self.lastNicknameModifyTime =  @([retSet intForColumn:@"lastNicknameModifyTime"]);
    self.lastLoginTime =  @([retSet intForColumn:@"lastLoginTime"]);
    self.lastPayTime =  @([retSet intForColumn:@"lastPayTime"]);
    self.pinyin =  [retSet stringForColumn:@"pinyin"];
    self.pinyinInitial =  [retSet stringForColumn:@"pinyinInitial"];
}

-(NSArray*)modelToDBRecord
{
    NSArray *arrPara = [NSArray arrayWithObjects:
                        self.uid,
                        TLNoNilString(self.usernum),
                        TLNoNilString(self.username),
                        TLNoNilString(self.nickname),
                        TLNoNilString(self.avatar),
                        TLNoNilString(self.avatarHD),
                        TLNoNilString(self.avatarPath),
                        TLNoNilString(self.remarkName),
                        TLNoNilNumber(self.money),
                        TLNoNilNumber(self.coin),
                        TLNoNilNumber(self.lastNicknameModifyTime),
                        TLNoNilNumber(self.lastLoginTime),
                        TLNoNilNumber(self.lastPayTime),
                        TLNoNilString(self.pinyin),
                        TLNoNilString(self.pinyinInitial),
                        @"", @"", @"", @"", @"", nil];
    return arrPara;
}
@end
