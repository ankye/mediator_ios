//
//  XHSHomeModel.m
//  小红书
//
//  Created by Aesthetic92 on 16/7/9.
//  Copyright © 2016年 Aesthetic92. All rights reserved.
//

#import "XHSHomeModel.h"
#import <MJExtension.h>

@implementation XHSHomeModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             
                @"url" : @"images_list[0].url",
                @"height" : @"images_list[0].height",
                @"width" : @"images_list[0].width",
                @"nickname" : @"user.nickname",
                @"images" : @"user.images"

             };
};



-(CGSize)scaleSize{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = width / [self.width floatValue];
    CGFloat height = [self.height floatValue] * scale;
    
    return CGSizeMake(width, height);
}


@end
