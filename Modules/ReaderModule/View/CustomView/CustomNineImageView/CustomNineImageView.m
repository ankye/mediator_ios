//
//  CustomNineImageView.m
//  testGuoShanChe
//
//  Created by 陈行 on 16/7/13.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CustomNineImageView.h"
#import "UIImageView+WebCache.h"

@interface CustomNineImageView()

@property(nonatomic,strong)NSArray<UIImageView *> * imageViewDataArray;

@property (nonatomic, assign) CGFloat imageHeight;

@property (nonatomic, assign) CGFloat imageWidth;

@property (nonatomic, assign) CGFloat interitemSpace;

@property (nonatomic, assign) CGFloat lineSpace;

@end

@implementation CustomNineImageView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    NSMutableArray * tmpArray = [NSMutableArray new];
    CGFloat size = 80;
    CGFloat space = 8;
    for (int i=0; i<9; i++) {
        CGFloat x = i%3*(size+space);
        CGFloat y = i/3*(size+space);
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, size, size)];
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTouch:)];
        [imageView addGestureRecognizer:tgr];
        [tmpArray addObject:imageView];
        [self addSubview:imageView];
    }
    self.imageViewDataArray=tmpArray;
}

- (void)imageViewTouch:(UITapGestureRecognizer *)tgr{
    NSInteger index = [self.imageViewDataArray indexOfObject:(UIImageView *)tgr.view];
    if (self.imageViewTouch) {
        self.imageViewTouch(self.dataArray,index);
    }
}

- (CGFloat)setDataArray:(NSArray *)dataArray andViewTotalWidth:(CGFloat)totalWidth andWidthHeightAspect:(CGFloat)aspect andInteritemSpace:(CGFloat)interitemSpace andLineSpace:(CGFloat)lineSpace{
    _dataArray=dataArray;
    
    if (dataArray.count==0) {
        [self reloadData];
        return 0;
    }
    
    self.imageWidth=(totalWidth-interitemSpace*2)/3;
    self.imageHeight=self.imageWidth/aspect;
    self.interitemSpace=interitemSpace;
    self.lineSpace=lineSpace;
    [self reloadData];
    NSInteger count = dataArray.count+2;
    return (count/3)*self.imageHeight+(count/3-1)*lineSpace;
}

- (void)reloadData{
    for (int i = 0; i<self.imageViewDataArray.count; i++) {
        UIImageView * imageView =  self.imageViewDataArray[i];
        if (self.dataArray.count>i) {
            imageView.hidden=NO;
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i]]];
            CGFloat x = i%3*(self.imageWidth+self.interitemSpace);
            CGFloat y = i/3*(self.imageHeight+self.lineSpace);
            imageView.frame=CGRectMake(x, y, self.imageWidth, self.imageHeight);
        }else{
            imageView.hidden=YES;
        }
    }
}

+ (CGFloat)heightWithCount:(NSInteger)count andViewTotalWidth:(CGFloat)totalWidth andWidthHeightAspect:(CGFloat)aspect andInteritemSpace:(CGFloat)interitemSpace andLineSpace:(CGFloat)lineSpace{
    if (count==0) {
        return 0;
    }
    CGFloat width = (totalWidth-interitemSpace*2)/3;
    CGFloat height = width/aspect;
    
    count=count+2;
    return (count/3)*height+(count/3-1)*lineSpace;
}

@end
