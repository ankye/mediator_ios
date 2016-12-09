
#import <Foundation/Foundation.h>

@protocol AKUserLiveProtocol <NSObject>

@property (nonatomic, strong)NSNumber *rz; //认证状态 0 未审核， 1审核中， 2认证通过，3认证失败

@property (nonatomic, strong)NSString *security; //安全码

@property (nonatomic, strong)NSNumber * is_manager; //等于9 是超管

@property (nonatomic, strong)NSNumber * user_tag;//0-普通，1-加v认证， 2-官方号， 3-特殊身份

@property (nonatomic, strong)NSNumber * anchor; //用户类型，1 普通主播 2 签约主播 3官方签约

@property (nonatomic, strong)NSNumber * show_author_type_tag; //0:不显示 1:显示


@end
