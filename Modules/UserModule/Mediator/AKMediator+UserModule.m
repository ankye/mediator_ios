//
//  AKMediator+UserModule.m
//  Project
//
//  Created by ankye on 2016/11/18.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKMediator+UserModule.h"

NSString * const kAKMUserModuleService = @"User";
NSString * const kAKMUserLoginSuccess = @"loginSuccess";


@implementation AKMediator (UserModule)

-(BOOL)user_loginSuccess:(NSDictionary*)response
{
   NSNumber* result = [self performService:kAKMUserModuleService action:kAKMUserLoginSuccess params:response shouldCacheService:NO];
    if(result != 0){
        return NO;
    }
    return YES;
}

@end
