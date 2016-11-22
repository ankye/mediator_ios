//
//  ThirdLoginAPI.h
//  XYTV
//
//  Created by huk on 16/1/27.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "AKBaseRequest.h"

@interface ThirdLoginAPI : AKBaseRequest

-(instancetype) init:(NSString *)openid withToken:(NSString *)token andType:(NSString *)type;

@end
