//
//  AKSignalManager+MapModule.m
//  Project
//
//  Created by ankye on 2016/12/2.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKSignalManager+MapModule.h"

@implementation AKSignalManager (MapModule)

GET_SIGNAL_INSTALL(MapUserOnlineSignal, onMapAddOnlineUser);

GET_SIGNAL_INSTALL(MapUserOnlineSignal, onMapRemoveOnlineUser);

GET_SIGNAL_INSTALL(MapUserConverstationSignal, onMapAddConverstation);

GET_SIGNAL_INSTALL(MapUserConverstationSignal, onMapRemoveConverstation);

@end
