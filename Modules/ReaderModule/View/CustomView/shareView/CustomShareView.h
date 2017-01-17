//
//  CustomShareView.h
//  powerlife
//
//  Created by 陈行 on 16/4/19.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenShareHeader.h"

@interface CustomShareView : UIView

@property (nonatomic, copy) NSString * shareUrl;

@property (nonatomic, copy) NSString * shareDesc;

@property(nonatomic,strong)UIImage * shareImage;

+ (instancetype)shareViewWithShareData:(UIImage *)shareData andDesc:(NSString *)shareDesc;

@end
