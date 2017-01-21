//
//  MusicDownloadListViewController.m
//  MusicPartnerDownload
//
//  Created by 度周末网络-王腾 on 16/1/25.
//  Copyright © 2016年 dzmmac. All rights reserved.
//

#import "MusicDownloadListViewController.h"
#import "MusicDownloadListTableCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HSDownloadManager.h"

@interface MusicDownloadListViewController ()

@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation MusicDownloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Discover" ofType:@".plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in array) {
        MusicModel *model = [[MusicModel alloc]init];
        model.downLoadUrl = dic[@"downLoadUrl"];
        model.desc = dic[@"desc"];
        model.imgName = dic[@"imgName"];
        model.name = dic[@"name"];
        model.group = @"Movie";
        model.progress = [[HSDownloadManager sharedInstance] getProgress:model.downLoadUrl group:model.group];
        model.task = [[HSDownloadManager sharedInstance] addTask:model.downLoadUrl group:model.group];
        [self.dataSource addObject:model];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicDownloadListTableCell *musicListCell = [tableView dequeueReusableCellWithIdentifier:@"MusicDownloadListTableCell"];
    MusicModel *model = self.dataSource[indexPath.row];
    [musicListCell showData:model];
    return musicListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    TaskEntity *taskEntity = [self.dataSource.unFinishedTasks objectAtIndex:indexPath.row];
//    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:taskEntity.mpDownLoadPath]];
//    [self presentViewController:moviePlayer animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
