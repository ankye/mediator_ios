//
//  AKUserGroupMember.h
//  Project
//
//  Created by ankye on 2016/12/15.
//  Copyright © 2016年 ankye. All rights reserved.
//



@interface AKUserGroupMember :ALModel

@property (nonatomic, copy) NSString* uid;

//group ID
@property (nonatomic, copy) NSString *gid;

@property (nonatomic, copy) NSString *fid;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *remark;



@end

