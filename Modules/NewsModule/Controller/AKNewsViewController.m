//
//  AKNewsViewController.m
//  Project
//
//  Created by ankye on 2016/12/20.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKNewsViewController.h"
#import "AKHContentView.h"
#import "AKCustomTableHandler.h"
#import "AKNewsManager.h"
#import "AKCustomTableView.h"


@implementation AKNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat barHeight = self.navigationController?SCREEN_NAV_HEIGHT:0;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    
    [self reloadTableHandlers];
    
    // 设置整体内容尺寸（包含标题滚动视图和底部内容滚动视图）
    [self setUpContentViewFrame:^(UIView *contentView) {
        
        CGFloat contentX = 0;
        
        CGFloat contentY = barHeight;
        
        CGFloat contentH = screenH - contentY -SCREEN_TABBAR_HEIGHT  ;
        
        contentView.frame = CGRectMake(contentX, contentY, screenW, contentH);
        
    }];
    
    /****** 标题渐变 ******/
    // 推荐方式(设置标题颜色渐变) // 默认RGB样式
    [self setUpTitleGradient:^(HSTB_TitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        *norColor = [UIColor blackColor];
        *selColor = [UIColor redColor];
    }];
    
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat* headerHeight, CGFloat *titleHeight, CGFloat *titleWidth) {
        *headerHeight = SCREEN_NAV_HEIGHT;
        *titleHeight = 40;
        *titleFont = [UIFont systemFontOfSize:15];
        
    }];
    
    [self setUpTitleScale:^(CGFloat *titleScale) {
        *titleScale = 1.3;
    }];
    
    /****** 设置遮盖 ******/
    // *推荐方式(设置遮盖)
    //    [self setUpCoverEffect:^(UIColor **coverColor, CGFloat *coverCornerRadius) {
    //
    //        // 设置蒙版颜色
    //        *coverColor = [UIColor colorWithWhite:0.7 alpha:0.4];
    //
    //        // 设置蒙版圆角半径
    //        *coverCornerRadius = 5;
    //    }];
    
    // 推荐方式（设置下标）
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        // 标题填充模式
        *underLineColor = [UIColor redColor];
        *underLineH = 3.0f;
    }];
    
}


-(void)reloadTableHandlers
{
    NSMutableArray* channelList = [AKNewsManager sharedInstance].selectedChannels;
    NSMutableArray *tableHandlersList = [@[] mutableCopy] ;
    for (AKNewsChannel *channel in channelList) {
        AKCustomTableHandler *handler_Cms = [[AKCustomTableHandler alloc] initWithChannel:channel] ;
        handler_Cms.handlerDelegate = self ;
        [tableHandlersList addObject:handler_Cms] ;
    }
    
    
    [self reloadTables:tableHandlersList];
}
-(void)reloadTables:(NSMutableArray*)handlerList
{
    NSInteger count = [handlerList count];
    for(NSInteger i=0; i<count; i++){
        AKCustomTableHandler* handler = [handlerList objectAtIndex:i];
        
        if([self.contentViews count] > i){
            AKHContentView* tempView = [self.contentViews objectAtIndex:i];
            tempView.contentView = [[AKCustomTableView alloc] initWithFrame:tempView.frame];
            tempView.handler = handler;
        }else{
            AKHContentView* tempView = [[AKHContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_NAV_HEIGHT-SCREEN_TABBAR_HEIGHT)];
            tempView.contentView = [[AKCustomTableView alloc] initWithFrame:tempView.frame];
            tempView.handler = handler;
            [self.contentViews addObject:tempView];
        }
    }
}



- (void)tableDidScrollWithOffsetY:(float)offsetY
{
    
}
- (void)tablelWillEndDragWithOffsetY:(float)offsetY WithVelocity:(CGPoint)velocity
{
    
}
- (void)handlerRefreshing:(id)handler
{
    
}
-(void)didSectionClick:(NSInteger)section withRow:(NSInteger)row withClickChannel:(NSInteger)clickChannel withContent:(NSObject *)content
{
    
}

//选择某一行
- (void)didSelectSection:(NSInteger)section withRow:(NSInteger)row withContent:(NSObject* )content
{
    
}

-(void)dealloc
{
    [AK_SIGNAL_MANAGER.onNewsSelectedChannelChange removeObserver:self];
}

@end
