//
//  Aspect-IMModule.m
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "Aspect-IMModule.h"
#import "AKDBManager+TLChat.h"
@implementation Aspect_IMModule

+(void)load
{
    [AK_DB_MANAGER createConversationTable];
    [AK_DB_MANAGER createChatMessageTable];
    [AK_DB_MANAGER createExpressionGroupTable];
    [AK_DB_MANAGER createGroupTable];
    
}
@end
