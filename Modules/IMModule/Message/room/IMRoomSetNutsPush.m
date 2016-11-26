
#import "IMRoomSetNutsPush.h"


static NSString * IMRoomSetNuts = @"IMRoomSetNuts";

@implementation IMRoomSetNutsPush

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_PUSH;
    }
    return self;
}

-(BOOL)push:(NSArray *)info
{
    NSDictionary * dic = info[1];
    if (dic) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IMRoomSetNuts object:nil
                                                          userInfo:dic];
    }
    return YES;
}





@end
