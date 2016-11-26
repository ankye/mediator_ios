
#import "IMGetMessage.h"


@implementation IMGetMessage

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
    NSArray * arr = @[@"im.get",@{@"from":self.from_uid,@"startIndex":@(self.startIndex),@"endIndex":@(self.endIndex)},ReqID];
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
