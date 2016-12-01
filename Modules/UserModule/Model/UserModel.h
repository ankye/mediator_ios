//
//  UserModel.h
//  XYTV
//
//  Created by huk on 16/1/4.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBBaseObject.h"

@interface UserModel : DBBaseObject<AKDataCenterObjectProtocol,NSCoding, NSCopying>

@property (nonatomic, strong)NSNumber *uid;//Id号

@property (nonatomic, strong)NSNumber *usernum;//靓号

@property (nonatomic, strong)NSString *head;//封面头像

@property (nonatomic, strong)NSString *nickname;//昵称

@property (nonatomic, strong)NSString *sign;//签名

@property (nonatomic, strong)NSString *phone;//手机号

@property (nonatomic, strong)NSString *email;//邮箱

@property (nonatomic, strong)NSString *token;//token

@property (nonatomic, strong)NSNumber *money;//自己冲的货币

@property (nonatomic, strong)NSNumber *third;//是否第三方

@property (nonatomic, strong)NSNumber *viplevel;//等级

@property (nonatomic, strong)NSNumber *lastmodnickname;//最后一次修改昵称时间

@property (nonatomic, strong)NSNumber *sex;//性别

@property (nonatomic, strong)NSNumber *fans;//粉丝数

@property (nonatomic, strong)NSNumber *follow;//关注数

@property (nonatomic, strong)NSString *address;//地址

@property (nonatomic, strong)NSNumber *rz; //认证状态 0 未审核， 1审核中， 2认证通过，3认证失败

@property (nonatomic, strong)NSString *security; //安全码

@property (nonatomic, strong)NSNumber * is_manager; //等于9 是超管

@property (nonatomic, strong)NSString * head_640; //大头像

@property (nonatomic, strong)NSString * birthday;// 生日

@property (nonatomic, strong)NSString * hometown;// 故乡
//LIVE_LONGMUTE		 		    = HTTP_HEAD_LIVE_BASE + "manage/addlongmute";//禁言

//extener
@property (nonatomic, strong)NSString * version;//系统版本好

@property (nonatomic, strong)NSNumber * user_tag;//0-普通，1-加v认证， 2-官方号， 3-特殊身份

@property (nonatomic, strong)NSNumber * anchor; //用户类型，1 普通主播 2 签约主播 3官方签约

@property (nonatomic, strong)NSNumber * show_author_type_tag; //0:不显示 1:显示


@property (nonatomic, strong)NSNumber * gameb; //游戏币余额

//v1.1.4
@property (strong, nonatomic)NSNumber * after_noble_exp;//下一级所需经验

@property (strong, nonatomic)NSNumber * before_noble_exp;//当前等级经验

@property (strong, nonatomic)NSNumber * noble_exp;//当前经验

@property (strong, nonatomic)NSString * upgrade_progress;//下等级开始经验 0.2；

@property (copy, nonatomic)NSString * medal_id;//个人勋章 为空表示无

@property (strong, nonatomic)NSString * last_login_time;//最后一次登录时间 为空表示首次登录

@property (nonatomic,assign) double latitude;  //纬度

@property (nonatomic,assign) double longitude;  //经度



@end
