

#import "AKSignal.h"
#import <objc/runtime.h>
#import <objc/message.h>



@interface AKSignal()
{
    YYThreadSafeArray* _targets;
}
@property (strong, atomic) YYThreadSafeArray* targets;
@end

@implementation AKSignal

-(id)init
{
    if(self = [super init]){
       
        _targets = [[YYThreadSafeArray alloc] init];
     
    }
    
    return self;
}


-(void)dispatch:(NSObject*)responseObject;
{
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        NSDictionary* dic = nil;
        int index = (int)_targets.count;
        for(int i=index -1; i>=0;i--){
            id obj = [_targets objectAtIndex:i];
            
            if( obj && [obj isKindOfClass:[NSDictionary class]]){
                dic = (NSDictionary*)obj;
                AKSignalBlock block = [dic objectForKey:AKSIGNAL_KEY_BLOCK];
                id target = [dic objectForKey:AKSIGNAL_KEY_TARGET_ADDRESS];
                if (block) {
                    block(target,responseObject);
                }else{
#ifdef DEBUG
                    NSAssert(NO, @"no_block");
#endif
                }
                
            }
        }
    });
    

}
-(NSString*)getTargetAddress:(NSObject*)target
{
    return  [NSString stringWithFormat:@"%p",target];
}

-(void)addObserver:(NSObject*)target responseBlock:(AKSignalBlock)responseBlock
{
    NSString* targetAddress = [self getTargetAddress:target];

    NSDictionary* dicTemp = @{AKSIGNAL_KEY_TARGET_ADDRESS:targetAddress,
                              AKSIGNAL_KEY_BLOCK:responseBlock};
    
    
 
    if( [self hasObserver:targetAddress] == NO) {

        [self add_swizzleDealloc:target];
        
    }
    
     [_targets addObject:dicTemp];
    
}



-(BOOL)hasObserver:(NSString*)targetAddress
{
    NSDictionary* dic = nil;
    int index = (int)_targets.count;
    for(int i= index -1 ; i>=0;i--){
        dic = [_targets objectAtIndex:i];
        if(dic){
             if([[dic objectForKey:AKSIGNAL_KEY_TARGET_ADDRESS] isEqualToString:targetAddress]){
                 return YES;
             }
        }
    }
    return NO;
}


-(void)removeObserver:(NSString*)targetAddress
{
 
    NSDictionary* dic = nil;
    int index = (int)_targets.count;
    for(int i= index-1; i>=0;i--){
        dic = [_targets objectAtIndex:i];
        if(dic){
            if([[dic objectForKey:AKSIGNAL_KEY_TARGET_ADDRESS] isEqualToString:targetAddress]){
                [_targets removeObjectAtIndex:i];
            }
        }else{
            [_targets removeObjectAtIndex:i];
        }
    }
  
}


/**
 *  调剂dealloc方法，由于无法直接使用运行时的swizzle方法对dealloc方法进行调剂，所以稍微麻烦一些
 */
- (void)add_swizzleDealloc:(NSObject*)target{
    
    //开始调剂
    Class swizzleClass = [target class];
    @synchronized(swizzleClass) {
        //获取原有的dealloc方法
        SEL deallocSelector = sel_registerName("dealloc");
        //初始化一个函数指针用于保存原有的dealloc方法
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        //实现我们自己的dealloc方法，通过block的方式
        id newDealloc = ^(__unsafe_unretained id objSelf){
            //在这里我们移除所有的KVO
            [self removeObserver:[self getTargetAddress:objSelf]];
            //根据原有的dealloc方法是否存在进行判断
            if (originalDealloc == NULL) {//如果不存在，说明本类没有实现dealloc方法，则需要向父类发送dealloc消息(objc_msgSendSuper)
                //构造objc_msgSendSuper所需要的参数，.receiver为方法的实际调用者，即为类本身，.super_class指向其父类
                struct objc_super superInfo = {
                    .receiver = objSelf,
                    .super_class = class_getSuperclass(swizzleClass)
                };
                //构建objc_msgSendSuper函数
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                //向super发送dealloc消息
                msgSend(&superInfo, deallocSelector);
            }else{//如果存在，表明该类实现了dealloc方法，则直接调用即可
                //调用原有的dealloc方法
                originalDealloc(objSelf, deallocSelector);
            }
        };
        //根据block构建新的dealloc实现IMP
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        //尝试添加新的dealloc方法，如果该类已经复写的dealloc方法则不能添加成功，反之则能够添加成功
        if (!class_addMethod(swizzleClass, deallocSelector, newDeallocIMP, "v@:")) {
            //如果没有添加成功则保存原有的dealloc方法，用于新的dealloc方法中
            Method deallocMethod = class_getInstanceMethod(swizzleClass, deallocSelector);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_getImplementation(deallocMethod);
            originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        
    }
}



@end
