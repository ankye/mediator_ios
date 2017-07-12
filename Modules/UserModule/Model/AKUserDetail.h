//
//  AKUserDetail.h
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//


@interface AKUserDetail : ALModel 


@property (nonatomic, copy) NSString* uid;
//性别
@property (nonatomic, assign) NSInteger sex;
//地区
@property (nonatomic, copy) NSString *location;
//手机号
@property (nonatomic, copy) NSString *phoneNumber;
//qq号
@property (nonatomic, copy) NSString *qqNumber;
//email地址
@property (nonatomic, copy) NSString *email;
//相册
@property (nonatomic, strong) NSMutableArray *albumArray;
//个人签名
@property (nonatomic, copy) NSString *motto;
//朋友圈
@property (nonatomic, copy) NSString *momentsWallURL;
//地址
@property (nonatomic, copy)NSString *address;
// 生日
@property (nonatomic, copy)NSString * birthday;
// 故乡
@property (nonatomic, copy)NSString * hometown;
//纬度
@property (nonatomic,assign) double latitude;
//经度
@property (nonatomic,assign) double longitude;

/// 备注信息
@property (nonatomic, copy) NSString *remarkInfo;

/// 备注图片（本地地址）
@property (nonatomic, copy) NSString *remarkImagePath;

/// 备注图片 (URL)
@property (nonatomic, copy) NSString *remarkImageURL;

/// 标签
@property (nonatomic, copy) NSMutableArray *tags;


@end
