//
//  ServieLogin.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceLogin : NSObject

-(UIViewController*)fetchLoginViewController:(NSDictionary *)params;

-(UIViewController*)fetchRegisterViewController:(NSDictionary *)params;


@end
