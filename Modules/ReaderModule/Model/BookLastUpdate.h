//
//  BookLastUpdate.h
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookLastUpdate : ALModel

@property (nonatomic, copy) NSString *siteid;
/**
 *  最后更新时间
 */
@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *timeName;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *oid;

@property (nonatomic, copy) NSString *sign;
/**
 *  最后更新章节名称
 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *url;

@property(nonatomic,assign)BOOL isNewChapter;



@end
