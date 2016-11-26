
#import <Foundation/Foundation.h>
#import "IMMessage.h"
static NSString * IMRoomRenqiChange;

@interface IMRoomRenqiChangePush :IMMessage

-(BOOL)push:(NSArray*)info;

@end
