//
//  AKSignalManager+ThemeModule.h
//  Project
//
//  Created by ankye on 2016/12/27.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKSignalManager.h"

@interface AKSignalManager (ThemeModule)

@property (nonatomic,readwrite) UBSignal<EmptySignal>* onThemeChange;


@end
