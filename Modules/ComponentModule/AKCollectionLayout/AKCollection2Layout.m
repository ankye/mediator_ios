//
//  AKCollection2Layout.m
//  Project
//
//  Created by ankye on 2017/1/10.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import "AKCollection2Layout.h"

@implementation AKCollection2Layout

-(void)configLayout
{
    self.headerHeight = 0;            // headerView高度
    self.footerHeight = 0;             // footerView高度
    self.columnCount  = 2;             // 几列显示
    self.minimumColumnSpacing    = 10;  // cell之间的水平间距
    self.minimumInteritemSpacing = 8; // cell之间的垂直间距
    self.sectionInset = UIEdgeInsetsMake(6, 10, 10, 10);
}

@end
