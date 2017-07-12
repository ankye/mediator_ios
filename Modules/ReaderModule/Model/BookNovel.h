//
//  BookNovel.h
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookNovel : ALModel

@property (nonatomic, copy) NSString *pinyin;

@property (nonatomic, copy) NSString *caption;

@property (nonatomic, copy) NSString *isgood;

@property (nonatomic, copy) NSString *Id;
/**
 *  状态
 */
@property (nonatomic, copy) NSString *status;
/**
 *  是否完本？
 */
@property (nonatomic, copy) NSString *isover;
/**
 *  小说介绍
 */
@property (nonatomic, copy) NSString *intro;
/**
 *  高度
 */
@property (nonatomic, assign) CGFloat introHeight;
/**
 *  封面图
 */
@property (nonatomic, copy) NSString *cover;
/**
 *  更新时间？
 */
@property (nonatomic, copy) NSString *postdate;
/**
 *  小说名称
 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *initial;

@end
