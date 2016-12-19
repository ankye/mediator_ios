//
//  AKUserGroupMember.h
//  Project
//
//  Created by ankye on 2016/12/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKBaseModel.h"
#import "AKUserGroupMemberProtocol.h"

@interface AKUserGroupMember : AKBaseModel <AKUserGroupMemberProtocol>


@property (nonatomic, strong) NSString *uid;

//group ID
@property (nonatomic, strong) NSString *gid;

@property (nonatomic, strong) NSString *fid;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *remark;



@end

