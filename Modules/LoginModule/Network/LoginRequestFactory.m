//
//  LoginRequestFactory.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "LoginRequestFactory.h"

@implementation LoginRequestFactory

#pragma mark - Initialization Methods
+(LoginRequestFactory*)sharedInstance
{
    static LoginRequestFactory *_sharedInstance  = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
        _sharedInstance = [[LoginRequestFactory alloc]init];
    });
    return _sharedInstance;
}

-(BOOL)requestThridLogin:(NSString *)openid withToken:(NSString *)token withType:(NSString *)type
{
    
    return YES;
}


@end
