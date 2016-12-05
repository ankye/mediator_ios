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
   
    [AK_SIGNAL_MANAGER.onUserInfoChange addObserver:self callback:^(id self, NSDictionary * _Nonnull dictionary) {
     
        NSInteger uid = [dictionary[@"uid"] integerValue];
        
        UserModel* user = [self getUserInfo:@(uid)];
        [self updateUserInfo:user params:dictionary];
        
    }];
}



-(UserModel*)updateUserInfo:(UserModel*)user params:(NSDictionary*)params
{
    BOOL positionNeedChange = NO;
    BOOL faceNeedChange = NO;
    
    if(user){
        if(params[@"nickname"]){
            user.nickname = params[@"nickname"];
        }
        if(params[@"longitude"]){
            double longitude = [params[@"longitude"] doubleValue];
            if(longitude != user.longitude ){
                user.longitude  = longitude;
                positionNeedChange = YES;
            }
            
        }
        if(params[@"latitude"]){
            double latitude = [params[@"latitude"] doubleValue];
            if(user.latitude != latitude){
                user.latitude = latitude;
                positionNeedChange = YES;
            }
        }
        if(params[@"head"] ){
            NSString* head = params[@"head"];
            if(![head isEqualToString:user.head]){
                user.head = head;
                faceNeedChange = YES;
            }
        }
        
        if(params[@"face"] ){
            NSString* head = params[@"face"];
            if(![head isEqualToString:user.head]){
                user.head = head;
                faceNeedChange = YES;
            }
        }

        
        user.last_login_time = [AppHelper getCurrentTime];
    }
   
    if(positionNeedChange){
        AK_SIGNAL_MANAGER.onUserPositionChange.fire(user);
    }
    
    if(faceNeedChange){
        AK_SIGNAL_MANAGER.onUserFaceChange.fire(user);
    }
    
    return user;
}

-(UserModel*)getUserInfo:(NSNumber*)uid
{
    NSString* uidString ;
    if([uid isKindOfClass:[NSString class]]){
        uidString = (NSString*)uid;
    }else{
        uidString = [uid stringValue];
    }
    UserModel* user = [AK_DATA_CENTER user_getUserInfo:uidString];
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
            UserModel* user = [AK_DATA_CENTER user_getUserInfo:[uid stringValue]];
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
  
    [GVUserDefaults standardUserDefaults].uid = user.uid;
    
    [AK_REQUEST_MANAGER updateHttpHeaderField:@"USER-UID" withValue:[user.uid stringValue]];
    [AK_REQUEST_MANAGER updateHttpHeaderField:@"USER-TOKEN" withValue:user.token];

    self.me = [AK_DATA_CENTER user_getUserInfo:[user getKey]];
    

    
    [AK_MEDIATOR im_requestIMToken:self.me.uid withUserToken:self.me.token];
    
    AK_SIGNAL_MANAGER.onUserLogin.fire(self.me);
    
    if(self.me == nil){
        return NO;
    }
    return YES;
}



@end
