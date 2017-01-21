//
//  MusicModel.h
//  test
//
//  Created by chuanshuangzhang chuan shuang on 16/2/23.
//  Copyright © 2016年 chuanshuangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDownloadTask.h"



@interface MusicModel : NSObject

@property (nonatomic , strong) NSString *downLoadUrl;

@property (nonatomic , strong) NSString *imgName;

@property (nonatomic , strong) NSString *name;

@property (nonatomic , strong) NSString *desc;

@property (nonatomic , strong) NSString *mpDownLoadPath;

@property (nonatomic,strong) NSString *group;

@property (nonatomic , assign) CGFloat progress;

@property (nonatomic,weak) HSDownloadTask *task;

@end
