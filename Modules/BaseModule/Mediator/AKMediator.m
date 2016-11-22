
#import "AKMediator.h"


@interface AKMediator ()

@property (nonatomic, strong) NSMutableDictionary *serviceCache;
@property (nonatomic, strong) NSString* scheme;

@end

@implementation AKMediator

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static AKMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[AKMediator alloc] init];
    });
    return mediator;
}


-(void)updateAppScheme:(NSString*)scheme
{
    self.scheme = scheme;
    
}
/*
 scheme://[target]/[action]?[params]
 
 url sample:
 aaa://targetA/actionB?id=1234
 */

- (id)performRPCService:(NSURL *)url completion:(void (^)(NSDictionary *))completion
{

    if(!self.scheme){
        NSLog(@"Please set APP Scheme use updateAppScheme method !");
        return @(NO);
    }
    if (![url.scheme isEqualToString:self.scheme]) {
        // 这里就是针对远程app调用404的简单处理了，根据不同app的产品经理要求不同，你们可以在这里自己做需要的逻辑
        
        return @(NO);
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:AKMediator_RPC_PREFIX]) {
        return @(NO);
    }
    
    // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self performService:url.host action:actionName params:params shouldCacheService:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performService:(NSString *)serviceName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheService:(BOOL)shouldCacheService
{
    
    NSString *serviceClassString = [NSString stringWithFormat:@"%@%@",AKMediator_Service_PREFIX, serviceName];
    NSString *actionString =[NSString stringWithFormat:@"%@:",actionName];
    
    id service = self.serviceCache[serviceClassString];
    if (service == nil) {
        Class serviceClass = NSClassFromString(serviceClassString);
        service = [[serviceClass alloc] init];
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    if (service == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        return nil;
    }
    
    if (shouldCacheService) {
        self.serviceCache[serviceClassString] = service;
    }
    
    if ([service respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [service performSelector:action withObject:params];
#pragma clang diagnostic pop
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([service respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [service performSelector:action withObject:params];
#pragma clang diagnostic pop
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            [self.serviceCache removeObjectForKey:serviceClassString];
            return nil;
        }
    }
}

- (void)releaseCachedServiceWithName:(NSString *)serviceName
{
    NSString *serviceClassString = [NSString stringWithFormat:@"Service%@", serviceName];
    [self.serviceCache removeObjectForKey:serviceClassString];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceCache
{
    if (_serviceCache == nil) {
        _serviceCache = [[NSMutableDictionary alloc] init];
    }
    return _serviceCache;
}

@end
