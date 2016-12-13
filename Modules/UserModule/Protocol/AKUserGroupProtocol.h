//
//  AKUserGroupProtocol.h
//  Project
//
//  Created by ankye on 2016/12/13.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AKUserGroupProtocol <NSObject>


/// 用户ID
@property (nonatomic, strong) NSString *uid;

//group ID
@property (nonatomic, strong) NSString *gid;

///组名
@property (nonatomic, strong) NSString *name;
//组成员
@property (nonatomic, strong) NSMutableArray *members;



@end
