//
//  CustomNineImageView.h
//  testGuoShanChe
//
//  Created by 陈行 on 16/7/13.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomNineImageView : UIView

//@property (nonatomic, assign) CGFloat viewHeight;

//@property (nonatomic, copy) NSString *key;

@property(nonatomic,copy)void (^imageViewTouch)(NSArray * dataArray,NSInteger index);

@property(nonatomic,strong,readonly)NSArray * dataArray;

- (CGFloat)setDataArray:(NSArray *)dataArray andViewTotalWidth:(CGFloat)totalWidth andWidthHeightAspect:(CGFloat)aspect andInteritemSpace:(CGFloat)interitemSpace andLineSpace:(CGFloat)lineSpace;

+ (CGFloat)heightWithCount:(NSInteger)count andViewTotalWidth:(CGFloat)totalWidth andWidthHeightAspect:(CGFloat)aspect andInteritemSpace:(CGFloat)interitemSpace andLineSpace:(CGFloat)lineSpace;

@end
