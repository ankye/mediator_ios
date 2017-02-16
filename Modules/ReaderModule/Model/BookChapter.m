//
//  BookChapter.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookChapter.h"
#import "MJExtension.h"


@implementation BookChapter

+ (instancetype)bookChapterWithDict:(NSDictionary *)dict{
    BookChapter * bookChapter = [self mj_objectWithKeyValues:dict];
    
    if (bookChapter.url.length && ![bookChapter.url hasPrefix:@"http"]) {
        bookChapter.url = [bookChapter.url stringByAppendingString:SERVER_URL];
    }
    
    return bookChapter;
}

+ (NSMutableArray *)parsingTextToTextArray:(NSString *)text{
    
    
    //    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    NSString * originalStr = text;
    
    UIFont * font = [UIFont systemFontOfSize:READ_FONT_NUM];
    CGFloat lineHeight = font.lineHeight;
    
    CGSize size = CGSizeMake(WIDTH-32, MAXFLOAT);
    
    //当前能显示的行
    NSInteger maxRow = ((HEIGHT-60)+READ_TEXT_SPACE)/(lineHeight+READ_TEXT_SPACE);
    
    //开始拆解
    //把字符串按段落分开, 提高解析效率
    NSArray *paragraphsArray = [originalStr componentsSeparatedByString:@"\n"];
    
    //记录上一段落剩余的字符串
    NSString * prevParaLastStr = nil;
    //记录是否需要新一个段落
    BOOL isNeedNewStr = false;
    
    NSMutableArray * strArray = [NSMutableArray new];
    for (int i=0; i<paragraphsArray.count; i++) {
//        static NSInteger count = 1;
//        NSLog(@"-------->%ld",count++);
        //开始
        NSString * currStr = nil;
        
//        if (prevParaLastStr) {
//            currStr = prevParaLastStr;
//            if (isNeedNewStr) {
//                if ([paragraphsArray[i] isEqualToEmptyStr]) {
//                    currStr = nil;
//                    continue;
//                }
//                
//                currStr = [currStr stringByAppendingFormat:@"%@\n",paragraphsArray[i]];
//            }
//            
//        }else{
//            currStr = [paragraphsArray objectAtIndex:i];
//            
//            if ([currStr isEqualToEmptyStr]) {
//                currStr = nil;
//                continue;
//            }
//            
//            currStr = [currStr stringByAppendingString:@"\n"];
//        }
        
        CGSize currSize = [currStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        
        NSInteger currRow = currSize.height/lineHeight;
        
        if (currRow == maxRow) {//等于
            [strArray addObject:currStr];
            prevParaLastStr = nil;
            isNeedNewStr = NO;
        }else if (currRow < maxRow){//少于
            if (i+1 == paragraphsArray.count) {//是最后一个
                [strArray addObject:currStr];
            }
            
            prevParaLastStr = currStr;
            isNeedNewStr = YES;
        }else{//多于
            i--;
            isNeedNewStr = NO;
            
            for (int x=1; x<currStr.length; x++) {
                
                NSString * tmpStr = [currStr substringToIndex:x];
                
                CGSize tmpSize = [tmpStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
                
                NSInteger tmpRow = tmpSize.height/lineHeight;
                
                if (tmpRow > maxRow) {
                    [strArray addObject:[tmpStr substringToIndex:x-1]];
                    prevParaLastStr = [currStr substringFromIndex:x-1];
                    break;
                }
            }
        }
    }
    return strArray;
}

@end
