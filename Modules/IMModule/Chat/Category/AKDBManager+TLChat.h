//
//  AKDBManager+TLChat.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKDBManager.h"
#import "TLEmojiGroup.h"

@interface AKDBManager (TLChat)


- (BOOL)createExpressionGroupTable;
/**
 *  添加表情包
 */
- (BOOL)addExpressionGroup:(TLEmojiGroup *)group forUid:(NSString *)uid;

/**
 *  查询所有表情包
 */
- (NSArray *)expressionGroupsByUid:(NSString *)uid;

/**
 *  删除表情包
 */
- (BOOL)deleteExpressionGroupByID:(NSString *)gid forUid:(NSString *)uid;

/**
 *  拥有某表情包的用户数
 */
- (NSInteger)countOfUserWhoHasExpressionGroup:(NSString *)gid;



@end
