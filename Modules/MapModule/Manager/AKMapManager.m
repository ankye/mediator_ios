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
#import "TLConversation.h"
#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3

@interface AKMapManager()

@property (nonatomic,assign) NSInteger joinRoomStep; //1 request 2 sending 3 complete



@end

@implementation AKMapManager 

SINGLETON_IMPL(AKMapManager);


-(id)init
{
    self =[super init];
    if(self){
        [self configLocationManager];
        self.joinRoomStep = 1;
        self.userlist = [[NSMutableArray alloc] init];
        self.friendList = [[NSMutableArray alloc] init];
    }
    return self;
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
    
    //进行单次定位请求
    @weakify(self);
//    [[AKTimerManager sharedInstance] addTimerWithInterval:20 withUniqueID:@"LocationReloadTimer" withRepeatTimes:-1 withTimerFireAction:^(id<AKTimerProtocol> timer) {
//        @strongify(self);
//        [self reloadLocation];
//    }];
    
    [[AKTimerManager sharedInstance] addTimerWithInterval:5 withUniqueID:@"RoomLoginStateTimer" withRepeatTimes:-1 withTimerFireAction:^(id<AKTimerProtocol> timer) {
        @strongify(self);
        if([[AKIMManager sharedInstance] isConnected]){
            if(self.joinRoomStep <= 1 ){
                self.joinRoomStep = 2;
                [[AKIMManager sharedInstance] roomJoin:AK_MAP_ROOMID withComplete:^(BOOL result, NSArray *response) {
                    NSLog(@"用户进房成功 %@",response);
                    self.joinRoomStep = 3;
                }];
                
            }
        }else{
            self.joinRoomStep = 1;
        }
    }];
    
    [[AKTimerManager sharedInstance] addTimerWithInterval:10 withUniqueID:@"RoomGetUDsTimer" withRepeatTimes:-1 withTimerFireAction:^(id<AKTimerProtocol> timer) {
        @strongify(self);
        [self reloadFriends];
    }];
}

-(void)addUserToList:(UserModel*)user
{

    NSInteger count = [_userlist count];
    for(NSInteger i=0;i<count;i++){
        if([_userlist objectAtIndex:i] == user){
            return;
        }
    }
   // [_userlist addObject:user];
    [self addUser:user];
    
    if(self.me != user){
        
        TLConversation* converstation = [[TLConversation alloc] init];
        converstation.partner = user;
        
        [self addFriend:converstation];
     
    }
}

-(void)reloadFriends
{
    @weakify(self);
    [[AKIMManager sharedInstance] roomGetUDs:AK_MAP_ROOMID page:0 withComplete:^(BOOL result, NSArray *response) {
        @strongify(self);
        NSLog(@"GetUDs %@",response);
        if(response && [response count]>=2){
            NSArray* list = (NSArray*)response[1];
            NSInteger count = [list count];
            for(NSInteger i=0;i<count ; i++)
            {
                NSDictionary* info = [list objectAtIndex:i];
                if(info){
                    NSInteger uid = [info[@"uid"] integerValue];
                    
                    UserModel* user = [[AKMediator sharedInstance] user_getUserInfo:@(uid)];
            
                    user.head = info[@"face"];
                    user.uid = @(uid);
                    user.nickname = info[@"nickname"];
                    
                    [self addUserToList:user];
                    
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
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
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
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    
    //得到定位信息，添加annotation
    if (location)
    {
        if( ! [[AKMediator sharedInstance] user_isUserLogin]){
            NSLog(@"User Not Login");
            return ;
        }
        if(self.me == nil){
            self.me = [[AKMediator sharedInstance] user_me];
             [self reloadFriends];
        }
        if(self.me.latitude != location.coordinate.latitude || self.me.longitude != location.coordinate.latitude){
          
       
            self.me.latitude = location.coordinate.latitude;
            self.me.longitude = location.coordinate.longitude;
            if(_joinRoomStep == 3){
                NSString* msg = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
                NSLog(@"发送同步坐标数据 %@ %@ 116464 11383838",[AppHelper getCurrentTime],msg);
                [[AKIMManager sharedInstance] roomSay:msg isShowDanmu:0 room_uid:AK_MAP_ROOMID];
               
            }
        }
    }

    
    
}





- (NSMutableArray *)userArray {
    return [self mutableArrayValueForKey:NSStringFromSelector(@selector(userlist))];
}

- (void)addUser:(UserModel *)user {
    [[self userArray] addObject:user];
}

- (NSMutableArray *)friendArray {
    return [self mutableArrayValueForKey:NSStringFromSelector(@selector(friendList))];
}

- (void)addFriend:(TLConversation *)user {

   
    [[self friendArray] addObject:user];

}

@end
