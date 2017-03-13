//
//  NSString+Category.m
//  powerlife
//
//  Created by 陈行 on 16/6/13.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);


@implementation NSString (Category)

+ (NSString *)stringWithCountNumFormatByInteger:(NSInteger)num{
    return [self stringWithCountNumFormatByString:[NSString stringWithFormat:@"%ld",(long)num]];
}

+ (NSString *)stringWithCountNumFormatByString:(NSString *)num{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0){
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

+ (NSString *)stringWithCountNumFormatByNumber:(NSNumber *)num{
    return [self stringWithCountNumFormatByString:[num description]];
}

+ (NSString *)string:(NSString *)str andSeparatedByString:(NSString *)sep andNum:(double)num andDecimalDigits:(NSInteger)decimalDigits{
    
    sep=sep?:@"-";
    num=num?:1;
    
    NSArray * tmpArray = [str componentsSeparatedByString:sep];
    NSMutableString * retStr = [NSMutableString new];
    
    BOOL b=tmpArray.count>1?:false;
    double i1=[tmpArray[0] doubleValue]/num;
    double i2=(b?[tmpArray[1] doubleValue]:0)/num;
    
    if (decimalDigits==0) {
        [retStr appendFormat:@"%ld",(long)i1];
        if (b) {
            [retStr appendFormat:@"-%ld",(long)i2];
        }
    }else if (decimalDigits==1){
        [retStr appendFormat:@"%.1f",i1];
        if (b) {
            [retStr appendFormat:@"-%.1f",i2];
        }
    }else if (decimalDigits==2){
        [retStr appendFormat:@"%.2f",i1];
        if (b) {
            [retStr appendFormat:@"-%.2f",i2];
        }
    }else{
        [retStr appendFormat:@"%f",i1];
        if (b) {
            [retStr appendFormat:@"-%f",i2];
        }
    }
    return retStr;
}

+ (NSString *)stringWithDistance:(NSInteger)distance{
    if (distance<=1000) {
        return [NSString stringWithFormat:@"%ld米",distance];
    }else if(distance<=10*1000){
        return [NSString stringWithFormat:@"%.2f公里",distance/1000.0];
    }else{
        return [NSString stringWithFormat:@"%ld公里",(NSInteger)(distance/1000.0+0.5)];
    }
}

- (BOOL)isEqualURLWithURL:(NSString *)url{
    NSString * urlReq = [[self componentsSeparatedByString:@"?"] firstObject];
    NSString * addComment = [[url componentsSeparatedByString:@"?"] firstObject];
    
    if([urlReq isEqualToString:addComment]){
        return YES;
    }
    return NO;
}

- (CGFloat)heightWithFontSize:(NSInteger)fontSize andWidth:(CGFloat)width{
    
    NSString * text = [NSString stringWithFormat:@"%@",self];
    
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size.height;
}

- (CGFloat)widthWithFontSize:(NSInteger)fontSize andHeight:(CGFloat)height{
    
    NSString * text = [NSString stringWithFormat:@"%@",self];
    
    CGSize size = CGSizeMake(CGFLOAT_MAX, height);
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size.height;
}

- (BOOL)validateEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//手机号码验证
- (BOOL) validateMobile{
    //手机号以3/4/5/7/8 11位
    NSString *phoneRegex = @"^1[3|4|5|7|8]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}















- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)nilToNull{
    if(self && self.length){
        return self;
    }
    return @"Null";
}

- (NSString *)nilToSpace{
    if(self && self.length){
        return self;
    }
    return @"";
}

/*
 *第二种方法，利用Emoji表情最终会被编码成Unicode，因此，
 *只要知道Emoji表情的Unicode编码的范围，
 *就可以判断用户是否输入了Emoji表情。
 */
- (BOOL)isContainsEmoji{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

- (BOOL)isEqualToEmptyStr{
    NSString * encodingStr = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([encodingStr isEqualToString:@"%EF"]) {
        return YES;
    }else if ([encodingStr isEqualToString:@"%BB"]){
        return YES;
    }else if ([encodingStr isEqualToString:@"%BF"]){
        return YES;
    }else if ([encodingStr isEqualToString:@"%0D"]){
        return YES;
    }else if ([encodingStr isEqualToString:@"%EF%BB%BF%0D"]){
        return YES;
    }else if ([encodingStr isEqualToString:@"%EF%BB%BF"]){
        return YES;
    }
    
    return NO;
}
@end
