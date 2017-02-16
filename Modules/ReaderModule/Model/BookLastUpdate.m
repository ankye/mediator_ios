//
//  BookLastUpdate.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookLastUpdate.h"

@implementation BookLastUpdate

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

-(void)fillData:(id<AKDataObjectProtocol>)object
{
    BookLastUpdate* temp = (BookLastUpdate*)object;
    
    self.siteid = temp.siteid;
    self.time = temp.time;
    self.timeName = temp.timeName;
    self.Id = temp.Id;
    self.oid = temp.oid;
    self.sign = temp.sign;
    self.name = temp.name;
    self.url = temp.url;
    self.isNewChapter = temp.isNewChapter;

}
@end
