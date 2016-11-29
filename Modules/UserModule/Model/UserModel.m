//
//  UserModel.m
//  XYTV
//
//  Created by huk on 16/1/4.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "UserModel.h"
#import <YYKit/YYKit.h>



@implementation UserModel



-(void)setKey:(NSString*)key
{
    NSInteger num = [key integerValue];
    self.uid = @(num);
}

-(NSString*)getKey
{
   return [self.uid stringValue];
}

-(void)fillData:(id<AKDataCenterObjectProtocol>)object
{
    UserModel* model = (UserModel*)object;
    self.uid = model.uid;//Id号
    self.usernum = model.usernum;//靓号
    self.head = model.head;//封面头像
    self.nickname =model.nickname;//昵称
    self.sign = model.sign;//签名
    self.phone = model.phone;//手机号
    self.email = model.email;//邮箱
    self.token = model.token;//token
    self.money = model.money;//自己冲的货币
    self.third = model.third;//是否第三方
    self.viplevel = model.viplevel;//等级
    self.lastmodnickname = model.lastmodnickname;//最后一次修改昵称时间
    self.sex = model.sex;//性别
    self.fans = model.fans;//粉丝数
    self.follow = model.follow;//关注数
    self.address = model.address;//地址
    self.rz = model.rz; //认证状态 0 未审核， 1审核中， 2认证通过，3认证失败
    self.security = model.security; //安全码
    self.is_manager = model.is_manager; //等于9 是超管
    self.head_640 = model.head_640; //大头像
    self.birthday = model.birthday;// 生日
    self.hometown = model.hometown;// 故乡
    self.version = model.version;//系统版本好
    self.user_tag = model.user_tag;//0-普通，1-加v认证， 2-官方号， 3-特殊身份
    self.anchor = model.anchor; //用户类型，1 普通主播 2 签约主播 3官方签约
    self.show_author_type_tag = model.show_author_type_tag; //0:不显示 1:显示
    self.gameb = model.gameb; //游戏币余额
    //v1.1.4
    self.after_noble_exp = model.after_noble_exp;//下一级所需经验
    self.before_noble_exp = model.before_noble_exp;//当前等级经验
    self.noble_exp = model.noble_exp;//当前经验
    self.upgrade_progress = model.upgrade_progress;//下等级开始经验 0.2；
    self.medal_id = model.medal_id;//个人勋章 为空表示无
    self.last_login_time = model.last_login_time;//最后一次登录时间 为空表示首次登录
    

       
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}
- (NSUInteger)hash {
    return [self modelHash];
}
- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}



-(void)setLongitude:(double)longitude
{
    _longitude = longitude;
  //  [self.onUserUpdate dispatch:self];
}
-(void)setLatitude:(double)latitude
{

    _latitude = latitude;
   
    //[self.onUserUpdate dispatch:self];
}

@end
