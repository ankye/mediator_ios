//
//  MusicDownloadListTableCell.h
//  MusicPartnerDownload
//
//  Created by 度周末网络-王腾 on 16/1/25.
//  Copyright © 2016年 dzmmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKProgressBarView.h"
#import "AKDownloadGroupModel.h"

@interface AKDownloadListTableCell : UITableViewCell

@property (nonatomic, strong) AKProgressBarView *progressBarView;
@property (nonatomic,strong) AKDownloadGroupModel *downloadGroup;

@property (nonatomic,strong) NSString                *downloadUrl;
@property (weak, nonatomic ) IBOutlet UILabel        *musicName;

@property (weak, nonatomic ) IBOutlet UILabel        *musicDownloadPercent;
@property (weak, nonatomic ) IBOutlet UIButton       *stopStartBtn;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;

- (IBAction)stopStartAction:(UIButton *)sender;

- (void)showData:(AKDownloadGroupModel *)group;

@end
