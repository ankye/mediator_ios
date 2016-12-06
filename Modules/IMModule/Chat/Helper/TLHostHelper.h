//
//  TLHostHelper.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLChatMacros.h"

@interface TLHostHelper : NSObject

+ (NSString *)clientInitInfoURL;

#pragma mark - Mine

+ (NSString *)expressionURLWithEid:(NSString *)eid;

+ (NSString *)expressionDownloadURLWithEid:(NSString *)eid;

@end

