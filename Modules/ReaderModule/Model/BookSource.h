//
//  BookSource.h
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookSource : ALModel

@property (nonatomic, copy) NSString *orderid;

@property (nonatomic, copy) NSString *sitekey;

@property (nonatomic, copy) NSString *sitehost;

@property (nonatomic, copy) NSString *siteurl;

@property (nonatomic, copy) NSString *siteid;

@property (nonatomic, copy) NSString *sitename;

@end
