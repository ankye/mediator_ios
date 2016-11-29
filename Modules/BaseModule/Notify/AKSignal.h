//
//  KYSignal.h
//  BanLiTV
//
//  Created by ankye on 16/4/20.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AKSIGNAL_KEY_TARGET_ADDRESS @"address"
#define AKSIGNAL_KEY_BLOCK          @"block"

typedef void (^AKSignalBlock)(NSObject* target,NSObject* responseObject);


@interface AKSignal : NSObject




-(void)dispatch:(NSObject*)responseObject;

-(void)addObserver:(NSObject*)target responseBlock:(AKSignalBlock)responseBlock;

-(void)removeObserver:(NSString*)targetAddress;

-(NSString*)getTargetAddress:(NSObject*)target;

@end
