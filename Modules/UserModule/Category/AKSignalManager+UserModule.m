//
//  AKSignalManager+UserModule.m
//  Project
//
//  Created by ankye on 2016/12/2.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKSignalManager+UserModule.h"


@implementation AKSignalManager (UserModule)


GET_SIGNAL_INSTALL(UserPositionSignal, onUserPositionChange)

GET_SIGNAL_INSTALL(DictionarySignal, onUserInfoChange)

GET_SIGNAL_INSTALL(UserSignal, onUserLogin)

GET_SIGNAL_INSTALL(UserSignal, onUserLogout)

GET_SIGNAL_INSTALL(UserSignal, onUserFaceChange)

@end
