//
//  BookEveryUrl.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookEveryUrl.h"

@implementation BookEveryUrl

-(void)fillData:(id<AKDataObjectProtocol>)object
{
    
    BookEveryUrl* temp = (BookEveryUrl*)object;
    self.dir = temp.dir;
    self.readend = temp.readend;
    self.comment = temp.comment;
    self.down = temp.down;
    self.chapterlist = temp.chapterlist;
    self.vote = temp.vote;
    self.addmark = temp.addmark;
    self.first = temp.first;
    self.info = temp.info;
}
@end
