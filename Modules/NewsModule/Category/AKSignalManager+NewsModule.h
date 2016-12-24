//
//  AKSignalManager+NewsModule.h
//  Project
//
//  Created by ankye on 2016/12/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKSignalManager.h"

@interface AKSignalManager (NewsModule)

@property (nonatomic, readwrite) UBSignal<MutableArraySignal> *onNewsSelectedChannelChange;
@property (nonatomic, readwrite) UBSignal<MutableArraySignal> *onNewsUnSelectedChannelChange;


@end
