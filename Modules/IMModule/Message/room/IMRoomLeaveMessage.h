
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMRoomLeaveMessage :IMMessage

@property (copy,nonatomic) NSString* room_uid;

-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;



@end
