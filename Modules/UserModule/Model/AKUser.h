//
//  AKUser.h
//  Project
//
//  Created by ankye on 2016/12/9.
//  Copyright © 2016年 ankye. All rights reserved.
//
#import "AKUserDetail.h"


@interface AKUser : ALModel

/// 用户ID
@property (nonatomic, copy) NSString  * uid;

//靓号
@property (nonatomic, copy) NSString *usernum;

/// 用户名
@property (nonatomic, copy) NSString *username;

/// 昵称
@property (nonatomic, copy) NSString *nickname;

/// 头像URL
@property (nonatomic, copy) NSString *avatar;

/// 头像hd URL
@property (nonatomic, copy) NSString *avatarHD;

/// 头像Path
@property (nonatomic, copy) NSString *avatarPath;

/// 备注名
@property (nonatomic, copy) NSString *remarkName;

//钱
@property (nonatomic, strong) NSNumber *money;
//二级货币
@property (nonatomic, strong) NSNumber *coin;

//最后一次修改昵称时间
@property (nonatomic, strong) NSNumber* lastNicknameModifyTime;
//最后一次登录时间 为空表示首次登录
@property (nonatomic, strong) NSNumber* lastLoginTime;
//最后一次充值时间 为空表示首次支付
@property (nonatomic, strong) NSNumber* lastPayTime;


#pragma mark - 列表用

@property (nonatomic, copy) NSString *pinyin;

@property (nonatomic, copy) NSString *pinyinInitial;


@property (nonatomic,strong)AKUserDetail* detail;

/**
 * @return The name of database table that associates with this model.
 * Normally, the model name should be a noun of English. so the default value return would be the pluralize of model name.
 * a) If the model name ends with "Model", the subfix "Model" will be removed in the table name.
 * b) If the model name is not ends with English letter, the subfix "_list" will be added to table name.
 * c) If the model name is CamelCase style, the table name will be converted to lowercase words and joined with "_".
 *
 * eg: "UserModel" => "users", "fileMeta" => "file_metas".
 */
+ (nullable NSString *)tableName;

/**
 *  @return The database identifier (normally the database file path) that associates with this model.
 *  Return nil if the model doesn't bind to any database.
 */
+ (nullable NSString *)databaseIdentifier;

+ (nullable NSArray<NSArray<NSString *> *> *)uniqueKeys;



//@property (nonatomic,strong) id<AKUserDetailProtocol,AKDataObjectProtocol> detail;
//@property (nonatomic,strong) id<AKUserHonorProtocol,AKDataObjectProtocol> honor;
//@property (nonatomic,strong) id<AKUserWeiboProtocol,AKDataObjectProtocol> weibo;
//@property (nonatomic,strong) id<AKUserChatSettingProtocol,AKDataObjectProtocol> chatSetting;
//

//-(void)fillData:(AKUser*)data;

@end
