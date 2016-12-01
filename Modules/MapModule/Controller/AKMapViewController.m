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


//@property (nonatomic, strong) AKUserPointAnnotation *pointAnnotaiton;
@property (nonatomic,strong) NSMutableDictionary* annotaitonList;


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
        
    
        @weakify(self)
        
        [[AKMapManager sharedInstance] addObserverBlockForKeyPath:@"me" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            @strongify(self);
           dispatch_async(dispatch_get_main_queue(), ^{
               @strongify(self);
               UserModel* me = newVal;
               if(oldVal == nil){
                    [self setMeToMapCenter:me];
                   
               }else{
                   [self updateUserPosition:me];
               }
           });
            
        }];
        
        [[AKMapManager sharedInstance] addObserver:self forKeyPath:@"userlist" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:xxcontext];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserPosition:) name:@"UserSendPositionUpdate" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationWillEnterForegroundNotification object:nil]; //监听是否重新进入程序程序.
        
//        [[AKMapManager sharedInstance].userlist addObserverBlockForKeyPath:@"count" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
//            @strongify(self);
//            [self updateUserPointAnnotation];
//            
//        }];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == xxcontext) {
        if ([keyPath isEqualToString:@"userlist"]) {
            NSNumber *kind = change[NSKeyValueChangeKindKey];
            NSArray *userlist = change[NSKeyValueChangeNewKey];
            NSArray *oldUserlist = change[NSKeyValueChangeOldKey];
            NSIndexSet *changedIndexs = change[NSKeyValueChangeIndexesKey];
            
            NSLog(@"kind: %@, students: %@, oldStudent: %@, changedIndexs: %@", kind, userlist , oldUserlist, changedIndexs);
            [self updateUserPointAnnotation];
           
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notic{
    [[AKMapManager sharedInstance] reloadLocation];
    [self updateUserPointAnnotation];
}

-(void)dealloc
{
     [[AKMapManager sharedInstance] removeObserver:self forKeyPath:@"userlist"];
}

-(void)updateUserPointAnnotation
{
    for(UserModel* user in [AKMapManager sharedInstance].userlist){
        [self updateUserPosition: user];
    }
}

-(void)changeUserPosition:(NSNotification*)notify
{
    NSDictionary* dic = (NSDictionary*)notify.object;
    if(dic){
        
      
            UserModel* user = [[AKDataCenter sharedInstance] user_getUserInfo:dic[@"uid"]];
            
            [self updateUserPosition:user];
        
        
    }

}

- (void)setupButtons {
   
    self.locationButton = [[HBLocationButton alloc] initWithIconImage:ImageInName(@"main_location") clickBlock:^{
        [self setMeToMapCenter:[AKMapManager sharedInstance].me];
        
    }];
    [self.view addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.bottom.equalTo(self.view.mas_bottom).with.offset( -kButtonWidth * 2);
        make.right.equalTo(self.view.mas_right).with.offset(-kContentInsets);
    }];
    
    self.friendButton = [[HBBaseRoundButton alloc] initWithIconImage:ImageInName(@"main_friend") clickBlock:^{
        UIView<AKPopupViewProtocol>* view = [[AKMediator sharedInstance] im_popupConversationView];
        [view loadData:[AKMapManager sharedInstance].friendList];
    }];
    [self.view addSubview:self.friendButton];
    [self.friendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.top.equalTo(self.locationButton.mas_bottom).with.offset(kContentInsets);
        make.right.equalTo(self.locationButton.mas_right);
    }];
}

-(void) setMeToMapCenter:(UserModel*)user
{
    if(user){
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = user.longitude;
        coordinate.latitude = user.latitude;
        [self updateUserPosition:user];
        [self.mapView setCenterCoordinate:coordinate];
        [self.mapView setZoomLevel:15.1 animated:NO];
    }
}

-(void) updateUserPosition:(UserModel*) user
{
    NSLog(@"Update User info");
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = user.longitude;
    coordinate.latitude = user.latitude;
    
    AKUserPointAnnotation* pa = [self getUserPointAnnotation:user];
    [pa setCoordinate:coordinate];
    

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
    
    self.annotaitonList = [[NSMutableDictionary alloc] init];
    [self initMapView];
    [self setupButtons];
 
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
    [[AKMediator sharedInstance] map_popUserCardView:v.user];
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
        
        
        annotationView.user = pointAnnotation.user;
        
        return annotationView;
    }
    
    return nil;
}

@end

