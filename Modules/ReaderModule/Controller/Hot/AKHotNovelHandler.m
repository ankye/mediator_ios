//
//  AKHotNovelHandler.m
//  Project
//
//  Created by ankye on 2017/1/16.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKHotNovelHandler.h"
#import "AKBaseTableViewDelegate.h"
#import "AKBaseTableView.h"
#import "Book.h"
#import "BookCollMainCell.h"
#import "ReaderModuleDefine.h"

@interface AKHotNovelHandler () <AKBaseTableViewDelegate>

@property (nonatomic,strong) NSMutableArray     *dataList ;
@property (nonatomic,assign) NSInteger          lastPage ;
@end

@implementation AKHotNovelHandler

@synthesize dataList = _dataList;


#pragma mark - life
- (void)dealloc
{
    _dataList = nil ;

}



#pragma mark - public func
- (BOOL)hasDataSource
{
    BOOL dataNotNull = _dataList != nil  ;
    BOOL dataHasCount = _dataList.count ;
    return dataNotNull && dataHasCount ;
}

-(NSString*)getTitle
{
    return @"";
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
            [self.table refreshData] ;
        }) ;
    }) ;
}



- (void)loadNewData
{
    
    NSMutableArray*tmpList_data = [@[] mutableCopy] ;
    _lastPage = 0;
    [AK_REQUEST_MANAGER reader_requestHotListWithPage:1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSData* jsonData = request.responseData;
        NSDictionary* response = [AppHelper dictionaryWithData:jsonData];
        
        NSInteger errorCode =[response[@"status"] integerValue];
        if(errorCode!=1){
            [[[UIAlertView alloc]initWithTitle:FINAL_PROMPT_INFOMATION message:response[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
            return;
        }

        _lastPage = 1;
         NSArray *retlist = response[@"data"] ;
    
  
        for (NSDictionary *dic in retlist) {
            Book *book = [Book bookWithDict:dic] ;
            book = [[AKReaderManager sharedInstance] addBook:book];
            [tmpList_data addObject:book] ;
        }
        
        self.dataList = tmpList_data ;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
    
    
}

- (void)loadMoreData
{
    
    if (!self.dataList.count) {
        return ;
    }
    
   // Content *lastContent = [self.dataList lastObject] ;
    
    NSMutableArray*tmpList_data = self.dataList ;
    [AK_REQUEST_MANAGER reader_requestHotListWithPage:(_lastPage+1) success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSData* jsonData = request.responseData;
        
        
        NSDictionary* response = [AppHelper dictionaryWithData:jsonData];
        
        NSInteger errorCode =[response[@"status"] integerValue];
        if(errorCode!=1){
            [[[UIAlertView alloc]initWithTitle:FINAL_PROMPT_INFOMATION message:response[@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }
        
       
        NSArray *retlist = response[@"data"] ;
        if([retlist count ] > 0){
             _lastPage += 1;
        }else{
            return ;
        }
        for (NSDictionary *dic in retlist) {
            Book *book = [Book bookWithDict:dic] ;
            book = [[AKReaderManager sharedInstance] addBook:book];
            [tmpList_data addObject:book] ;
        }
        self.dataList = tmpList_data ;

        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
    
}





#pragma mark - tableView datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return (!self.dataList.count) ? 0 : self.dataList.count ;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // banner

    
    static NSString * identifier=@"BookCollMainCell";
    
    BookCollMainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier] ;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    }
    cell.book = self.dataList[indexPath.row];
    
    return cell ;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  100.0 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.dataList count] <= indexPath.row) return ;
    Book *book = self.dataList[indexPath.row];
    if(self.handlerDelegate && [self.handlerDelegate respondsToSelector:@selector(didSelectSection:withRow:withContent:)]){
        [self.handlerDelegate didSelectSection:indexPath.section withRow:indexPath.row withContent:book];
    }
    NSLog(@"click row : %ld",indexPath.row) ;

}


- (void)refresh
{
    [self.handlerDelegate handlerRefreshing:self] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
    
    //nav 吸附性
    //    NSLog(@"velocity : %@",NSStringFromCGPoint(velocity)) ;
    if (velocity.y > 0.) {
        if (velocity.y > 1.8) return ; // 超速 .
        // 上推
        
    }
}



@end
