
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMRoomGetUDsMessage :IMMessage

@property (copy,nonatomic) NSString* room_uid;
@property (assign,nonatomic) int        page;

-(BOOL)request;


-(BOOL)timeout;



@end
