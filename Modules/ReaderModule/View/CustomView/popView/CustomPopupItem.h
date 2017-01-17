//
//  Popup.h
//  PopupViewStudy
//
//  Created by caiqiujun on 15/12/29.
//  Copyright © 2015年 caiqiujun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomPopupItem : NSObject

// 标题
@property (nonatomic, strong)NSString *title;
// 消息内容
@property (nonatomic, strong)NSString *msgContent;
// 确认按钮内容
@property (nonatomic, strong)NSString *btnContet;

- (instancetype)initWithTitle:(NSString*)title msg:(NSString*)msg btnContent:(NSString*)btnContent;

@end
