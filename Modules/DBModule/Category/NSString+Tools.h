

#import <Foundation/Foundation.h>

@interface NSString (Tools)

/**
 *  判断字符串是否以某个字符（串）作为开头
 *
 *  @param subString 子字符串
 *
 *  @return YES OR NO
 */
- (BOOL)startWithSubString:(NSString *)subString;



- (NSString *)uppercaseCapitalString;

@end
