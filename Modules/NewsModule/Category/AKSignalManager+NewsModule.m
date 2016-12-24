//
//  AKSignalManager+NewsModule.m
//  Project
//
//  Created by ankye on 2016/12/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKSignalManager+NewsModule.h"

@implementation AKSignalManager (NewsModule)

GET_SIGNAL_INSTALL(MutableArraySignal, onNewsSelectedChannelChange);
GET_SIGNAL_INSTALL(MutableArraySignal, onNewsUnSelectedChannelChange);

@end
