
#import "IMRoomGetUIDsMessage.h"


@implementation IMRoomGetUIDsMessage

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
    NSArray * arr = @[@"room.getUIDs",@{@"room_uid":self.room_uid,@"page":@(self.page)},ReqID];
    NSString * str = [arr mj_JSONString];
    
    return [[AKIMManager sharedInstance] sendData:str];
}



-(BOOL)timeout
{
    return NO;
}



@end
