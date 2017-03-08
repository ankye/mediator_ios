//
//  YProgressView.h
//  YReaderDemo
//
//  Created by yanxuewen on 2016/12/20.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YDownloadStatus) {
    YDownloadStatusNone,
    YDownloadStatusWait,
    YDownloadStatusLoading,
    YDownloadStatusCancel
};

@interface YProgressView : UIView

@property (assign, nonatomic) YDownloadStatus loadStatus;
@property (assign, nonatomic) double progress;

@end
