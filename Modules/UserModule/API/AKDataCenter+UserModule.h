//
//  AKDataCenter+UserModule.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKUser.h"

@interface AKDataCenter (UserModule)

-(void)user_setUserInfo:(AKUser*)user;

-(AKUser*)user_getUserInfo:(NSString*)uid;


@end
