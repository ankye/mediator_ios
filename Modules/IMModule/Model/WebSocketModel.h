//
//  SocketWsURL.h
//  XYTV
//
//  Created by luanys on 16/1/22.
//  Copyright © 2016年 luanys. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebSocketModel : NSObject

@property (strong, nonatomic) NSString * baseWsUrl;

@property (strong, nonatomic) NSString * uid;//可选，默认自动创建

@property (strong, nonatomic) NSString * room_uid;//可选房间id，默认(移动端，统一为0)

@property (strong, nonatomic) NSString * time;

@property (strong, nonatomic) NSString * token;//

//-(NSString *)getWS_URL;
@end
