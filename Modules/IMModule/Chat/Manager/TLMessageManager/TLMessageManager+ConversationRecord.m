//
//  TLMessageManager+ConversationRecord.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/20.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLMessageManager+ConversationRecord.h"
#import "TLMessageManager+MessageRecord.h"

@implementation TLMessageManager (ConversationRecord)

- (BOOL)addConversationByMessage:(TLMessage *)message
{
    NSString *partnerID = message.friendID;
    NSInteger type = 0;
    if (message.partnerType == TLPartnerTypeGroup) {
        partnerID = message.groupID;
        type = 1;
    }
    BOOL ok = [AK_DB_MANAGER addConversationByUid:message.userID fid:partnerID type:type date:message.date];
    
    return ok;
}

- (void)conversationRecord:(void (^)(NSArray *))complete
{
    NSArray *data = [AK_DB_MANAGER conversationsByUid:self.userID];
    complete(data);
}

- (BOOL)deleteConversationByPartnerID:(NSString *)partnerID
{
    BOOL ok = [self deleteMessagesByPartnerID:partnerID];
    if (ok) {
        ok = [AK_DB_MANAGER deleteConversationByUid:self.userID fid:partnerID];
    }
    return ok;
}

@end
