//
//  HBRequestManager.m
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBRequestManager.h"

#pragma mark - RequestURL
static NSString *const kBaseRequestURL = @"http://c.ggzxc.com.cn/wz";
static NSString *const kNearBicycleRequestURL = @"np_getBikesByWeiXin.do";
static NSString *const kBicycleSearchURL = @"np_findNetPointByName.do";

#pragma mark - Requests
@implementation HBBaseRequest

-(YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}

- (id)requestArgument {
    return self.requestArguments;
}

@end

@implementation HBNearBicycleRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return kNearBicycleRequestURL;
}

@end

@implementation HBBicycleSearchReqeust
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return kBicycleSearchURL;
}

@end


#pragma mark - RequestManager
@implementation HBRequestManager

+ (void)config {
    [self setBaseURL:kBaseRequestURL];
}

+ (instancetype)sharedManager {
    static HBRequestManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[HBRequestManager alloc] init];
    });
    return _manager;
}

#pragma mark - Public Method
+ (void)setBaseURL:(NSString *)baseURL {
    [[YTKNetworkConfig sharedConfig] setBaseUrl:baseURL];
}

#pragma mark - SendRequest
+ (void)sendNearBicycleRequestWithLatitude:(NSNumber *)lat
                                longtitude:(NSNumber *)lon
                                    length:(NSNumber *)len
                         successJsonObject:(void (^)(NSDictionary *))success
                         failureCompletion:(YTKRequestCompletionBlock)failure {
    HBNearBicycleRequest *nearBicycleRequest =  [[HBNearBicycleRequest alloc] init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
   // [params setObject:lon forKey:@"lng"];
   // [params setObject:lat forKey:@"lat"];
 
    [params setObject:len forKey:@"len"];
    nearBicycleRequest.requestArguments = params;
    [nearBicycleRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
     //   [HBHUDManager dismissWaitProgress];
        NSData *resposneData = request.responseData;
        NSDictionary* result = [HBRequestManager dictionaryWithData:resposneData];
        success(result);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
       // [HBHUDManager showNetworkError];
        failure(request);
    }];
}

+ (NSDictionary *)dictionaryWithData:(NSData *)data;
{
    NSError *error;
//    {"count":10,"data":[{"address":"劳动路西湖大道口","areaname":"城南","bikenum":"18","createTime":1479728345967,"guardType":"无人值守","id":23322,"lat":"30.251588","len":"60","lon":"120.169314","name":"劳动路口","number":"1004","rentcount":"2","restorecount":"16","serviceType":"06:00-24:00","sort":0,"stationPhone":"(7:00-19:00)|13486377916","stationPhone2":"(19:00-24:00)|13606517486","useflag":"正常"},{"address":"西湖大道262号","areaname":"城南","bikenum":"32","createTime":1479728345967,"guardType":"无人值守","id":23511,"lat":"30.251814","len":"84","lon":"120.169445","name":"涌金广场","number":"1266","rentcount":"7","restorecount":"25","serviceType":"06:00-24:00","sort":0,"stationPhone":"(7:00-19:00)|13486377916","stationPhone2":"(19:00-24:00)|13606517486","useflag":"正常"},{"address":"中国民生银行前","areaname":"城南","bikenum":"21","createTime":1479728345967,"guardType":"无人值守","id":23451,"lat":"30.251647","len":"145","lon":"120.170815","name":"延安路一百二十七号","number":"1174","rentcount":"4","restorecount":"17","serviceType":"06:00-24:00","sort":0,"stationPhone":"(7:00-19:00)|13486377916","stationPhone2":"(19:00-24:00)|13606517486","useflag":"正常"},{"address":"劳动路123-4号前","areaname":"城南","bikenum":"22","createTime":1479728345967,"guardType":"无人值守","id":23535,"lat":"30.249685","len":"156","lon":"120.169126","name":"涌金饭店","number":"1294","rentcount":"2","restorecount":"20","serviceType":"06:00-24:00","sort":0,"stationPhone":"(7:00-19:00)|13486377786","stationPhone2":"(19:00-24:00)|13606517486","useflag":"正常"},{"address":"劳动路126号(劳动路嘉和里路口)","areaname":"城南","bikenum":"10","createTime":1479728345967,"guardType":"无人值守","id":23349,"lat":"30.249564","len":"168","lon":"120.169212","name":"嘉和里路口","number":"1039","rentcount":"3","restorecount":"8","serviceType":"06:00-24:00","sort":0,"stationPhone":"(7:00-19:00)|13486377786","stationPhone2":"(19:00-24:00)|13606517486","useflag":"正常"},{"address":"西湖大道南山路口北侧","areaname":"城南","bikenum":"11","createTime":1479728345967,"guardType":"无人值守","id":23321,"lat":"30.251826","len":"169","lon":"120.167936","name":"西湖大道","number":"1003","rentcount":"0","restorecount":"11","serviceType":"06:00-24:00","sort":0,"stationPhone":"(7:00-19:00)|13486377916","stationPhone2":"(19:00-24:00)|13606517486","useflag":"正常"},{"address":"西湖大道252号浦发银行","areaname":"城南","bikenum":"11","createTime":1479728345967,"guardType":"无人值守","id":23510,"lat":"30.251889","len":"170","lon":"120.17095","name":"西湖大道二百五十二号","number":"1265","rentcount":"3","restorecount":"9","serviceType":"06:00-24:00","sort":0,"stationPhone":"(7:00-19:00)|13486377916","stationPhone2":"(19:00-24:00)|13606517486","useflag":"正常"},{"address":"延安路西湖大道东北角（薇薇新娘）","areaname":"城南","bikenum":"21","createTime":1479728345967,"guardType":"无人值守","id":23520,"lat":"30.251818","len":"193","lon":"120.171264","name":"延安路一百七十六号","number":"1275","rentcount":"5","restorecount":"16","serviceType":"06:00-24:00","sort":0,"stationPhone":"(7:00-19:00)|13486377916","stationPhone2":"(19:00-24:00)|13606517486","useflag":"正常"},{"address":"西湖大道南山路东北角","areaname":"城南","bikenum":"22","createTime":1479728345967,"guardType":"无人值守","id":23615,"lat":"30.251818","len":"212","lon":"120.167429","name":"西湖大道298号","number":"1381","rentcount":"11","restorecount":"38","serviceType":"06:00-24:00","sort":0,"stationPhone":"(7:00-19:00)|13486377916","stationPhone2":"(19:00-24:00)|13606517486","useflag":"正常"},{"address":"涌金广场花园餐厅北侧","areaname":"城南","bikenum":"15","createTime":1479728345967,"guardType":"有人值守","id":23335,"lat":"30.251272","len":"243","lon":"120.166939","name":"涌金广场","number":"1019","rentcount":"12","restorecount":"3","serviceType":"0:00-24:00","sort":0,"stationPhone":"(7:00-19:00)|13486377681","stationPhone2":"(19:00-24:00)|13606517486","useflag":"正常"}]}
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        return result;
    }
    return nil;
}


+ (void)sendSearchBicycleStationRequestWithOptions:(NSString *)option
                                 successJsonObject:(void(^)(NSDictionary *jsonDict))success
                                 failureCompletion:(YTKRequestCompletionBlock)failure {
    //显示网络加载
   // [HBHUDManager showWaitProgress];
    HBBicycleSearchReqeust *searchRequest = [[HBBicycleSearchReqeust alloc] init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:option forKey:@"option"];
    searchRequest.requestArguments = params;
    [searchRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        //结束加载状态
      //  [HBHUDManager dismissWaitProgress];
        NSData *resposneData = request.responseData;
        NSDictionary* result = [HBRequestManager dictionaryWithData:resposneData];
        success(result);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

      //  [HBHUDManager showNetworkError];
        failure(request);
    }];
}
@end
