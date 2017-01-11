//
//  AKCollectionWaterFallLayout.m
//  Project
//
//  Created by ankye on 2017/1/9.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKCollectionLayout.h"

@implementation AKCollectionLayout

-(id)init
{
    self = [super init];
    if(self){
        [self configLayout];
        
    }
    return self;
}

-(void)configLayout
{
    self.headerHeight = 0;            // headerView高度
    self.footerHeight = 0;             // footerView高度
    self.columnCount  = 1;             // 几列显示
    self.minimumColumnSpacing    = 0;  // cell之间的水平间距
    self.minimumInteritemSpacing = 8; // cell之间的垂直间距
    self.sectionInset = UIEdgeInsetsMake(6, 10, 10, 10);
}

@end
