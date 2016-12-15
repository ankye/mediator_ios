//
//  Aspect+UserModule.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "Aspect+UserModule.h"
#import "AKDBManager+User.h"
#import "AKDBManager+UserDetail.h"
#import "AKDBManager+UserGroup.h"

@implementation Aspect_UserModule

+(void)load
{
    [AK_DB_MANAGER user_createTable];
    [AK_DB_MANAGER user_detail_createTable];
    [AK_DB_MANAGER user_group_createTable];
    
}
@end
