
#import <Foundation/Foundation.h>
#import "IMMessage.h"

@interface IMRoomSayMessage :IMMessage

@property (assign,nonatomic) NSString* room_uid;
@property (assign,nonatomic) NSString* content;
@property (assign,nonatomic) int       isShowDanmu;

-(BOOL)request;
-(BOOL)response:(NSArray*)info;


-(BOOL)timeout;

@end
