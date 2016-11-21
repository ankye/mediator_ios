//
//  AKCYLPlusButton.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//
#import "BaseModuleDefine.h"

@interface AKCYLPlusButton : CYLPlusButton


-(void)setAttributes:(NSDictionary*)attributes;

-(NSDictionary*)getAttributes;

+ (instancetype)defaultInstance;


@end
