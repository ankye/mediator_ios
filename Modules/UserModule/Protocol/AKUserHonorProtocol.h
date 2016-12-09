
#import <Foundation/Foundation.h>

@protocol AKUserHonorProtocol <NSObject>

//VIP等级
@property (nonatomic, strong)NSNumber *viplevel;
//下一级所需经验
@property (strong, nonatomic)NSNumber * after_noble_exp;
//当前等级经验
@property (strong, nonatomic)NSNumber * before_noble_exp;
//当前经验
@property (strong, nonatomic)NSNumber * noble_exp;
//下等级开始经验 0.2；
@property (strong, nonatomic)NSString * upgrade_progress;
//个人勋章 为空表示无
@property (copy, nonatomic)NSString * medal_id;



@end
