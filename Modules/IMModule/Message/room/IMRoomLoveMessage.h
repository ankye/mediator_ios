
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMRoomLoveMessage :IMMessage

@property (assign,nonatomic) NSString* room_uid;

-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;



@end
