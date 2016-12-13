//
//  AKUserDetail.h
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKBaseModel.h"
#import "AKUserDetailProtocol.h"

@interface AKUserDetail : AKBaseModel<AKUserDetailProtocol>


@property (nonatomic, strong) NSString *uid;
//性别
@property (nonatomic, assign) NSInteger sex;
//地区
@property (nonatomic, strong) NSString *location;
//手机号
@property (nonatomic, strong) NSString *phoneNumber;
//qq号
@property (nonatomic, strong) NSString *qqNumber;
//email地址
@property (nonatomic, strong) NSString *email;
//相册
@property (nonatomic, strong) NSMutableArray *albumArray;
//个人签名
@property (nonatomic, strong) NSString *motto;
//朋友圈
@property (nonatomic, strong) NSString *momentsWallURL;
//地址
@property (nonatomic, strong)NSString *address;
// 生日
@property (nonatomic, strong)NSString * birthday;
// 故乡
@property (nonatomic, strong)NSString * hometown;
//纬度
@property (nonatomic,assign) double latitude;
//经度
@property (nonatomic,assign) double longitude;

/// 备注信息
@property (nonatomic, strong) NSString *remarkInfo;

/// 备注图片（本地地址）
@property (nonatomic, strong) NSString *remarkImagePath;

/// 备注图片 (URL)
@property (nonatomic, strong) NSString *remarkImageURL;

/// 标签
@property (nonatomic, strong) NSMutableArray *tags;

-(void)fillData:(id<AKUserDetailProtocol>)user;

@end
