//
//  CustomSliderView.m
//  电动生活
//
//  Created by 陈行 on 15-12-15.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CustomSliderView.h"

@interface CustomSliderView()



@end

@implementation CustomSliderView

+ (instancetype)sliderViewWithItems:(NSArray *)items andFrame:(CGRect)frame{
    return [[self alloc]initWithItems:items andFrame:frame];
}
- (instancetype)initWithItems:(NSArray *)items andFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self.backgroundColor=[UIColor whiteColor];
        self.items=items;
        [self createHorizontalLine];
        self.showsHorizontalScrollIndicator=NO;
    }
    return self;
}

- (void)setItems:(NSArray *)items{
    _items=items;
    int index=0;
    NSMutableArray * array=[[NSMutableArray alloc]init];
    NSInteger count = items.count<5?items.count:5;
    CGFloat width = self.frame.size.width/count;
    self.btnWidth=width;
    if (items.count>5) {
        self.contentSize=CGSizeMake(width*items.count, 0);
    }
    for (NSString * title in items) {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [array addObject:btn];
        btn.frame=CGRectMake(width*index, 0, width-1, self.frame.size.height-4);
        btn.tag=index;
        [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:0.255 alpha:1.000] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont systemFontOfSize:16];
        index++;
    }//for end
    _btnArray=array;
    [self setSelectedBtn:0];
}

- (void)btnTouch:(UIButton *)btn{
    [self setSelectedBtn:btn.tag];
    [self.sliderViewDelegate sliderView:self andIndex:btn.tag andBtnArray:self.btnArray];
}

- (void)createHorizontalLine{
    NSInteger count = self.items.count<5?self.items.count:5;
    CGFloat width = self.frame.size.width/count;
    
    UIView * hl=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-2, width, 2)];
    [self addSubview:hl];
    hl.backgroundColor=[UIColor orangeColor];
    self.horiLine=hl;
}

- (void)setSelectedBtn:(NSInteger)index{
    for (UIButton * btn in self.btnArray) {
        if(btn.tag==index){
            btn.selected=YES;
        }else{
            btn.selected=NO;
        }
    }
    CGRect rect=self.horiLine.frame;
    rect.origin.x=self.horiLine.frame.size.width*index;
    self.horiLine.frame=rect;
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor{
    _normalTitleColor=normalTitleColor;
    for (UIButton * btn in self.btnArray) {
        [btn setTitleColor:normalTitleColor forState:UIControlStateNormal];
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    _selectedTitleColor=selectedTitleColor;
    for (UIButton * btn in self.btnArray) {
        [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
}

@end
