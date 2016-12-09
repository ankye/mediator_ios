

#import "IMSaidPush.h"



@implementation IMSaidPush

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_PUSH;
    }
    return self;
}

-(BOOL)push:(NSArray *)info
{
    
    if(info && [info count]>=2){
        
        NSDictionary* msg = info[1];
        AK_SIGNAL_MANAGER.onIMMessagePush.fire(msg);
        
        
    }

    return YES;
}





@end
