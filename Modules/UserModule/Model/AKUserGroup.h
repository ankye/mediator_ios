//
//  TLUserGroup.h
//  TLChat
//
//  Created by 李伯坤 on 16/1/26.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKUser.h"
#import "AKUserGroup.h"
#import "AKUserGroupProtocol.h"

@interface AKUserGroup : AKBaseModel<AKUserGroupProtocol>

@property (nonatomic, strong) NSString *uid;

//group ID
@property (nonatomic, strong) NSString *gid;

///组名
@property (nonatomic, strong) NSString *name;
//组成员
@property (nonatomic, strong) NSMutableArray *members;


@property (nonatomic, assign, readonly) NSInteger count;

- (id) initWithGroupName:(NSString *)name members:(NSMutableArray *)members;

- (void)addMember:(id)anObject;

- (id) memberAtIndex:(NSUInteger)index;


@end
