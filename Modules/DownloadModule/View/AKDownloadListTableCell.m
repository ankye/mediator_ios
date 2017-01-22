//
//  MusicDownloadListTableCell.m
//  MusicPartnerDownload
//
//  Created by 度周末网络-王腾 on 16/1/25.
//  Copyright © 2016年 dzmmac. All rights reserved.
//

#import "AKDownloadListTableCell.h"
#import "HSDownloadManager.h"

@implementation AKDownloadListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.progressBarView = [[AKProgressBarView alloc] initWithFrame:CGRectMake(86 , 80, [UIScreen mainScreen].bounds.size.width - 150, 8.0f)];
    [self.contentBgView addSubview:self.progressBarView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)stopStartAction:(UIButton *)sender {

    if ( self.downloadGroup.currentModel.task.state == HSDownloadStateRunning) {
        [[HSDownloadManager sharedInstance] pause: self.downloadGroup.currentModel.downLoadUrl group: self.downloadGroup.groupName];
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
    }else if ( self.downloadGroup.currentModel.task.state == HSDownloadStateSuspended){
        [[HSDownloadManager sharedInstance] start: self.downloadGroup.currentModel.downLoadUrl group: self.downloadGroup.groupName];
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    }else{
        [[HSDownloadManager sharedInstance] start: self.downloadGroup.currentModel.downLoadUrl group: self.downloadGroup.groupName];
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    }
}


-(void)showData:(AKDownloadGroupModel *)group{
    
    self.downloadGroup = group;
    self.desc.text = group.currentModel.desc;
    self.img.image = [UIImage imageNamed:group.currentModel.icon];
    self.downloadUrl = group.currentModel.downLoadUrl;
    self.musicName.text = group.currentModel.taskName;
    self.progressBarView.progress = group.currentModel.progress;
    self.musicDownloadPercent.text =  [NSString stringWithFormat:@"%.1f%%", group.currentModel.progress*100];
    
    if ( group.currentModel.task.state == HSDownloadStateSuspended) {
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    }else if ( group.currentModel.task.state == HSDownloadStateRunning){
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
    }else{
         [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    }
     __weak typeof(self) weakSelf = self;
    self.downloadGroup.currentModel.task.downloadProgressBlock = ^(CGFloat progress, CGFloat totalRead, CGFloat totalExpectedToRead){
        weakSelf.progressBarView.progress = progress;
        weakSelf.musicDownloadPercent.text = [NSString stringWithFormat:@"%.1f%%",progress*100];
    };
     self.downloadGroup.currentModel.task.downloadCompleteBlock = ^(HSDownloadState downloadState,NSString *downLoadUrlString) {
        if (downloadState == HSDownloadStateRunning){
            [weakSelf.stopStartBtn setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
        }else {
            [weakSelf.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
        }
    };
}

@end
