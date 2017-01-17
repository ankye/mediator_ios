//
//  RequestUtil.h
//  比颜值
//
//  Created by 陈行 on 15-11-19.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#define RongYunAppKey @"8brlm7ufrhs23"

#define RongYunSecret @"faJSQvMoCiqPw0"

typedef enum RequestMethod{
    RequestMethodGet,//get方式请求
    RequestMethodPost,//post方式请求
}RequestMethod;


@protocol RequestUtilDelegate <NSObject>

@optional
- (void)response:(NSURLResponse *)response andError:(NSError *)error andData:(NSData *)data andStatusCode:(NSInteger)statusCode andURLString:(NSString *)urlString;

@end

@interface RequestUtil : NSObject

@property(nonatomic,assign)BOOL isShowProgressHud;

@property(nonatomic,copy)NSString * progressHudText;

@property (weak, nonatomic) UIView * view;

/**
 *  请求的header参数
 */
@property(nonatomic,strong)NSDictionary * headerDict;

@property(nonatomic,weak)id<RequestUtilDelegate>delegate;

/**
 *  异步请求，第三方库普通请求
 *
 *  @param urlString       url地址
 *  @param parameters      请求参数
 *  @param method          请求方式
 *  @param timeoutInterval 超时时间
 */
- (void)asyncThirdLibWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andMethod:(RequestMethod)method andTimeoutInterval:(NSInteger)timeoutInterval;

/**
 *  新版图片上传
 *
 *  @param urlString       url地址
 *  @param parameters      另带参数
 *  @param data            图片的data数据
 *  @param timeoutInterval 超时时间
 */
- (void)uploadImageWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andData:(NSData *)data andTimeoutInterval:(NSInteger)timeoutInterval;


- (void)uploadDataWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andTimeoutInterval:(NSInteger)timeoutInterval;

/**
 *  第三方库融云
 *
 *  @param urlString  请求地址
 *  @param parameters 参数
 */
- (void)asyncRongYunWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters;

/**
 *  获取当前时间戳的字符串
 *
 *  @return 
 */
+ (NSString *)getCurrentTimeStr;
/**
 *  获取当前时间字符串
 *
 *  @return 
 */
+ (NSString *)getCurrentTimeDescription;

/**
 *  string转字典
 *
 *  @param value key=value & key=value
 *
 *  @return 字典
 */
+ (NSDictionary *)getParamsWithString:(NSString *)value;

@end

