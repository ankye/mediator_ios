//
//  UIImage+Category.h
//  powerlife
//
//  Created by 陈行 on 16/7/19.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
/**
 *  水印
 *
 *  @param waterImage 水印图片
 *
 *  @return 加上水印之后的图片
 */
- (instancetype)waterMarkingImageWithWaterImage:(UIImage *)waterImage;
/**
 *  切换图片size
 *
 *  @param newSize 新尺寸
 *
 *  @return 新图片
 */
- (UIImage *)imageWithScaledToSize:(CGSize)newSize;

@end
