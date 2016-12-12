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

@implementation Aspect_UserModule

+(void)load
{
    [AK_DB_MANAGER createTableUser];
    [AK_DB_MANAGER createTableUserDetail];
    
}
@end
