//
//  AKNewsContentList.h
//  Project
//
//  Created by ankye on 2016/12/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKBaseRequest.h"

@interface AKNewsContentListAPI : AKBaseRequest

-(instancetype) initWithChannel:(NSString *)cid withPageSize:(NSInteger )pagesize andSendTime:(double)sendTime;

@end
