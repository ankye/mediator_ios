//
//  GVUserDefaults+UserModule.h
//  Project
//
//  Created by ankye on 2016/11/25.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GVUserDefaults/GVUserDefaults.h>
@interface GVUserDefaults (UserModule)

@property (nonatomic, weak) NSString *uid;
@property (nonatomic, weak) NSString *token;

@end
