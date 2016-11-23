//
//  AKMediator+UserModule.h
//  Project
//
//  Created by ankye on 2016/11/18.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKMediator (UserModule)

//登陆成功，更新用户信息
-(BOOL)user_loginSuccess:(NSDictionary*)userinfo;

-(BOOL)user_isUserLogin;

@end
