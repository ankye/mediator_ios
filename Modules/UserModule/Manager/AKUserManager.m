//
//  AKUserManager.m
//  Project
//
//  Created by ankye on 2016/11/23.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUserManager.h"
#import "AKUserDetail.h"

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
     
        NSString* uid =dictionary[@"uid"];
        
        AKUser* user = [self getUserInfo:uid];
        [self updateUserInfo:user params:dictionary];
        
    }];
}



-(AKUser*)updateUserInfo:(AKUser*)user params:(NSDictionary*)params
{
    BOOL positionNeedChange = NO;
    BOOL faceNeedChange = NO;
    
    if(user){
        if(params[@"uid"]){
            user.uid = params[@"uid"];
        }
        if(params[@"nickname"]){
            user.nickname = params[@"nickname"];
        }
        if(params[@"longitude"]){
            double longitude = [params[@"longitude"] doubleValue];
            if(longitude != user.detail.longitude ){
                user.detail.longitude  = longitude;
                positionNeedChange = YES;
            }
            
        }
        if(params[@"latitude"]){
            double latitude = [params[@"latitude"] doubleValue];
            if(user.detail.latitude != latitude){
                user.detail.latitude = latitude;
                positionNeedChange = YES;
            }
        }
        if(params[@"head"] ){
            NSString* head = params[@"head"];
            if(![head isEqualToString:user.avatar]){
                user.avatar = head;
                faceNeedChange = YES;
            }
        }
        
        if(params[@"face"] ){
            NSString* head = params[@"face"];
            if(![head isEqualToString:user.avatar]){
                user.avatar = head;
                faceNeedChange = YES;
            }
        }

        
        user.lastLoginTime = @([AppHelper getCurrentTimestamp]);
    }
   
    if(positionNeedChange){
        AK_SIGNAL_MANAGER.onUserPositionChange.fire(user);
    }
    
    if(faceNeedChange){
        AK_SIGNAL_MANAGER.onUserFaceChange.fire(user);
    }
    
    return user;
}

-(AKUser*)getUserInfo:(NSString*)uid
{
    AKUser* user = [AK_DATA_CENTER user_getUserInfo:uid];
    return user;
}


/**
 用户是否已经登录
 
 @return 是否登录
 */
-(BOOL)isUserLogin
{
    if(self.me == nil){
        NSString* uid = [GVUserDefaults standardUserDefaults].uid;
        if(uid){ //本地有存储
            AKUser* user = [AK_DATA_CENTER user_getUserInfo:uid];
            if(user && user.uid != nil){
                
                [self userLogin:user];
            }
        }
    }
    return self.me == nil? NO:YES;
}


/**
 用户登录
 
 @param user AKUser信息
 @return 是否登录成功
 */
-(BOOL)userLogin:(AKUser*)user
{
    [AK_DATA_CENTER user_setUserInfo:user];
  
    [GVUserDefaults standardUserDefaults].uid = user.uid;
    
    [AK_REQUEST_MANAGER updateHttpHeaderField:@"USER-UID" withValue:user.uid];
    [AK_REQUEST_MANAGER updateHttpHeaderField:@"USER-TOKEN" withValue:[GVUserDefaults standardUserDefaults].token];

    self.me = [AK_DATA_CENTER user_getUserInfo:user.uid];
    
    AK_SIGNAL_MANAGER.onUserLogin.fire(self.me);
    
   
    if(self.me == nil){
        return NO;
    }
    return YES;
}



@end
