//
//  AKIMServerListRequest.m
//  Project
//
//  Created by ankye on 2016/11/26.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKIMServerListRequest.h"

@implementation AKIMServerListRequest



-(NSString *)baseUrl
{
    return G_IM_SERVER_LIST_URL;
}

-(YTKRequestMethod) requestMethod
{
    return YTKRequestMethodGET;
}




@end
