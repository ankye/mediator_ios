//
//  AKMediator+ShareModule.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKMediator (ShareModule)


- (void)share_getUserInfoForPlatform:(UMSocialPlatformType) platformType withController:(UIViewController*)controller withCompletion:(shareGetUserinfoCompletion)completion;

@end
