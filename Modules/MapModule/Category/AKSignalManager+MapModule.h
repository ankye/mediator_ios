//
//  AKSignalManager+MapModule.h
//  Project
//
//  Created by ankye on 2016/12/2.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKSignalManager.h"
#import "AKConversation.h"

CreateSignalType(MapUserOnline, AKUser *user)
CreateSignalType(MapUserConverstation, AKConversation* conversation)

@interface AKSignalManager (MapModule)


@property (nonatomic, readwrite) UBSignal<MapUserOnlineSignal> *onMapAddOnlineUser;
@property (nonatomic, readwrite) UBSignal<MapUserOnlineSignal> *onMapRemoveOnlineUser;

@property (nonatomic, readwrite) UBSignal<MapUserConverstationSignal> *onMapAddConverstation;
@property (nonatomic, readwrite) UBSignal<MapUserConverstationSignal> *onMapRemoveConverstation;


@end
