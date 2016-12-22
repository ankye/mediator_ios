//
//  GVUserDefaults+NewsModule.h
//  Project
//
//  Created by ankye on 2016/12/20.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <GVUserDefaults/GVUserDefaults.h>

@interface GVUserDefaults (NewsModule)

@property (nonatomic, weak) NSMutableArray *hSelectedChannels;
@property (nonatomic, weak) NSMutableArray *hUnSelectedChannels;

@end
