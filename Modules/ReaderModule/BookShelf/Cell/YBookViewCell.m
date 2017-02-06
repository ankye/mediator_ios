//
//  YBookViewCell.m
//  YReaderDemo
//
//  Created by yanxuewen on 2016/12/14.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "YBookViewCell.h"
#import "YURLManager.h"
#import "YBookDetailModel.h"
#import "YDateModel.h"
#import "YProgressView.h"
#import "UIImageView+WebCache.h"

@interface YBookViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdate;
@property (weak, nonatomic) IBOutlet UIImageView *updateImage;
@property (weak, nonatomic) IBOutlet UIImageView *stickImageV;
@property (weak, nonatomic) IBOutlet YProgressView *progressView;

@end

@implementation YBookViewCell

- (void)setBook:(Book *)book {
    _book = book;
    

    
     [self.bookImage sd_setImageWithURL:[NSURL URLWithString:book.novel.cover] placeholderImage:[UIImage imageNamed:@"default_book"]];
    
    
    self.titleLabel.text =book.novel.name;
    NSString *updateTime =book.last.timeName;
    self.lastUpdate.text = [updateTime stringByAppendingFormat:@"更新 %@",book.last.name];
    self.updateImage.hidden = !book.last.isNewChapter;
 //   self.stickImageV.hidden = !bookM.hasSticky;
   // self.progressView.loadStatus = bookM.loadStatus;
  //  [self setDownloadBookCallback];
}

//- (void)setDownloadBookCallback {
//    __weak typeof(self) wself = self;
//    self.book.loadProgress = ^(NSUInteger chapter, NSUInteger totalChapters) {
//        wself.progressView.loadStatus = YDownloadStatusLoading;
//        if (totalChapters > 0) {
//            wself.progressView.progress = chapter*1.0/totalChapters;
//        }
//    };
//    
//    self.bookM.loadCompletion = ^ {
//        [wself hideProgressView];
//        [YProgressHUD showErrorHUDWith:[NSString stringWithFormat:@"%@ 已经下载完成",wself.bookM.title]];
//    };
//    
//    self.bookM.loadFailure = ^(NSString *msg) {
//        [wself hideProgressView];
//        [YProgressHUD showErrorHUDWith:[NSString stringWithFormat:@"%@ 下载失败 \n %@",wself.bookM.title,msg]];
//    };
//    
//    self.bookM.loadCancel = ^ {
//        [wself hideProgressView];
//        [YProgressHUD showErrorHUDWith:[NSString stringWithFormat:@"%@ 下载取消",wself.bookM.title]];
//    };
//}

- (void)hideProgressView {
    self.progressView.loadStatus = YDownloadStatusNone;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.progressView setNeedsDisplay];
    });
}

@end
