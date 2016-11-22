//
//  ThirdLoginAPI.h
//  XYTV
//
//  Created by huk on 16/1/27.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import "BLTVAPIBase.h"

@interface ThirdLoginAPI : BLTVAPIBase

-(instancetype) init:(NSString *)openid WithToken:(NSString *)token AndType:(NSString *)type;

@end
