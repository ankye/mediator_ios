//
//  TLMessageManager.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/13.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLMessageManager.h"
#import "TLMessageManager+ConversationRecord.h"
#import "TLConversation.h"
#import "TLMessage.h"
#import "TLTextMessage.h"
#import "TLUser+ChatModel.h"


static TLMessageManager *messageManager;

@implementation TLMessageManager

+ (TLMessageManager *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        messageManager = [[TLMessageManager alloc] init];
    });
    return messageManager;
}

-(id)init
{
    self = [super init];
    if(self){
        [self setupSignals];
    }
    return self;
}

-(void)setupSignals
{
  
    [AK_SIGNAL_MANAGER.onIMConnected addObserver:self callback:^(id  _Nonnull self) {
        UserModel* me = [AK_MEDIATOR user_me];
        if(me){
            [[TLUserHelper sharedHelper] setUserModel:me];
        }
        [self getIMUnreadMessages];
    }];
    
    [AK_SIGNAL_MANAGER.onIMMessagePush addObserver:self callback:^(id  _Nonnull self, NSDictionary * _Nonnull dictionary) {
        [self processMessage:dictionary showTips:YES];
    }];
    
    
}

-(void)processMessage:(NSDictionary*)info showTips:(BOOL)showTips
{
    UserModel* me = [AK_MEDIATOR user_me];
    NSString* myUid = [me.uid stringValue];
    NSInteger fid = [info[@"uid"] integerValue];
    UserModel* friend = [AK_MEDIATOR user_getUserInfo:@(fid)];
    TLUser* user = [TLUserHelper userModelToTLUser:friend];
    
    TLTextMessage* message = (TLTextMessage*)[TLMessage createMessageByType:TLMessageTypeText];
   
    message.text = info[@"content"];
    message.messageID = [info[@"index"] stringValue];
    message.date = [AppHelper getDateFromMSTime:[info[@"createAt"] doubleValue]];
    message.friendID = info[@"uid"];
    
    message.userID = myUid;
    message.fromUser = user;
    message.partnerType = TLPartnerTypeUser;
    message.ownerTyper = TLMessageOwnerTypeFriend;
    
    [AK_DB_MANAGER addMessage:message];
    
    AK_SIGNAL_MANAGER.onIMMessageReceived.fire(message);
    if(showTips && user && ![AppHelper isNullString:[user chat_username]]){
        [AK_POPUP_MANAGER showTips:[NSString stringWithFormat:@"%@给你发了一条消息",[user chat_username]]];
    }
}

-(void)getIMUnreadMessages
{
    [[AKIMManager sharedInstance] imGetUnreadList:^(BOOL result, NSArray *response) {
        
        UserModel* me = [AK_MEDIATOR user_me];
        NSString* myUid = [me.uid stringValue];
        NSDictionary* info = response[1];
   
        NSArray* keys = info.allKeys;
        for(NSInteger i=0; i< keys.count; i++){
            NSString* fid = [keys objectAtIndex:i];
            NSDictionary* unreadDic = [info objectForKey:fid];
            NSInteger startIndex = 1;
            
            TLConversation* conv = [AK_DB_MANAGER conversationMessageByUid:myUid fid:fid];
            NSDictionary* lastMessage = unreadDic[@"last_message"];
            if(conv){
                conv.unreadCount += [unreadDic[@"num"] integerValue];
                startIndex = conv.maxIndex;
                conv.maxIndex = [lastMessage[@"index"] integerValue];
                if(conv.maxIndex < startIndex){
                    conv.maxIndex = startIndex;
                }
            }else{
                conv = [[TLConversation alloc] init];
                conv.partnerID = fid;
                conv.unreadCount = [unreadDic[@"num"] integerValue];
                conv.maxIndex = [lastMessage[@"index"] integerValue];

            }
            
            
            conv.content = lastMessage[@"content"];
            conv.date = [AppHelper getDateFromMSTime: [lastMessage[@"createAt"] doubleValue]];
            conv.convType = TLConversationTypePersonal;
            
            [AK_DB_MANAGER updateConversation:myUid withConversation:conv];
            
            [[AKIMManager sharedInstance] imGet:fid startIndex:(int)startIndex endIndex:(int)conv.maxIndex withComplete:^(BOOL result, NSArray *response) {
                
                NSDictionary* msgsDic = response[1];
                if(![msgsDic objectForKey:@"code"]) {
                    NSArray* msgKeys = msgsDic.allKeys;
                    NSInteger count = [msgKeys count];
                    for(NSInteger i=0; i<count; i++)
                    {
                        NSString* key = [msgKeys objectAtIndex:i];
                        NSDictionary* msgDic = [msgsDic objectForKey:key];
                        [self processMessage:msgDic showTips:NO];
                        
                    }
                }
            }];
            
        }
    }];
}

- (void)sendMessage:(TLMessage *)message
           progress:(void (^)(TLMessage *, CGFloat))progress
            success:(void (^)(TLMessage *))success
            failure:(void (^)(TLMessage *))failure
{
    BOOL ok = [AK_DB_MANAGER addMessage:message];
    if (!ok) {
        DDLogError(@"存储Message到DB失败");
    }
    else {      // 存储到conversation
        ok = [self addConversationByMessage:message];
        if (!ok) {
            DDLogError(@"存储Conversation到DB失败");
        }
    }
    NSString* text  = ((TLTextMessage*)message).text;
    
    [[AKIMManager sharedInstance] imSay:message.friendID content:text withComplete:^(BOOL result, NSArray *response) {
        NSLog(@"send success");
        NSDictionary* reason = response[1];
        if([reason[@"code"] integerValue] == 0){
            
        }else{
            [AK_POPUP_MANAGER showErrorTips:reason[@"name"]];
            message.sendState = TLMessageSendFail;
            BOOL ok = [AK_DB_MANAGER addMessage:message];
            if (!ok) {
                DDLogError(@"存储Message到DB失败");
            }
        }
    }];
}

-(void)dealloc
{
  
    [AK_SIGNAL_MANAGER.onIMConnected removeObserver:self];
    
    [AK_SIGNAL_MANAGER.onIMMessagePush removeObserver:self];
}

- (NSString *)userID
{
    return [TLUserHelper sharedHelper].userID;
}

@end
