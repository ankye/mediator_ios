
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMSaidPush :IMMessage

@property (assign,nonatomic) NSString* room_uid;


-(BOOL)push:(NSArray*)info;





@end
