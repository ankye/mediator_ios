//
//  BookAuthor.m
//  quread
//
//  Created by 陈行 on 16/10/29.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookAuthor.h"

@implementation BookAuthor

-(void)fillData:(id<AKDataObjectProtocol>)object
{
    BookAuthor* temp = (BookAuthor*)object;
    
    self.name = temp.name;
    self.url = temp.url;
}
@end
