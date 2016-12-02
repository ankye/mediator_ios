//
//  AKUserManager.m
//  Project
//
//  Created by ankye on 2016/11/23.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUserManager.h"

@implementation AKUserManager


#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static AKUserManager *_userManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userManager = [[AKUserManager alloc] init];
    });
    return _userManager;
}

-(id)init
{
    self = [super init];
    if(self){
     
        [self setupNotify];
    }
    return self;
}


-(void)setupNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserPosition:) name:@"UserPositionUpdate" object:nil];
}

-(void)changeUserPosition:(NSNotification*)notify
{
    NSDictionary* dic = (NSDictionary*)notify.object;
    if(dic){
        
        UserModel* user = [AK_DATA_CENTER user_getUserInfo:dic[@"uid"]];
        if(user && user != self.me){
            [self updateUserInfo:user params:dic];
        }
    }
}

-(void)updateUserInfo:(UserModel*)user params:(NSDictionary*)params
{
    user.nickname = params[@"nickname"];
    user.longitude = [params[@"longitude"] doubleValue];
    user.latitude = [params[@"latitude"] doubleValue];
    user.last_login_time = [AppHelper getCurrentTime];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserSendPositionUpdate" object:params];
    
}

-(UserModel*)getUserInfo:(NSNumber*)uid
{
    UserModel* user = [AK_DATA_CENTER user_getUserInfo:[uid stringValue]];
    return user;
}
/**
 用户是否已经登录
 
 @return 是否登录
 */
-(BOOL)isUserLogin
{
    if(self.me == nil){
        NSNumber* uid = [GVUserDefaults standardUserDefaults].uid;
        if(uid){ //本地有存储
            UserModel* user = [AK_DB_MANAGER queryUserByUid:[uid integerValue]];
            if(user){
                [self userLogin:user];
            }
        }
    }
    return self.me == nil? NO:YES;
}


/**
 用户登录
 
 @param user UserModel信息
 @return 是否登录成功
 */
-(BOOL)userLogin:(UserModel*)user
{
    [AK_DATA_CENTER user_setUserInfo:user];
  
    
    [AK_REQUEST_MANAGER updateHttpHeaderField:@"USER-UID" withValue:[user.uid stringValue]];
    [AK_REQUEST_MANAGER updateHttpHeaderField:@"USER-TOKEN" withValue:user.token];

    self.me = [AK_DATA_CENTER user_getUserInfo:[user getKey]];
    

    
    [AK_MEDIATOR im_requestIMToken:self.me.uid withUserToken:self.me.token];
    
    if(self.me == nil){
        return NO;
    }
    return YES;
}



@end
