//
//  AKBookShelfHandler.m
//  Project
//
//  Created by ankye on 2017/2/4.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKBookShelfHandler.h"
#import "Book.h"
#import "YBookViewCell.h"

@interface AKBookShelfHandler () <AKBaseTableViewDelegate>

@property (nonatomic,strong) NSMutableArray     *dataList ;
@property (nonatomic,assign) NSInteger          lastPage ;
@end


@implementation AKBookShelfHandler



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
            Book *aContent = [Book bookWithDict:dic] ;
            [tmpList_data addObject:aContent] ;
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
            Book *aContent = [Book bookWithDict:dic] ;
            [tmpList_data addObject:aContent] ;
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
    
    
    static NSString * identifier=@"YBookViewCell";
    
    YBookViewCell *cell = (YBookViewCell*)[self getCell:tableView withName:identifier];
    
    cell.book = self.dataList[indexPath.row];
    
    return cell ;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  66.0 ;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)showAlcrtViewWithDeleteBook:(Book *)bookM {
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否选择彻底删除此书？" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (bookM.loadStatus != YDownloadStatusNone) {
//            bookM.loadStatus = YDownloadStatusCancel;
//        }
//        [self.sqliteM deleteBookWith:bookM];
//    }];
//    [alertVC addAction:cancelAction];
//    [alertVC addAction:sureAction];
//    [self presentViewController:alertVC animated:YES completion:nil];
}



-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    Book *editBook = self.dataList[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        [tableView setEditing:NO animated:YES];
        
//        NSMutableDictionary* attribute = [AKPopupManager buildPopupAttributes:NO showNav:YES style:STPopupStyleBottomSheet actionType:AKPopupActionTypeTop onClick:^(NSInteger channel, NSDictionary *attributes) {
//           
//       } onClose:^(NSDictionary *attributes) {
//           
//       }];
//        [AK_POPUP_MANAGER showView:[[AKBasePopupView alloc] init] withAttributes:attribute];
//
   //     [AK_POPUP_MANAGER showAlert];
        
    //    [self showAlcrtViewWithDeleteBook:editBookM];
    }];
    deleteAction.backgroundColor = AKRGBColor(255, 59, 48);
//    UITableViewRowAction *loadAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:editBookM.loadStatus == YDownloadStatusNone ? @"下载" : @"取消下载" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    UITableViewRowAction *loadAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title: @"下载" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

        NSLog(@"点击了下载/取消下载");
        [tableView setEditing:NO animated:YES];
//        if (editBookM.loadStatus == YDownloadStatusCancel) {
//            [YProgressHUD showErrorHUDWith:@"正在取消中..."];
//            return ;
//        }
//        if (editBookM.loadStatus == YDownloadStatusNone) {
//            [[YDownloadManager shareManager] downloadReaderBookWith:editBookM type:YDownloadTypeAllLoad];
//        } else {
//            [[YDownloadManager shareManager] cancelDownloadBookWith:editBookM];
//        }
        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        
    }];
    loadAction.backgroundColor =  AKRGBColor(255, 156, 0);
//    UITableViewRowAction *stickyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:editBookM.hasSticky ? @"取消置顶" : @"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    UITableViewRowAction *stickyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶/取消置顶");
        [tableView setEditing:NO animated:YES];
       // editBookM.hasSticky = !editBookM.hasSticky;
        //[[YSQLiteManager shareManager] stickyUserBookWith:editBookM];
        
    }];
    stickyAction.backgroundColor = AKRGBColor(199, 199, 204);
    NSArray *arr = @[deleteAction,loadAction,stickyAction];
    return arr;
}


@end
