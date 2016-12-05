//
//  AKSignalManager+UserModule.h
//  Project
//
//  Created by ankye on 2016/12/2.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKSignalManager.h"

CreateSignalType(UserPosition, UserModel *user)
CreateSignalType(User, UserModel *user)


@interface AKSignalManager (UserModule)

//用户位置变更通知
@property (nonatomic, readwrite) UBSignal<UserPositionSignal> *onUserPositionChange;

//用户信息变更
@property (nonatomic, readwrite) UBSignal<DictionarySignal> *onUserInfoChange;
//用户登录成功通知
@property (nonatomic, readwrite) UBSignal<UserSignal> *onUserLogin;
//用户退出登录通知
@property (nonatomic, readwrite) UBSignal<UserSignal> *onUserLogout;

@property (nonatomic, readwrite) UBSignal<UserSignal> *onUserFaceChange;

@end
