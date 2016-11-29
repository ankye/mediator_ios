
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMRoomGetUIDsMessage :IMMessage

@property (assign,nonatomic) NSString* room_uid;
@property (assign,nonatomic) int        page;

-(BOOL)request;

-(BOOL)timeout;



@end
