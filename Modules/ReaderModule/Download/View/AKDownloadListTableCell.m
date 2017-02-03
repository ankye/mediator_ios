//
//  MusicDownloadListTableCell.m
//  MusicPartnerDownload
//
//  Created by 度周末网络-王腾 on 16/1/25.
//  Copyright © 2016年 dzmmac. All rights reserved.
//

#import "AKDownloadListTableCell.h"
#import "AKDownloadManager.h"
#import "UIImageView+WebCache.h"

@interface AKDownloadListTableCell ()<HSDownloadTaskDelegate>

@end
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

    HSDownloadState state = self.downloadGroup.state;
    
    if(state == HSDownloadStateCompleted){
        
    }else if(state == HSDownloadStateRunning){
        [[AKDownloadManager sharedInstance] pauseGroup:self.downloadGroup];
    }else{
        [[AKDownloadManager sharedInstance] startGroup:self.downloadGroup];
    }
   
    [self setButtonState:self.downloadGroup.state];
    
}

-(void)setButtonState:( HSDownloadState)state
{
    if(state == HSDownloadStateCompleted){
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_complete"] forState:UIControlStateNormal];
    }else if ( state == HSDownloadStateSuspended) {
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    }else if (state == HSDownloadStateRunning){
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
    }else{
        [self.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    }

}

-(void)cleanCurrentDownloadGroup
{
    if(self.downloadGroup){
        [self.downloadGroup.onDownloadCompleted removeObserver:self];
        [self.downloadGroup.onDownloadProgress removeObserver:self];
    }
}

-(void)dealloc
{
    [self cleanCurrentDownloadGroup];

}

-(void)showData:(AKDownloadGroupModel *)group{
    
    [self cleanCurrentDownloadGroup];
    
    self.downloadGroup = group;
    self.desc.text = group.currentModel.desc;
    
       [self.img sd_setImageWithURL:[NSURL URLWithString:group.currentModel.icon] placeholderImage:[UIImage imageNamed:@"default_book"]];
    
    //self.img.image = [YYImage ] //[AKResourceManager imageNamed:group.currentModel.icon];//[UIImage imageNamed:group.currentModel.icon];
    self.downloadUrl = group.currentModel.downLoadUrl;
    self.musicName.text = group.groupName;
    self.progressBarView.progress = group.groupProgress;
    self.musicDownloadPercent.text =  [NSString stringWithFormat:@"%.1f%%", group.groupProgress*100];
    
    [self setButtonState:group.state];

//     __weak typeof(self) weakSelf = self;
//    self.downloadGroup.delegate = weakSelf;
    
    [self.downloadGroup.onDownloadProgress addObserver:self callback:^(id  _Nonnull self, NSDictionary * _Nonnull dictionary) {
       [self downloadProgress:dictionary[@"groupName"] withUrl:dictionary[@"url"] withProgress:[dictionary[@"progress"] floatValue] withTotalRead:[dictionary[@"total"] floatValue] withTotalExpected:[dictionary[@"expected"] floatValue]];
    }];
    [self.downloadGroup.onDownloadCompleted addObserver:self callback:^(id  _Nonnull self, NSDictionary * _Nonnull dictionary) {
        [self downloadComplete:(HSDownloadState)[dictionary[@"state"] integerValue] withGroupName:dictionary[@"groupName"] downLoadUrlString:dictionary[@"url"]];
    }];
    
//    self.downloadGroup.task.downloadProgressBlock = ^(CGFloat progress, CGFloat totalRead, CGFloat totalExpectedToRead){
//        weakSelf.progressBarView.progress = progress;
//        weakSelf.musicDownloadPercent.text = [NSString stringWithFormat:@"%.1f%%",progress*100];
//    };
//     self.downloadGroup.task.downloadCompleteBlock = ^(HSDownloadState downloadState,NSString *downLoadUrlString) {
//        if (downloadState == HSDownloadStateRunning){
//            [weakSelf.stopStartBtn setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
//        }else {
//            [weakSelf.stopStartBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
//        }
//    };
}

-(void)downloadProgress:(NSString*)groupName withUrl:(NSString*)url withProgress:(CGFloat)progress withTotalRead:(CGFloat)totalRead withTotalExpected:(CGFloat)expected
{
     dispatch_async(dispatch_get_main_queue(), ^{
         self.progressBarView.progress = progress;
         self.musicDownloadPercent.text = [NSString stringWithFormat:@"%.1f%%",progress*100];
         self.desc.text = self.downloadGroup.currentModel.taskName;
     });
}

-(void)downloadComplete:(HSDownloadState)downloadState withGroupName:(NSString*)groupName downLoadUrlString:(NSString *)downLoadUrlString
{
     dispatch_async(dispatch_get_main_queue(), ^{
         [self setButtonState:downloadState];
     });
}

@end
