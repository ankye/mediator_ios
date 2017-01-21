//
//  MusicDownloadListTableCell.m
//  MusicPartnerDownload
//
//  Created by 度周末网络-王腾 on 16/1/25.
//  Copyright © 2016年 dzmmac. All rights reserved.
//

#import "MusicDownloadListTableCell.h"
#import "HSDownloadManager.h"

@implementation MusicDownloadListTableCell

- (void)awakeFromNib {
    self.progressBarView = [[TYMProgressBarView alloc] initWithFrame:CGRectMake(86 , 80, [UIScreen mainScreen].bounds.size.width - 150, 8.0f)];
    [self.contentBgView addSubview:self.progressBarView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)stopStartAction:(UIButton *)sender {

    if (self.musicModel.task.state == HSDownloadStateRunning) {
        [[HSDownloadManager sharedInstance] pause:self.musicModel.downLoadUrl group:self.musicModel.group];
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
    }else if (self.musicModel.task.state == HSDownloadStateSuspended){
        [[HSDownloadManager sharedInstance] start:self.musicModel.downLoadUrl group:self.musicModel.group];
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    }else{
        [[HSDownloadManager sharedInstance] start:self.musicModel.downLoadUrl group:self.musicModel.group];
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    }
}


-(void)showData:(MusicModel *)musicModel{
    
    self.musicModel = musicModel;
    self.desc.text = musicModel.desc;
    self.img.image = [UIImage imageNamed:musicModel.imgName];
    self.downloadUrl = musicModel.downLoadUrl;
    self.musicName.text = musicModel.name;
    self.progressBarView.progress = musicModel.progress;
    self.musicDownloadPercent.text =  [NSString stringWithFormat:@"%.1f",musicModel.progress*100];
    
    if (musicModel.task.state == HSDownloadStateSuspended) {
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    }else if (musicModel.task.state == HSDownloadStateRunning){
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
    }else{
         [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    }
     __weak typeof(self) weakSelf = self;
    self.musicModel.task.downloadProgressBlock = ^(CGFloat progress, CGFloat totalRead, CGFloat totalExpectedToRead){
        weakSelf.progressBarView.progress = progress;
        weakSelf.musicDownloadPercent.text = [NSString stringWithFormat:@"%.1f%%",progress*100];
    };
    self.musicModel.task.downloadCompleteBlock = ^(HSDownloadState downloadState,NSString *downLoadUrlString) {
        if (downloadState == HSDownloadStateRunning){
            [weakSelf.stopStartBtn setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
        }else {
            [weakSelf.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
        }
    };
}

@end
