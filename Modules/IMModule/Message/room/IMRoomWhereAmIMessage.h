
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMRoomWhereAmIMessage :IMMessage


-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;



@end
