//
//  ShareModule.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#ifndef ShareModule_h
#define ShareModule_h

#import <UMSocialCore/UMSocialCore.h>

typedef void(^shareGetUserinfoCompletion)(UMSocialUserInfoResponse* userinfo, NSError *error);



#import "AKMediator+ShareModule.h"

//点击事件回调，点击事件有限，直接通过点击channel来判断需要的逻辑，同一个动画可以支持多个地方的click，共用一个click回调



#endif /* ShareModule_h */
