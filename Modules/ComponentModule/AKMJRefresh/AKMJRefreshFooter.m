//
//  AKMJRefreshFooter.m
//  Project
//
//  Created by ankye on 2017/1/9.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKMJRefreshFooter.h"

@implementation AKMJRefreshFooter

-(id)init
{
    self = [super init];
    if(self){
        [self setupLoading];
    }
    return self;
}

-(void)setupLoading
{
    NSArray *idleImages = @[[self.gifImageList firstObject]] ;
    NSArray *pullingImages = self.gifImageList ;
    NSArray *refreshingImages = self.gifImageList ;
    
    [self setImages:idleImages forState:MJRefreshStateIdle];
    [self setImages:pullingImages forState:MJRefreshStatePulling];
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
}



- (NSArray *)gifImageList
{
    if (!_gifImageList)
    {
        NSMutableArray *tempList = [NSMutableArray array] ;
        for (int i = 0; i < TABLE_FOOTER_IMAGES_COUNT; i++)
        {
            UIImage *imgTemp = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",TABLE_FOOTER_IMAGES,i]] ;
            [tempList addObject:imgTemp] ; // DEFAULT MODE IS THIS GIF IMAGES .
        }
        _gifImageList = [NSArray arrayWithArray:tempList] ;
    }
    
    
    return _gifImageList ;
}

@end
