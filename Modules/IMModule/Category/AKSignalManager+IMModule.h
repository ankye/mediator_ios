//
//  AKSignalManager+IMModule.h
//  Project
//
//  Created by ankye on 2016/12/7.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKSignalManager.h"
#import "TLMessage.h"

CreateSignalType(IMMessage, TLMessage* message)

@interface AKSignalManager (IMModule)

@property (nonatomic,readwrite) UBSignal<EmptySignal>* onIMConnected;

@property (nonatomic,readwrite) UBSignal<EmptySignal>* onIMDisConnected;

//服务器推送消息到了
@property (nonatomic,readwrite) UBSignal<DictionarySignal>* onIMMessagePush;
//消息收到通知
@property (nonatomic,readwrite) UBSignal<IMMessageSignal>* onIMMessageReceived;


@end
