//
//  AKBookDetailAPI.h
//  Project
//
//  Created by ankye on 2017/1/18.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKBaseRequest.h"

@interface AKBookDetailAPI : AKBaseRequest

-(instancetype) initWithNovelID:(NSString* )novelID withSiteID:(NSString*)siteID;


@end
