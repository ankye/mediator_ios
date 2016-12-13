//
//  AKSignalManager+IMModule.m
//  Project
//
//  Created by ankye on 2016/12/7.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKSignalManager+IMModule.h"

@implementation AKSignalManager (IMModule)


GET_SIGNAL_INSTALL(EmptySignal, onIMConnected)

GET_SIGNAL_INSTALL(EmptySignal, onIMDisConnected)

GET_SIGNAL_INSTALL(IMMessageSignal, onIMMessageReceived)

GET_SIGNAL_INSTALL(DictionarySignal, onIMMessagePush)

@end
