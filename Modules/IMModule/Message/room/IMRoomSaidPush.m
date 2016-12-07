
#import "IMRoomSaidPush.h"


@implementation IMRoomSaidPush

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
        NSArray* msgArr = info[1];
        NSString* msg = [NSString stringWithFormat:@"%@-%@-%@",msgArr[0],msgArr[1],msgArr[2]];
        DDLogInfo(@"接收同步数据: %@",msg);
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        dic[@"uid"] = msgArr[1];
        dic[@"nickname"]=msgArr[2];
        
        NSArray* position = [msgArr[0] componentsSeparatedByString:NSLocalizedString(@",", nil)];
        if(position && [position count]>=2){
            dic[@"latitude"] =   [position[0] stringByReplacingOccurrencesOfString:@"**" withString:@"17"];
            dic[@"longitude"] = [position[1] stringByReplacingOccurrencesOfString:@"**" withString:@"17"];;
        }
        AK_SIGNAL_MANAGER.onUserInfoChange.fire(dic);
        

       
    }
    
   return YES;
}

@end
