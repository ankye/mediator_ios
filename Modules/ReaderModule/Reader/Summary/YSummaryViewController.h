//
//  YSummaryViewController.h
//  YReaderDemo
//
//  Created by yanxuewen on 2016/12/18.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "RootViewController.h"
@class YBookSummaryModel,YBookDetailModel;

@interface YSummaryViewController : RootViewController

@property (strong, nonatomic) YBookSummaryModel *summaryM;
@property (strong, nonatomic) YBookDetailModel *bookM;
@property (copy, nonatomic) void(^updateSelectSummary)(YBookSummaryModel *);

@end
