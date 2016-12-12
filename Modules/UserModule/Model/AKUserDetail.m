//
//  AKUserDetail.m
//  Project
//
//  Created by ankye on 2016/12/12.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUserDetail.h"
#import "AKUserDetailProtocol.h"

@implementation AKUserDetail

-(void)fillData:(id<AKUserDetailProtocol>)user
{
    self.uid = user.uid;
    self.sex = user.sex;
    self.location = user.location;
    self.phoneNumber = user.phoneNumber;
    self.qqNumber = user.qqNumber;
    self.email = user.email;
    self.albumArray = user.albumArray;
    self.motto = user.motto;
    self.momentsWallURL = user.momentsWallURL;
    self.address = user.address;
    self.birthday = user.birthday;
    self.hometown = user.hometown;
    self.latitude = user.latitude;
    self.longitude = user.longitude;
    self.remarkInfo = user.remarkInfo;
    self.remarkImagePath = user.remarkImagePath;
    self.remarkImageURL = user.remarkImageURL;
    self.tags = user.tags;
}
@end
