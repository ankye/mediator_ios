//
//  BookNovel.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookNovel.h"
#import "MJExtension.h"

@implementation BookNovel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

-(void)fillData:(id<AKDataObjectProtocol>)object
{
    BookNovel* temp = (BookNovel*)object;
    self.pinyin = temp.pinyin;
    self.caption = temp.caption;
    self.isgood = temp.isgood;
    self.Id = temp.Id;
    self.status = temp.status;
    self.isover = temp.isover;
    self.intro = temp.intro;
    self.introHeight = temp.introHeight;
    self.cover = temp.cover;
    self.postdate = temp.postdate;
    self.name = temp.name;
    self.initial = temp.initial;
}
@end
