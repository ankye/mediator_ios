//
//  TLMessageManager+MessageRecord.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/20.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLMessageManager+MessageRecord.h"
#import "TLChatViewController.h"

@implementation TLMessageManager (MessageRecord)

- (void)messageRecordForPartner:(NSString *)partnerID
                       fromDate:(NSDate *)date
                          count:(NSUInteger)count
                       complete:(void (^)(NSArray *, BOOL))complete
{
    [AK_DB_MANAGER messagesByUserID:self.userID partnerID:partnerID fromDate:date count:count complete:^(NSArray *data, BOOL hasMore) {
        complete(data, hasMore);
    }];
}

- (void)chatFilesForPartnerID:(NSString *)partnerID
                    completed:(void (^)(NSArray *))completed
{
    NSArray *data = [AK_DB_MANAGER chatFilesByUserID:self.userID partnerID:partnerID];
    completed(data);
}

- (void)chatImagesAndVideosForPartnerID:(NSString *)partnerID
                              completed:(void (^)(NSArray *))completed

{
    NSArray *data = [AK_DB_MANAGER chatImagesAndVideosByUserID:self.userID partnerID:partnerID];
    completed(data);
}

- (BOOL)deleteMessageByMsgID:(NSString *)msgID
{
    return [AK_DB_MANAGER deleteMessageByMessageID:msgID];
}

- (BOOL)deleteMessagesByPartnerID:(NSString *)partnerID
{
    BOOL ok = [AK_DB_MANAGER deleteMessagesByUserID:self.userID partnerID:partnerID];
    if (ok) {
        [[TLChatViewController sharedInstance] resetChatVC];
    }
    return ok;
}

- (BOOL)deleteAllMessages
{
    BOOL ok = [AK_DB_MANAGER deleteMessagesByUserID:self.userID];
    if (ok) {
        [[TLChatViewController sharedInstance] resetChatVC];
        ok = [AK_DB_MANAGER deleteConversationsByUid:self.userID];
    }
    return ok;
}

@end
