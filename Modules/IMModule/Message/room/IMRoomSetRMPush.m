
#import "IMRoomSetRMPush.h"


static NSString * IMRoomSetRM = @"IMRoomSetRM";
@implementation IMRoomSetRMPush

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
