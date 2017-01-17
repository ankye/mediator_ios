//
//  ReaderModule.h
//  Project
//
//  Created by ankye on 2017/1/13.
//  Copyright © 2017年 ankye. All rights reserved.
//

#ifndef ReaderModule_h
#define ReaderModule_h


#import "AKRequestManager+ReaderModule.h"


//
//  MyPch.pch
//  电动生活
//
//  Created by 陈行 on 15-12-15.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "InitialData.h"
#import "AKReaderManager.h"

/**
 *  屏幕宽
 */
#define WIDTH [UIScreen mainScreen].bounds.size.width
/**
 *  屏幕高
 */
#define HEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *  像素点，显示1像素的大小
 */
#define SINGLE_LINE_WIDTH (1 / [UIScreen mainScreen].scale)

/**
 *  AppKey
 */
#define KUMengKey @""

/**
 *  服务器URL
 */

#define SERVER_URL @"http://privateapi.biqugeapp.cc"

#pragma mark - URL_接口

/**
 *  获取热门小说列表
 */
#define URL_GET_HOT_NOTE_LIST (SERVER_URL@"/api/novel/list.json?order=allvisit&sort=desc&isgood=1&pagesize=20&page=%ld")

/**
 *  获取小说目录信息
 */
#define URL_GET_NOVEL_DIR (SERVER_URL@"/api/novel/dir.json?novelid=%@&siteid=%@")

/**
 *  获取收藏的书的最后更新
 *  novelids=4102,1763,4331,1457,991,1500,68203,68205
 */
#define URL_GET_BOOKCASE_LAST_LIST (SERVER_URL@"/api/novel/multi.json")

/**
 *  小说搜索
 */
#define URL_GET_SEARCH_NOVEL_LIST (SERVER_URL@"/api/novel/list.json?pagesize=20&searchtype=name&searchkey=%@&page=%ld")

/**
 *  小说分类
 */
#define URL_GET_BOOK_CATEGORY (SERVER_URL@"/api/novel/category.json")
/**
 *  根据分类获取小说列表
 */
#define URL_GET_BOOKNOVEL_BY_CATEGORY (SERVER_URL@"/api/novel/list.json?order=allvisit&sort=desc&pagesize=20&category=%@&page=%ld")
/**
 *  获取书单列表
 */
#define URL_GET_BOOKDOCUMENT_LIST (SERVER_URL@"/api/booklist/list.json?order=view_num&sort=desc&page=%ld")
/**
 *  获取书单详情
 */
#define URL_GET_BOOKDOCUMENT_DETAIL (SERVER_URL@"/api/booklist/detail.json?id=%@")

#pragma mark - SQL语句


#pragma mark - 主题颜色

#define THEME_COLOR [UIColor colorWithRed:0.235 green:0.694 blue:1.000 alpha:1.000]

#define LIGHT_GRAY_COLOR [UIColor colorWithRed:114/255.0 green:119/255.0 blue:123/255.0 alpha:1]

#pragma mark - 沙盒文件
/**
 *  小说缓存位置，后边拼接     /小说的id值/小说url md5加密
 */
#define FILEPATH_BOOK_NOVEL_PATH [NSString stringWithFormat:@"%@/Documents/novel/",NSHomeDirectory()]

//#define FILEPATH_HOME_DIRECTORY [NSString stringWithFormat:@"%@",NSHomeDirectory()]

#pragma mark - InitialData

#define READ_BACKGROUND_COLOR [InitialData sharedInitialData].readBackgroundColor
#define READ_FONT_NUM [InitialData sharedInitialData].readFontNum
#define READ_TEXT_SPACE [InitialData sharedInitialData].readTextSpace

#pragma mark - 常用变量

#define FINAL_DATA_REQUEST_FAIL @"请求失败，请检查网络连接！"
#define FINAL_EMPTY_VALUE_PROMPT_INFO @"暂未获取到此章节内容数据！"
#define FINAL_PROMPT_INFOMATION @"提示信息"

/**
 *  图片QUALITY
 */
#define IMAGE_COMPRESS_QUALITY 0.9
/**
 *  图片上传QUALITY
 */
#define IMAGE_COMPRESS_QUALITY_UPLOAD 0.5
/**
 *  动画时间
 */
#define ANIMATION_TIME_INTERVAL 0.2
/**
 *  分页大小，以1000为单位进行分页查询
 */
#define DATA_PAGE_SIZE 1000l

#define DATA_PAGE_SIZE_20 20l

#define DATA_PAGE_SIZE_10 10l

/**
 *  请求数据超时时间
 */
#define TIMEOUT_INTERVAL_REQUEST 10
/**
 *  数据上传的超时时间
 */
#define TIMEOUT_INTERVAL_UPLOAD_DATA 20

/**
 *  打印，log日志，打印所有-->
 *  NSLog(__VA_ARGS__);
 *  printf("LOG:%s\n",[[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
 */
#pragma mark - 打印，log日志，打印所有

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__);
#else
# define NSLog(...)
#endif

#endif /* ReaderModule_h */
