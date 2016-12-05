//
//  AKMapViewController.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKMapViewController.h"
#import "AKUserPointAnnotation.h"
#import "AKUserPinAnnotationView.h"
#import "AKMapManager.h"
#import "HBLocationButton.h"
#import "HBBaseRoundButton.h"
#import "AKPopupManager.h"

//按钮宽度
static CGFloat const kButtonWidth = 50.f;
static CGFloat const kContentInsets = 15.f;

static void *xxcontext = &xxcontext;

@interface AKMapViewController () <MAMapViewDelegate>

@property (nonatomic,strong) NSMutableDictionary* annotaitonList;
@property (nonatomic,assign) BOOL       isSetMeToCenter;

/**
 定位按钮
 */
@property (nonatomic, strong) HBLocationButton *locationButton;

/**
 设置按钮
 */
@property (nonatomic, strong) HBBaseRoundButton *friendButton;


@end

@implementation AKMapViewController




#pragma mark - Initialization

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.mapView setDelegate:self];
        
        //标尺位置
        self.mapView.scaleOrigin = CGPointMake(self.mapView.scaleOrigin.x, self.view.frame.size.height - 40);
        //指南针位置
        self.mapView.compassOrigin= CGPointMake(self.mapView.compassOrigin.x, 22);
        
        self.mapView.rotateCameraEnabled= NO;    //NO表示禁用倾斜手势，YES表示开启

        self.mapView.rotateEnabled= NO;
        
        //设置倾斜角度
        [self.mapView setCameraDegree:30.f animated:YES duration:0.5];
        
        [self.view addSubview:self.mapView];
        
    }
    //已经登录直接更新
    if( [AKMapManager sharedInstance].me == nil && [AK_MEDIATOR user_isUserLogin] ){
        [[AKMapManager sharedInstance] mapLogin];
        
    }
    
    
}





-(void)dealloc
{
    [AK_SIGNAL_MANAGER.onMapAddOnlineUser removeObserver:self];
    [AK_SIGNAL_MANAGER.onMapRemoveOnlineUser removeObserver:self];
    [AK_SIGNAL_MANAGER.onUserPositionChange removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}



- (void)setupButtons {
   
    self.locationButton = [[HBLocationButton alloc] initWithIconImage:ImageInName(@"main_location") clickBlock:^{
        self.isSetMeToCenter = NO;
        [self updateUserPosition:[AKMapManager sharedInstance].me];
        
    }];
    [self.view addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.bottom.equalTo(self.view.mas_bottom).with.offset( -kButtonWidth * 2);
        make.right.equalTo(self.view.mas_right).with.offset(-kContentInsets);
    }];
    
    self.friendButton = [[HBBaseRoundButton alloc] initWithIconImage:ImageInName(@"main_friend") clickBlock:^{
        UIView<AKPopupViewProtocol>* view = [AK_MEDIATOR im_popupConversationView];
        [view loadData:[AKMapManager sharedInstance].converstationList];
    }];
    
    [self.view addSubview:self.friendButton];
    [self.friendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.top.equalTo(self.locationButton.mas_bottom).with.offset(kContentInsets);
        make.right.equalTo(self.locationButton.mas_right);
    }];
}



-(void) updateUserPosition:(UserModel*) user
{
    NSLog(@"Update User info");
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = user.longitude;
    coordinate.latitude = user.latitude;
    if(user.latitude ==0 || user.longitude == 0 )return;
    AKUserPointAnnotation* pa = [self getUserPointAnnotation:user];
    [pa setCoordinate:coordinate];
    
    if(self.isSetMeToCenter && user == [AKMapManager sharedInstance].me){
        [self.mapView setCenterCoordinate:coordinate];
        [self.mapView setZoomLevel:15.1 animated:NO];
        self.isSetMeToCenter = NO;
    }

}



-(void) removeUserFromMap:(UserModel*)user
{
    NSString* key = [user.uid stringValue];
    AKUserPointAnnotation* pa = [self.annotaitonList objectForKey:key];
    if(pa){
        [self.mapView removeAnnotation:pa];
        [self.annotaitonList removeObjectForKey:key];
    }
}


-(AKUserPointAnnotation*)getUserPointAnnotation:(UserModel*)user
{
    NSString* key = [user.uid stringValue];
    AKUserPointAnnotation* pa = [self.annotaitonList objectForKey:key];
    if(pa == nil){
        pa = [[AKUserPointAnnotation alloc] initWithUser:user];
        [self.mapView addAnnotation:pa];
        [self.annotaitonList setObject:pa forKey:key];
    }
    return pa;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.isSetMeToCenter = YES;
    
    [self setupSignals];
    
    self.annotaitonList = [[NSMutableDictionary alloc] init];
    [self initMapView];
    
    [self setupButtons];
 
}

-(void)setupSignals
{
 
   
    [AK_SIGNAL_MANAGER.onMapAddOnlineUser addObserver:self callback:^(id self, UserModel *user) {
      
        [self updateUserPosition:user];
    }];
    
    [AK_SIGNAL_MANAGER.onUserPositionChange addObserver:self callback:^(id self, UserModel *user) {
        
        [self updateUserPosition:user];
    }];
    
    [AK_SIGNAL_MANAGER.onMapRemoveOnlineUser addObserver:self callback:^(id self, UserModel *user) {
        
        [self removeUserFromMap:user];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil]; //监听是否重新进入程序程序.
    
}

- (void)applicationDidBecomeActive:(NSNotification *)notic{
    self.isSetMeToCenter = YES;
    [[AKMapManager sharedInstance] reloadLocation];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBarHidden       = YES;
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}

/**
 * @brief 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param view 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    AKUserPinAnnotationView* v = (AKUserPinAnnotationView*)view;
    [AK_MEDIATOR map_popUserCardView:v.user];
     [self.mapView deselectAnnotation:view.annotation animated:YES];
}
#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AKUserPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        AKUserPinAnnotationView *annotationView = (AKUserPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[AKUserPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        AKUserPointAnnotation* pointAnnotation = (AKUserPointAnnotation*)annotation;
        
        
        [annotationView updateViews:pointAnnotation.user];
        
        return annotationView;
    }
    
    return nil;
}

@end

