

#import <Foundation/Foundation.h>
#import "BaseModuleDefine.h"

#define AKMediator_RPC_PREFIX @"app"

#define AKMediator_Service_PREFIX @"Service"

#define AK_MEDIATOR [AKMediator sharedInstance]

@interface AKMediator : NSObject

SINGLETON_INTR(AKMediator)

-(void)updateAppScheme:(NSString*)scheme;

// 远程App调用入口
- (id)performRPCService:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;
// 本地组件调用入口
- (id)performService:(NSString *)serviceName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheService:(BOOL)shouldCacheService;
- (void)releaseCachedServiceWithName:(NSString *)serviceName;

@end
