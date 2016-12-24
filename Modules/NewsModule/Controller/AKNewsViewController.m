//
//  AKNewsViewController.m
//  Project
//
//  Created by ankye on 2016/12/20.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKNewsViewController.h"
#import "GVUserDefaults+NewsModule.h"

#import "AKChannelTagView.h"
#import "AKNewsManager.h"
#import "AKNewsChannel.h"
#import "HSelectionList.h"
#import "AKMutableView.h"

#import "CmsTableHandler.h"
#import "ResultParsered.h"
#import "ServerRequest.h"

//#define TopRect             CGRectMake(0, 0, SCREEN_WIDTH, 40)
//#define MainRect            CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49.)
//#define TopImageRect        CGRectMake(0, 0, SCREEN_WIDTH, [BannerCell getHeight])
//#define TopNavgationRect    CGRectMake(0, 0, SCREEN_WIDTH, 40. + 20.)
//#define TopAndNavRect       CGRectMake(0, 20, SCREEN_WIDTH, 40. + 20.)
//#define OverLength          ([BannerCell getHeight] - 40. - 20.)



@interface AKNewsViewController () <HSelectionListDelegate, HSelectionListDataSource,AKMutableViewDelegate,AKMutableViewDataSource,CmsTableHandlerDelegate>


@property (nonatomic, strong) HSelectionList *hSelectionList;
@property (nonatomic,strong)  AKMutableView  *mutableView;



@end

@implementation AKNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupHSelectionList];
    
    [self showTheScence] ;
    
    
    [AK_SIGNAL_MANAGER.onNewsSelectedChannelChange addObserver:self callback:^(typeof(self) self, NSMutableArray * _Nonnull mutableArray) {
        [self.hSelectionList reloadData];
    }];
    
    
    
}


- (void)showTheScence
{
    // 1. XTMultipleTables
    NSMutableArray *tableHandlersList = [@[] mutableCopy] ;
    NSMutableArray* channelList = [AKNewsManager sharedInstance].selectedChannels;
    
    for (AKNewsChannel *channel in channelList) {
        CmsTableHandler *handler_Cms = [[CmsTableHandler alloc] initWithChannel:channel] ;
        handler_Cms.handlerDelegate = self ;
        [tableHandlersList addObject:handler_Cms] ;
    }
    self.mutableView = [[AKMutableView alloc] initWithFrame:SCREEN_FRAME
                                                           handlers:tableHandlersList] ;
    self.mutableView.akDelegate = self ;
    self.mutableView.dataSourceDelegate = self;
    
    [self.view addSubview:self.mutableView] ;
    
    [_mutableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hSelectionList.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    _mutableView.backgroundColor = [UIColor redColor];
}


-(void)setupHSelectionList
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.hSelectionList = [[HSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.hSelectionList.delegate = self;
    self.hSelectionList.dataSource = self;
    self.hSelectionList.showsEdgeFadeEffect = YES;
    self.hSelectionList.snapToCenter = YES;
    self.hSelectionList.selectionIndicatorAnimationMode = HSelectionIndicatorAnimationModeNoBounce;
    self.hSelectionList.selectionIndicatorColor = [UIColor redColor];
    [self.hSelectionList setTitleFont:[UIFont systemFontOfSize:15] forState:UIControlStateNormal];
    [self.hSelectionList setTitleFont:[UIFont boldSystemFontOfSize:18] forState:UIControlStateSelected];
    [self.view addSubview:self.hSelectionList];
    [_hSelectionList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
}

#pragma mark - HSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(id<HSelectionListProtocol>)selectionList {
    return [[AKNewsManager sharedInstance].selectedChannels count];
}

- (NSString *)selectionList:(id<HSelectionListProtocol>)selectionList titleForItemWithIndex:(NSInteger)index {
    AKNewsChannel* channel = [[AKNewsManager sharedInstance].selectedChannels objectAtIndex:index];
    return channel.name;
}

#pragma mark - HSelectionListDelegate Protocol Methods

- (void)selectionList:(id<HSelectionListProtocol>)selectionList didSelectButtonWithIndex:(NSInteger)index {
    // update the view for the corresponding index
  
    
     [self.mutableView mutableViewDidMoveAtIndex:index] ;
}

-(void)showChooseTagDlg
{
    AKChannelTagView *vc = [[AKChannelTagView alloc] init];
    
    NSMutableDictionary* attributes = [AKPopupManager buildPopupAttributes:NO showNav:NO style:STPopupStyleFormSheet onClick:^(NSInteger channel, NSDictionary *attributes) {
        
    } onClose:^(NSDictionary *attributes) {
        
        [AKNewsManager sharedInstance].selectedChannels = [attributes[@"selected"] mutableCopy];
        [AKNewsManager sharedInstance].unSelectedChannels = [attributes[@"unSelected"] mutableCopy];
        
    }];
    
    [vc loadData:@{@"selected":[AKNewsManager sharedInstance].selectedChannels,@"unSelected":[AKNewsManager sharedInstance].unSelectedChannels}];
    [AK_POPUP_MANAGER showView:vc withAttributes:attributes];
}






#pragma mark - CmsTableHandlerDelegate
- (void)bannerSelected:(Content *)content
{
    [self jump2DetailVC:content] ;
}

- (void)didSelectRowWithContent:(Content *)content
{
    [self jump2DetailVC:content] ;
}

- (void)jump2DetailVC:(Content *)content
{
//    DetailCtrller *detailVC = (DetailCtrller *)[[self class] getCtrllerFromStory:@"Index" controllerIdentifier:@"DetailCtrller"] ;
//    detailVC.content = content ;
//    [detailVC setHidesBottomBarWhenPushed:YES] ;
//    [self.navigationController pushViewController:detailVC animated:YES] ;
}


// callback in did scroll and
- (void)tableDidScrollWithOffsetY:(float)offsetY
{
   // [self makeNavBarDisplayWithOffsetY:offsetY] ;
}

// callback in will end dragging .
- (void)tablelWillEndDragWithOffsetY:(float)offsetY WithVelocity:(CGPoint)velocity
{
    //    NSLog(@"offsetY : %lf",offsetY) ;
  //  [self makeNavigationbarDisplayWithOffsetY:offsetY Velocity:velocity] ;
}

- (void)handlerRefreshing:(id)handler
{
//    float offsetY = ((CmsTableHandler *)handler).offsetY ;
//    float overLength = OverLength ;
//    
//    //    NSLog(@"offsetY : %lf",offsetY) ;
//    if (offsetY > overLength) {
//        [self makeNavigationbarDisplayWithOffsetY:offsetY Velocity:CGPointZero] ;
//    }
//    else {
//        [self makeNavBarDisplayWithOffsetY:offsetY] ;
//    }
}




#pragma mark - XTMultipleTablesDelegate
- (void)viewDidMovedAtIndex:(AKMutableView*)mutableView atIndex:(NSInteger)index
{
    NSLog(@"moveToIndexCallBack %@",@(index)) ;
    
    [self.hSelectionList setSelectedButtonIndex:index animated:YES];
    
    [self.mutableView pulldownCenterTableIfNeeded] ;
    
   
}






-(void)dealloc
{
    [AK_SIGNAL_MANAGER.onNewsSelectedChannelChange removeObserver:self];
}

@end
