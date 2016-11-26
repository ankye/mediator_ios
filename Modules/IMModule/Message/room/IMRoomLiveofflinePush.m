
#import "IMRoomLiveofflinePush.h"


static NSString * IMRoomLiveoffline = @"IMRoomLiveoffline";

@implementation IMRoomLiveofflinePush

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_PUSH;
    }
    return self;
}



-(BOOL)push:(NSArray *)info
{
   
    return YES;
}




@end
