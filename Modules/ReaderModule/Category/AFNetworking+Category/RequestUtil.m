//
//  RequestUtil.m
//  比颜值
//
//  Created by 陈行 on 15-11-19.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "RequestUtil.h"
#import "AFNetworking.h"
#import "NSString+Category.h"
#import "MJExtension.h"
//#import "Setting.h"

#define HMEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@implementation RequestUtil

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShowProgressHud=false;
    }
    return self;
}
/**
 *  自定义请求
 */
- (void)asyncSessionWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andMethod:(RequestMethod)method andTimeoutInterval:(NSInteger)timeoutInterval{
    
    NSURL * url=[NSURL URLWithString:urlString];
    
    NSString * params=[self stringWithParameters:parameters];
    NSData * paramData=[params dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    request.HTTPBody=paramData;
    if(method==RequestMethodPost){
        request.HTTPMethod=@"POST";
    }else{
        request.HTTPMethod=@"GET";
    }
    NSURLSession * session=[NSURLSession sharedSession];
    
    NSURLSessionTask * task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * res=(NSHTTPURLResponse *)response;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(response:andError:andData:andStatusCode:andURLString:)]) {
                [self.delegate response:res andError:error andData:nil andStatusCode:res.statusCode andURLString:urlString];
            }
        });
    }];
    [task resume];
}
/**
 *  第三方普通请求
 */
- (void)asyncThirdLibWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andMethod:(RequestMethod)method andTimeoutInterval:(NSInteger)timeoutInterval{
    
    if(self.isShowProgressHud){
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval=timeoutInterval?:10;
    
    for (NSString * key in [self.headerDict allKeys]) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",self.headerDict[key]] forHTTPHeaderField:key];
    }
    
    
    if(method==RequestMethodPost){
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(self.isShowProgressHud){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            NSHTTPURLResponse * res=(NSHTTPURLResponse *)task.response;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(response:andError:andData:andStatusCode:andURLString:)]) {
                    [self.delegate response:res andError:nil andData:responseObject andStatusCode:res.statusCode andURLString:urlString];
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(self.isShowProgressHud){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            NSHTTPURLResponse * res=(NSHTTPURLResponse *)task.response;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(response:andError:andData:andStatusCode:andURLString:)]) {
                    [self.delegate response:res andError:error andData:nil andStatusCode:res.statusCode andURLString:urlString];
                }
            });
        }];
    }else{
        [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(self.isShowProgressHud){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            NSHTTPURLResponse * res=(NSHTTPURLResponse *)task.response;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(response:andError:andData:andStatusCode:andURLString:)]) {
                    [self.delegate response:res andError:nil andData:responseObject andStatusCode:res.statusCode andURLString:urlString];
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(self.isShowProgressHud){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            NSHTTPURLResponse * res=(NSHTTPURLResponse *)task.response;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(response:andError:andData:andStatusCode:andURLString:)]) {
                    [self.delegate response:res andError:error andData:nil andStatusCode:res.statusCode andURLString:urlString];
                }
            });
        }];
    }
}
/**
 *  上传图片
 */
- (void)uploadImageWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andData:(NSData *)data andTimeoutInterval:(NSInteger)timeoutInterval{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval=timeoutInterval?:10;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:parameters constructingBodyWithBlock:nil error:nil];
    
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    for (NSString * key in [self.headerDict allKeys]) {
        [request setValue:[NSString stringWithFormat:@"%@",self.headerDict[key]] forHTTPHeaderField:key];
    }
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse * res=(NSHTTPURLResponse *)response;
            if ([self.delegate respondsToSelector:@selector(response:andError:andData:andStatusCode:andURLString:)]) {
                [self.delegate response:res andError:error andData:responseObject andStatusCode:res.statusCode andURLString:urlString];
            }
        });
    }];
    [uploadTask resume];
}
/**
 *  上传数据
 */
- (void)uploadDataWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters andTimeoutInterval:(NSInteger)timeoutInterval{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=timeoutInterval?:10;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:parameters constructingBodyWithBlock:nil error:nil];
    
    for (NSString * key in [self.headerDict allKeys]) {
        [request setValue:[NSString stringWithFormat:@"%@",self.headerDict[key]] forHTTPHeaderField:key];
    }
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse * res=(NSHTTPURLResponse *)response;
            if ([self.delegate respondsToSelector:@selector(response:andError:andData:andStatusCode:andURLString:)]) {
                [self.delegate response:res andError:error andData:responseObject andStatusCode:res.statusCode andURLString:urlString];
            }
        });
    }];
    [uploadTask resume];
}

/**
 *  把参数按照key=value&key1=value1的格式进行拼接
 *
 *  @param parameters 参数
 *
 *  @return key=value&key1=value1
 */
- (NSString *)stringWithParameters:(NSDictionary *)parameters{
    int i=0;
    NSMutableString * paramsStr=[NSMutableString string];
    for(NSString * key in [parameters allKeys]){
        if(i!=0){
            [paramsStr appendString:@"&"];
        }
        [paramsStr appendFormat:@"%@=%@",key,parameters[key]];
        i++;
    }
    return paramsStr;
}

+ (NSDictionary *)getParamsWithString:(NSString *)value{
    NSMutableDictionary * dict=[NSMutableDictionary new];
    
    NSArray * array=[value componentsSeparatedByString:@"&"];
    for (NSString * keyValue in array) {
        NSArray * tmpKeyValueArr=[keyValue componentsSeparatedByString:@"="];
        NSString * key=tmpKeyValueArr[0];
        NSString * value=tmpKeyValueArr[1];
        value=value.length?value:@"";
        [dict setObject:value forKey:key];
    }
    return dict;
}

- (void)asyncRongYunWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    NSString * timestamp=[RequestUtil getCurrentTimeStr];
    NSString * nonce = [timestamp sha1];
    NSString * signature = [[NSString stringWithFormat:@"%@%@%@",RongYunSecret,nonce,timestamp] sha1];
    
    [manager.requestSerializer setValue:RongYunAppKey forHTTPHeaderField:@"App-Key"];
    [manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse * res=(NSHTTPURLResponse *)task.response;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(response:andError:andData:andStatusCode:andURLString:)]) {
                [self.delegate response:res andError:nil andData:responseObject andStatusCode:res.statusCode andURLString:urlString];
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * res=(NSHTTPURLResponse *)task.response;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(response:andError:andData:andStatusCode:andURLString:)]) {
                [self.delegate response:res andError:error andData:nil andStatusCode:res.statusCode andURLString:urlString];
            }
        });
    }];
}

+ (NSString *)getCurrentTimeStr{
    NSDate * date=[NSDate date];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [zone secondsFromGMTForDate:date];
    return [NSString stringWithFormat:@"%ld",(long)[[date dateByAddingTimeInterval:time] timeIntervalSince1970]];
}

+ (NSString *)getCurrentTimeDescription{
    NSInteger time = [[self getCurrentTimeStr] integerValue];
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSString * res = [date description];
    return [res substringToIndex:res.length-6];
}

//字典转data
+(NSData *)dataWithDictionary:(NSDictionary *)dict{
    
    NSMutableData * data = [[NSMutableData alloc] init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    for (NSString * key in dict.allKeys) {
        [archiver encodeObject:dict[key] forKey:key];
    }
    [archiver finishEncoding];

    return data;
}

@end
