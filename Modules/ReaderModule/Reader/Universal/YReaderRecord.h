//
//  YReaderRecord.h
//  YReaderDemo
//
//  Created by yanxuewen on 2016/12/13.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "YBookSummaryModel.h"

@interface YReaderRecord : AKBaseModel

@property (assign, nonatomic) NSUInteger readingChapter;
@property (assign, nonatomic) NSUInteger readingPage;
@property (strong, nonatomic) NSArray *chaptersLink;

@end
