

#import "IMSayMessage.h"


@implementation IMSayMessage

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
    NSArray * arr = @[@"im.say",@{@"to":self.to_uid,@"content":self.content},ReqID];
    NSString * str = [arr mj_JSONString];
    
    return [[AKIMManager sharedInstance] sendData:str];
}



-(BOOL)timeout
{
      return NO;
}



@end
