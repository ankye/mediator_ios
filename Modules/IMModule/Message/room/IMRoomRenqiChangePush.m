
#import "IMRoomRenqiChangePush.h"

static NSString * IMRoomRenqiChange = @"IMRoomRenqiChange";

@implementation IMRoomRenqiChangePush

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_PUSH;
    }
    return self;
}



-(BOOL)push:(NSArray *)info
{
    NSNumber * peopleNum = info[1];
    if (peopleNum) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IMRoomRenqiChange object:nil
                                                          userInfo:@{
                                                                     @"onlineNum":peopleNum.stringValue                                                  }];
    }
    return YES;
}



@end
