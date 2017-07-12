//
//  TLUserGroup.h
//  TLChat
//
//  Created by 李伯坤 on 16/1/26.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKUser.h"


@interface AKUserGroup : ALModel

@property (nonatomic, copy) NSString* uid;

//group ID
@property (nonatomic, copy) NSString *gid;

///组名
@property (nonatomic, copy) NSString *name;
//组成员
@property (nonatomic, copy) NSMutableArray *members;


//@property (nonatomic, assign, readonly) NSInteger count;


//- (id) initWithGroupName:(NSString *)name members:(NSMutableArray *)members;
//
//- (void)addMember:(id)anObject;
//
//- (id) memberAtIndex:(NSUInteger)index;


@end
