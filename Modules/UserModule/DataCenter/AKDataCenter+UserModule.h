//
//  AKDataCenter+UserModule.h
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface AKDataCenter (UserModule)

-(void)setUserInfo:(UserModel*)user;

-(UserModel*)getUserInfo:(NSString*)uid;


@end
