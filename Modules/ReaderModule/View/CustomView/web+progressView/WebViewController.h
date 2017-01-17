//
//  WebViewController.h
//  DesignBook
//
//  Created by 陈行 on 16-1-1.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property(nonatomic,copy)NSString * requestUrl;
/**
 *  当前controller显示的titleName,为空则显示url的title
 */
@property(nonatomic,copy)NSString * titleName;
/**
 *  分享的图片
 */
@property(nonatomic,strong)UIImage * shareImage;
/**
 *  副标
 */
@property (nonatomic, copy) NSString *shareDesc;

/**
 *  默认为false不隐藏
 */
@property(nonatomic,assign)BOOL isHiddenShare;

@end
