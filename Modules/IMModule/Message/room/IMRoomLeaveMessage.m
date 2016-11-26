
#import "IMRoomLeaveMessage.h"



@implementation IMRoomLeaveMessage

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
    NSArray * arr = @[@"room.leave",@{@"room_uid":self.room_uid},ReqID];
    NSString * str = [arr mj_JSONString];
    
    return [[AKIMManager sharedInstance] sendData:str];
}

-(BOOL)response:(NSArray *)info
{
    return YES;
}


-(BOOL)timeout
{
    if (![AppHelper isNullString:self.room_uid]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RoomLeaveTimeOut" object:nil userInfo:@{@"roomId":self.room_uid}];
    }
    return NO;
}



@end
