
#import "IMRoomLoveMessage.h"



@implementation IMRoomLoveMessage

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
    NSArray * arr = @[@"room.love",@{@"room_uid":self.room_uid},ReqID];
    NSString * str = [arr mj_JSONString];
    
    return [[AKIMManager sharedInstance] sendData:str];
}

-(BOOL)response:(NSArray *)info
{
    return YES;
}


-(BOOL)timeout
{
    return NO;
}



@end
