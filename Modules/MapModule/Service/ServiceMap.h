//
//  ServiceMap.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceMap : NSObject

-(UIViewController*)fetchMapViewController:(NSDictionary *)params;

-(UIView<AKPopupViewProtocol>*)popupUserCardView:(NSDictionary*)params;

@end
