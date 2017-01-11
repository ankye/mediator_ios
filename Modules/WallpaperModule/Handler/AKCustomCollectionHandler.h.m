//
//  AKCustomCollectionViewHandler.m
//  Project
//
//  Created by ankye on 2017/1/6.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKCustomCollectionHandler.h"
#import "AKNewsChannel.h"
#import "AKRequestManager+WallpaperModule.h"
#import "XHSHomeModel.h"
#import "XHSHomeCell.h"

#import "AKWaterFallView.h"
#import "CHTCollectionViewWaterfallLayout.h"

static int const kPageSize = 20 ;

@interface AKCustomCollectionHandler () <CHTCollectionViewDelegateWaterfallLayout,RootCollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray     *dataList ;
@property (nonatomic,strong) dispatch_queue_t   myQueue ;



@end

@implementation AKCustomCollectionHandler

@synthesize dataList = _dataList;

#pragma mark - life
- (void)dealloc
{
    _dataList = nil ;
 
}

- (instancetype)initWithChannel:(AKNewsChannel *)channel
{
    self = [super init];
    if (self)
    {
        self.channel = channel ;
    }
    return self;
}

#pragma mark - public func
- (BOOL)hasDataSource
{
    BOOL dataNotNull = _dataList != nil  ;
    BOOL dataHasCount = _dataList.count;
    return dataNotNull && dataHasCount ;
}

-(NSString*)getTitle
{
    return self.channel.name;
}
#pragma mark - prop
- (dispatch_queue_t)myQueue
{
    if (!_myQueue) {
        _myQueue = dispatch_queue_create("mySyncQueue", DISPATCH_QUEUE_CONCURRENT) ;
    }
    return _myQueue ;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [@[] mutableCopy] ;
    }
    return _dataList ;
    
    __block NSMutableArray *list ;
    dispatch_sync(self.myQueue, ^{
        list = _dataList ;
    }) ;
    return list ;
}

- (void)setDataList:(NSMutableArray *)dataList
{
    dispatch_barrier_async(self.myQueue, ^{
        _dataList = dataList ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData] ;
        }) ;
    }) ;
}




#pragma mark - RootTableViewDelegate
- (void)loadNewData
{
    
    
    DDLogInfo(@"加载新数据:%@",self.channel.name);
    
    [AK_REQUEST_MANAGER wallpaper_requestContentListWithNum:kPageSize success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSData* jsonData = request.responseData;
        NSDictionary* response = [AppHelper dictionaryWithData:jsonData];
        
        NSArray *tempArr = [NSArray array];
        tempArr = response[@"data"];
        
        self.dataList = [XHSHomeModel mj_objectArrayWithKeyValuesArray:tempArr];
        NSLog(@"%@",self.dataList);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
 
    
}

- (void)loadMoreData
{
    
    if (!self.dataList.count) {
        return ;
    }
    
     NSMutableArray*tmpList_data = self.dataList ;
    
    [AK_REQUEST_MANAGER wallpaper_requestContentListWithNum:kPageSize success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSData* jsonData = request.responseData;
        NSDictionary* response = [AppHelper dictionaryWithData:jsonData];
        
        NSArray *tempArr = [NSArray array];
        tempArr = response[@"data"];
        
        NSMutableArray* dataList = [XHSHomeModel mj_objectArrayWithKeyValuesArray:tempArr];
        [tmpList_data appendObjects:dataList];
        self.dataList = tmpList_data;
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    


    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    XHSHomeCell *cell =     [collectionView dequeueReusableCellWithReuseIdentifier:identifier_XHSHomeCell forIndexPath:indexPath] ;
    
    cell.model = self.dataList[indexPath.item];

    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout *)waterLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
        XHSHomeModel *model = self.dataList[indexPath.item];
    
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - waterLayout.sectionInset.left - waterLayout.sectionInset.right - (waterLayout.minimumColumnSpacing * (waterLayout.columnCount - 1))) / waterLayout.columnCount;
    
        CGFloat scale = [model.width floatValue] / width;
        CGFloat height = [model.height floatValue] / scale;
    
        CGSize maxSize = CGSizeMake(width, MAXFLOAT);
        CGFloat descHeight = [model.title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
    
        return CGSizeMake(width,  height + descHeight + 64 );
    
}


#pragma mark - func

- (void)handleDatasourceAndDelegate:(UIView *)table
{
    if ([table isKindOfClass:[AKWaterFallView class]])
    {
        ((AKWaterFallView *)table).xt_Delegate = self ;
        
        // offset Y value changed.
 //       __weak AKWaterFallView *tableCenter = (AKWaterFallView *)table ;
//        tableCenter.offsetYHasChangedValue = ^(CGFloat offsetY) {
//            
//            if (tableCenter.mj_header.isRefreshing) return ;
//            
//            if (self.handlerDelegate != nil && [self.handlerDelegate respondsToSelector:@selector(tableDidScrollWithOffsetY:)])
//            {
//                [self.handlerDelegate tableDidScrollWithOffsetY:offsetY] ;
//            }
//            
//        } ;
    }

    
    [super handleDatasourceAndDelegate:table] ;
}

- (void)refresh
{
    
    [self.handlerDelegate handlerRefreshing:self] ;
}



#pragma mark - scrollView delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    float offsetY = scrollView.contentOffset.y ;
    
    if (self.handlerDelegate != nil && [self.handlerDelegate respondsToSelector:@selector(tablelWillEndDragWithOffsetY:WithVelocity:)]) {
        [self.handlerDelegate tablelWillEndDragWithOffsetY:offsetY WithVelocity:velocity] ;
    }
    
 
}



@end
