//
//  AKBaseRequest.m
//  Project
//
//  Created by ankye on 2016/11/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKBaseRequest.h"

@implementation AKBaseRequest


- (NSDictionary *)requestHeaderFieldValueDictionary {
    
    return [AK_REQUEST_MANAGER getHttpHeaderField];
}

@end
