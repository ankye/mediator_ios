//
//  AKNewsChannel.h
//  Project
//
//  Created by ankye on 2016/12/22.
//  Copyright © 2016年 ankye. All rights reserved.
//


@interface AKNewsChannel : ALModel

-(id)initWithChannel:(NSString*)cid withName:(NSString*)name withFixed:(BOOL)fixed;

@property (strong, nonatomic) NSString *  cid;
@property (strong, nonatomic) NSString *  name;
//是否固定在顶部
@property (assign, nonatomic) BOOL   fixed;

@end
