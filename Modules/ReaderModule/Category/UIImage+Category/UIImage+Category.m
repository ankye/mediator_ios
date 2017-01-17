//
//  UIImage+Category.m
//  powerlife
//
//  Created by 陈行 on 16/7/19.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

- (instancetype)waterMarkingImageWithWaterImage:(UIImage *)waterImage{
    
    return self;
//    //定义一张画布只有宽度和高度
//    CGSize size = self.size;
//    UIGraphicsBeginImageContext(size);
//    
//    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    //水印印在图片上的位置，
//    CGFloat ratio = size.width/WIDTH;
//    CGFloat width = waterImage.size.width*ratio;
//    CGFloat height = waterImage.size.height*ratio;
//    CGSize waterSize = CGSizeMake(width,height);
//    CGRect frame = CGRectMake(size.width-waterSize.width, size.height-waterSize.height, waterSize.width, waterSize.height);
//    [waterImage drawInRect:frame];
//    
//    //获取当前的image对象
//    UIImage * tmpImage = UIGraphicsGetImageFromCurrentImageContext();
//    //关闭当前画布
//    UIGraphicsEndImageContext();
//    return tmpImage;
}

- (UIImage *)imageWithScaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
