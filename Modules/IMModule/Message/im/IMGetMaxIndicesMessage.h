
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMGetMaxIndicesMessage :IMMessage



-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;



@end
