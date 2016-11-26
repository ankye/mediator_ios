
#import "IMRoomSayMessage.h"



@implementation IMRoomSayMessage

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_REQUEST;
    }
    return self;
}

-(BOOL)request
{
    NSString* ReqID = [NSString stringWithFormat:@"%d",[self getRequestID]];
    NSArray * arr;
    
    
    arr = @[@"room.say",@[self.content,@(self.isShowDanmu),self.room_uid],ReqID];
    
    NSString * str = [arr mj_JSONString];
    
    return [[AKIMManager sharedInstance] sendData:str];
}

-(BOOL)response:(NSArray *)info
{
    //TODO:通知错误消息
    NSLog(@"message___response:%@",info);
 
    
    return YES;
}


-(BOOL)timeout
{
    return NO;
}

@end
