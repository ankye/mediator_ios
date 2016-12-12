//
//  AKMediator+MapModule.h
//  Project
//
//  Created by ankye on 2016/11/18.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKMediator (MapModule)

//获取注册controller
- (UIViewController *)map_viewController;



-(UIView<AKPopupViewProtocol>*)map_popUserCardView:(AKUser*)user;



@end
