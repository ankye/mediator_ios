//
//  ServiceUser.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceUser : NSObject

/**
 用户是否已经登录
 
 @return 是否登录
 */
-(NSNumber*)isUserLogin;


//登陆成功处理逻辑
-(NSNumber*)loginSuccess:(NSDictionary *)params;



@end
