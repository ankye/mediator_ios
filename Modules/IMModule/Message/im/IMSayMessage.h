
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMSayMessage :IMMessage

@property (assign,nonatomic) NSString* to_uid;
@property (assign,nonatomic) NSString* content;

-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;



@end
