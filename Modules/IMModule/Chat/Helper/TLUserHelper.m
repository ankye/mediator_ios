//
//  TLUserHelper.m
//  TLChat
//
//  Created by 李伯坤 on 16/2/6.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLUserHelper.h"

static TLUserHelper *helper;

@implementation TLUserHelper

+ (TLUserHelper *) sharedHelper
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[TLUserHelper alloc] init];
    });
    return helper;
}

- (NSString *)userID
{
    return self.user.userID;
}

- (id) init
{
    if (self = [super init]) {
        
       
    }
    return self;
}


-(void)setUserModel:(AKUser*)model
{
    self.user = [TLUserHelper userModelToTLUser:model];
 
}




@end
