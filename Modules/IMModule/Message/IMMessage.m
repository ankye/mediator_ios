//
//  IMMessage.m
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMMessage.h"


@interface IMMessage ()
{
    int _requestID;
}

@end

@implementation IMMessage


-(id)init
{
    if(self = [super init])
    {
        _requestID = -1;
        _messageType = MSG_REQUEST;
        
    }
    return self;
}

-(void)setRequestID:(int)seqID
{
    _requestID = seqID;
    
}
-(int) getRequestID
{
    return _requestID;
}

-(BOOL)response:(NSArray *)info
{
    if(self.complete){
        self.complete(YES,info);
    }
    return YES;
}

-(BOOL)timeout
{
    if(self.complete){
        self.complete(NO,nil);
    }
    return YES;
}


-(IMMessageType)getMessageType
{
    return _messageType;
}
@end
