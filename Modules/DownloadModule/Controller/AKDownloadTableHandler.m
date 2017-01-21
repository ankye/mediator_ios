//
//  AKDownloadTableHandler.m
//  Project
//
//  Created by ankye on 2017/1/21.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKDownloadTableHandler.h"
#import "AKDownloadManager.h"
#import "MusicDownloadListTableCell.h"

@implementation AKDownloadTableHandler



#pragma mark - public func
- (BOOL)hasDataSource
{
    return [[AKDownloadManager sharedInstance] isEmptyList];
}



#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[AKDownloadManager sharedInstance].downloadList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier=@"MusicDownloadListTableCell";
    MusicDownloadListTableCell * cell= (MusicDownloadListTableCell*)[self getCell:tableView withName:identifier];
    
    DownloadModel *model = [AKDownloadManager sharedInstance].downloadList[indexPath.row];
    [cell showData:model];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


@end
