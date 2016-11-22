//
//  LoginRequestFactory.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginRequestFactory : NSObject

+(LoginRequestFactory *)sharedInstance;

//请求三方登陆接口
-(BOOL)requestThridLogin:(NSString *)openid withToken:(NSString *)token withType:(NSString *)type;


@end
