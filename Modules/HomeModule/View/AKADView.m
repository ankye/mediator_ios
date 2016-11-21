//
//  AKADView.m
//  Project
//
//  Created by ankye on 2016/11/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKADView.h"

@implementation AKADView


-(id)initWithColor:(UIColor*)color
{
    self = [self init];
    if(self){
        self.backgroundColor = color;
    }
    return self;
}
//横屏大小
-(CGSize)portraitSize
{
    return CGSizeMake(300, 400);
}
//竖屏大小
-(CGSize)landscapeSize
{
    return CGSizeMake(400, 300);
}


-(void)dealloc
{
    
}
@end
