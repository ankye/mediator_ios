//
//  AKMapManager.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKMapManager.h"
#import "MapModuleDefine.h"
#import "AKTimerManager.h"
#import "AKConversation.h"
#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3

@interface AKMapManager()

@property (nonatomic,assign) NSInteger joinRoomStep; //1 request 2 sending 3 complete

@property (nonatomic,assign) NSInteger lastSyncPositionTime;

@end

@implementation AKMapManager 

SINGLETON_IMPL(AKMapManager);


-(id)init
{
    self =[super init];
    if(self){
        [self setupSignals];
        [self configLocationManager];
        self.joinRoomStep = 1;
        self.userOnlinelist = [[NSMutableArray alloc] init];
        self.converstationList = [[NSMutableArray alloc] init];
        [self setupTimer];
        self.lastSyncPositionTime = [AppHelper getCurrentTimestamp];
        
    }
    return self;
}
-(void)setupSignals
{
    
    [AK_SIGNAL_MANAGER.onUserLogin addObserver:self callback:^(typeof(self) self, UserModel *user) {
        
        [self mapLogin];
    }];
    

}

-(void)setupTimer
{
    @weakify(self);
    
    [AK_TIME_MANAGER addTimerWithInterval:5 withUniqueID:@"RoomLoginStateTimer" withRepeatTimes:-1 withTimerFireAction:^(id<AKTimerProtocol> timer) {
        @strongify(self);
        [self joinMapRoom];
    }];
    
    [AK_TIME_MANAGER addTimerWithInterval:10 withUniqueID:@"RoomGetUDsTimer" withRepeatTimes:-1 withTimerFireAction:^(id<AKTimerProtocol> timer) {
        @strongify(self);
        [self reloadFriends];
    }];
    
    
}

-(void)joinMapRoom
{
    if(!self.me){
        return;
    }
    if([[AKIMManager sharedInstance] isConnected]){
        if(self.joinRoomStep <= 1 ){
            self.joinRoomStep = 2;
            @weakify(self);
            [[AKIMManager sharedInstance] roomJoin:AK_MAP_ROOMID withComplete:^(BOOL result, NSArray *response) {
                DDLogInfo(@"用户进房成功 %@",response);
                @strongify(self);
                self.joinRoomStep = 3;
                
                               
            }];
            
        }
    }else{
        self.joinRoomStep = 1;
    }

}

-(void)mapLogin
{
    [AKMapManager sharedInstance].me = [AK_MEDIATOR user_me];
    
    [self addUserToOnlineList:[AKMapManager sharedInstance].me];

    
    self.joinRoomStep = 1;
    [self joinMapRoom];
    [self reloadLocation];
    
}
-(void)dealloc
{
    [AK_SIGNAL_MANAGER.onUserLogin removeObserver:self];
    
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];

  //  [self reloadLocation];
    
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    
//    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
//    
     [self.locationManager startUpdatingLocation];
    

}

-(void)addUserToOnlineList:(UserModel*)user
{

    NSInteger count = [_userOnlinelist count];
    for(NSInteger i=0;i<count;i++){
        if([_userOnlinelist objectAtIndex:i] == user){
            return;
        }
    }
    
    [_userOnlinelist addObject:user];
    
    AK_SIGNAL_MANAGER.onMapAddOnlineUser.fire(user);
    
  
    if(self.me != user){
        
        AKConversation* converstation = [[AKConversation alloc] init];
        converstation.partner = user;
        
        [_converstationList addObject:converstation];
     
        AK_SIGNAL_MANAGER.onMapAddConverstation.fire(converstation);
        
    }
}

-(void)removeUserToOnlineList:(UserModel*)user
{
    [_userOnlinelist removeObject:user];
    AK_SIGNAL_MANAGER.onMapRemoveOnlineUser.fire(user);
    
    NSInteger count = _converstationList.count;
    for(NSInteger i=count -1; i>= 0; i--){
        AKConversation* conversation = [_converstationList objectAtIndex:i];
        if(conversation.partner == user){
            [_converstationList removeObjectAtIndex:i];
            AK_SIGNAL_MANAGER.onMapRemoveConverstation.fire(conversation);
            
            break;
        }
    }
}

-(void)reloadFriends
{
    if(self.me == nil || self.joinRoomStep < 3) return;
    
    @weakify(self);
    [[AKIMManager sharedInstance] roomGetUDs:AK_MAP_ROOMID page:0 withComplete:^(BOOL result, NSArray *response) {
        @strongify(self);
        DDLogInfo(@"GetUDs %@",response);
        if(response && [response count]>=2){
            NSArray* list = (NSArray*)response[1];
            NSInteger count = [list count];
            NSMutableDictionary* currentOnline = [[NSMutableDictionary alloc] init];
            for(NSInteger i=0;i<count ; i++)
            {
                NSMutableDictionary* info = [list objectAtIndex:i];
              
                if(info){
                   
                   UserModel* user = [AK_MEDIATOR user_updateUserInfo:info];
                   [self addUserToOnlineList:user];
                    [currentOnline setObject:user.uid forKey:[user.uid stringValue]];
                }
            }
            count = [_userOnlinelist count];
            for(NSInteger i=count-1; i>=0; i--){
                UserModel* user = [_userOnlinelist objectAtIndex:i];
                if(user && ![currentOnline objectForKey:[user.uid stringValue]]){
                    [self removeUserToOnlineList:user];
                }
            }
            
        }
    }];
    
    
}

-(void)reloadLocation
{
    @weakify(self);
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        
        if (error)
        {
            DDLogError(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            //如果为定位失败的error，则不进行annotation的添加
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
    
        [self amapLocationManager:self.locationManager didUpdateLocation:location reGeocode:regeocode];
        
      
        
    }];

}


#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    DDLogInfo(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    
    //得到定位信息，添加annotation
    if (location)
    {
        if( ! self.me ){
            DDLogWarn(@"User Not Login");
            return ;
        }
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        dic[@"uid"] = self.me.uid;
        dic[@"latitude"] = @(location.coordinate.latitude);
        dic[@"longitude"] = @(location.coordinate.longitude);
        
        [AK_MEDIATOR user_updateUserInfo:dic];
        
        NSInteger time = [AppHelper getCurrentTimestamp] - self.lastSyncPositionTime;
        
        if(_joinRoomStep == 3 && (location.coordinate.latitude != self.me.latitude || location.coordinate.longitude != self.me.longitude || time > 10 )){
            self.lastSyncPositionTime = [AppHelper getCurrentTimestamp];
            
            NSString* msg = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
            DDLogInfo(@"发送同步坐标数据 %@ %@ ",[AppHelper getCurrentTime],msg);
            [[AKIMManager sharedInstance] roomSay:msg isShowDanmu:0 room_uid:AK_MAP_ROOMID];
        }
        
        
    }

    
    
}




@end
