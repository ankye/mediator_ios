

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
    
   
    return YES;
}





@end
