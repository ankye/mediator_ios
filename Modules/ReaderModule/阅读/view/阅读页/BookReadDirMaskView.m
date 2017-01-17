//
//  DirMaskView.m
//  quread
//
//  Created by 陈行 on 16/11/1.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "BookReadDirMaskView.h"
#import "UIView+Category.h"

@implementation BookReadDirMaskView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.userInteractionEnabled = YES;
    
    [self.reGetDataBtn layoutCornerRadiusWithCornerRadius:4];
}

@end
