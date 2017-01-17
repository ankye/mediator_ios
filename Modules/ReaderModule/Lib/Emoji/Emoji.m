//
//  Emoji.m
//  Emoji
//
//  Created by Aliksandr Andrashuk on 26.10.12.
//  Copyright (c) 2012 Aliksandr Andrashuk. All rights reserved.
//

#import "Emoji.h"
#import "EmojiEmoticons.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"

@implementation Emoji
+ (NSString *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}
+ (NSArray *)allEmoji {
    NSLog(@"-------->%s",[@"🍵" UTF8String]);
    
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[EmojiEmoticons allEmoticons]];
    [array addObjectsFromArray:[EmojiMapSymbols allMapSymbols]];
    [array addObjectsFromArray:[EmojiPictographs allPictographs]];
    [array addObjectsFromArray:[EmojiTransport allTransport]];
    NSLog(@"-------->%ld",array.count);
    NSLog(@"-------->%ld",[array description].length);
    
    NSString * value;
    NSDate * date=[NSDate date];//起始时间
    
    for (NSString * string in array) {
        if([@"🍵" isEqualToString:string ]){
            value=string;
        }
    }
    
    NSTimeInterval time=[date timeIntervalSinceNow];//结束时间
    NSLog(@"time-->%f---->%@",time,value);//打印日志
    if (value) {
        NSLog(@"-------->%s",[value UTF8String]);
    }
    return array;
}
@end
