//
//  IMLoginSuccessPush
//  BanLiTV
//
//  Created by ankye on 16/4/5.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "IMSessionSetIsMassModePush.h"



@implementation IMSessionSetIsMassModePush

-(id)init
{
    if(self = [super init]){
        self.messageType = MSG_PUSH;
    }
    return self;
}

-(BOOL)push:(NSArray *)info
{
 
    return YES;
}


@end
