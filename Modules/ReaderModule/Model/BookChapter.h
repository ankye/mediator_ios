//
//  BookChapter.h
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookChapter : NSObject
/**
 *  id值
 */
@property (nonatomic, copy) NSString *Id;
/**
 *  章节名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  上传时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  章节下载url
 */
@property (nonatomic, copy) NSString *url;
/**
 *  是否缓存
 */
@property(nonatomic,assign)BOOL isTmp;
/**
 *  章节内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  章节内容拆分array
 */
@property(nonatomic,strong)NSMutableArray * textDataArray;

+ (instancetype)bookChapterWithDict:(NSDictionary *)dict;

+ (NSMutableArray *)parsingTextToTextArray:(NSString *)text;

@end
