//
//  TLMessageProtocol.h
//  Project
//
//  Created by ankye on 2016/12/6.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TLMessageProtocol <NSObject>

- (NSString *)messageCopy;

- (NSString *)conversationContent;

@end
