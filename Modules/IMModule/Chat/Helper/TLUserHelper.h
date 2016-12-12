//
//  TLUserHelper.h
//  TLChat
//
//  Created by 李伯坤 on 16/2/6.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKUser.h"

@interface TLUserHelper : NSObject

@property (nonatomic, strong) AKUser *user;

@property (nonatomic, strong, readonly) NSString *userID;

+ (TLUserHelper *) sharedHelper;

-(void)setUserModel:(AKUser*)model;


@end
