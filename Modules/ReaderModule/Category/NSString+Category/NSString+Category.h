//
//  NSString+Category.h
//  powerlife
//
//  Created by 陈行 on 16/6/13.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)

/**
 *  把数字转换成带,号的字符串
 *
 *  @param num 1000000
 *
 *  @return 1,000,000
 */
+ (NSString *)stringWithCountNumFormatByInteger:(NSInteger)num;
+ (NSString *)stringWithCountNumFormatByString:(NSString *)num;
+ (NSString *)stringWithCountNumFormatByNumber:(NSNumber *)num;

/**
 *  把一个区间字符串转换  50000.0-100000.0
 *
 *  @param str           50000.0-100000.0
 *  @param sep           分隔符 @"-"
 *  @param num           除以10000
 *  @param decimalDigits 返回的位数2
 *
 *  @return 整合之后的字符串
 */
+ (NSString *)string:(NSString *)str andSeparatedByString:(NSString *)sep andNum:(double)num andDecimalDigits:(NSInteger)decimalDigits;
/**
 *  距离转换为米、公里
 */
+ (NSString *)stringWithDistance:(NSInteger)distance;
/**
 *  url地址判定是否相同，?之前截取
 */
- (BOOL)isEqualURLWithURL:(NSString *)url;
/**
 *  计算高度
 *
 *  @param fontSize 字体大小
 *  @param width    宽度
 *
 *  @return 高度
 */
- (CGFloat)heightWithFontSize:(NSInteger)fontSize andWidth:(CGFloat)width;
/**
 *  计算宽度
 *
 *  @param fontSize 字体大小
 *  @param height   高度
 *
 *  @return 宽度
 */
- (CGFloat)widthWithFontSize:(NSInteger)fontSize andHeight:(CGFloat)height;
/**
 *  md5加密
 */
- (NSString *) md5;
/**
 *  sha1加密
 */
- (NSString *) sha1;
/**
 *  如果是nil转换为null
 */
- (NSString *)nilToNull;
/**
 *  如果nil转换为""
 */
- (NSString *)nilToSpace;
/**
 *  验证是否是邮箱
 *
 *  @return yes or no
 */
- (BOOL)validateEmail;
/**
 *  验证是否是手机号
 *
 *  @return yes or no
 */
- (BOOL) validateMobile;
/**
 *  是否包含表情
 */
- (BOOL)isContainsEmoji;
/**
 *  去掉空的字符串，\r，\n
 */
- (BOOL)isEqualToEmptyStr;

@end
