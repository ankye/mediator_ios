//
//  Aspect+UserModule.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "Aspect+UserModule.h"
#import "AKDBManager+UserModel.h"

@implementation Aspect_UserModule

+(void)load
{
    if( ![AK_DB_MANAGER isExistUserTable]){
        [AK_DB_MANAGER createUserTable];
    }
}
@end
