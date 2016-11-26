
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMGetMessage :IMMessage

@property (assign,nonatomic) NSString* from_uid;
@property (assign,nonatomic) int startIndex;
@property (assign,nonatomic) int endIndex;

-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;



@end
