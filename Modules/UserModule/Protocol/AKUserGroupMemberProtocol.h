//
//  AKUserGroupProtocol.h
//  Project
//
//  Created by ankye on 2016/12/13.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AKUserGroupMemberProtocol <NSObject>


@property (nonatomic, strong) NSString *uid;

//group ID
@property (nonatomic, strong) NSString *gid;

@property (nonatomic, strong) NSString *fid;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *remark;


@end
