//
//  CustomChooseCityView.m
//  testPickView
//
//  Created by 陈行 on 16-1-16.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CustomChooseCityView.h"


#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define TITLE_KEY @"title"

#define DATAARRAY_KEY @"cities"

@interface CustomChooseCityView()<CustomPickViewDelegate>

@property(nonatomic,weak)CustomPickView * pickView;

@property(nonatomic,copy)NSString * titleKey;

@property(nonatomic,copy)NSString * dataArrayKey;

@end

@implementation CustomChooseCityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CustomPickView * pv = [CustomPickView customPickViewWithDataArray:self.cityDataArray andComponent:3 andIsDependPre:YES andFrame:self.bounds];
            pv.titleKey=TITLE_KEY;
            pv.dataArrayKey=@[DATAARRAY_KEY,DATAARRAY_KEY];
        
        pv.delegate=self;
        [self addSubview:pv];
        self.pickView=pv;
    }
    return self;
}

- (void)showPickView{
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.transform=CGAffineTransformIdentity;
    }];
    self.pickView.hidden = NO;
}

- (void)hiddenPickView{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform=CGAffineTransformTranslate(self.transform, 0, SCREENHEIGHT);
    }];
    self.pickView.hidden = YES;
}

#pragma mark - CustomPickView协议代理
- (void)customPickViewCancleTouch:(CustomPickView *)customPickView{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform=CGAffineTransformTranslate(self.transform, 0, SCREENHEIGHT);
    }];
}

- (void)customPickView:(CustomPickView *)customPickView andSelectedArray:(NSArray *)selectedArray andDataArray:(NSArray *)dataArray{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform=CGAffineTransformTranslate(self.transform, 0, SCREENHEIGHT);
    }];
    NSMutableString * str=[NSMutableString new];
    NSArray * currentArray=dataArray;
    for (int i=0; i<selectedArray.count; i++) {
        if(currentArray.count){
            NSInteger index=[selectedArray[i] integerValue];
            CustomChooseCityModel * model = currentArray[index];
            [str appendFormat:@"%@ ",model.title];
            currentArray=model.cities;
        }
    }
    [self.delegate customChooseCityViewAndSelectedArray:selectedArray andDataArray:dataArray andValue:[str substringToIndex:str.length-1]];
}

- (NSArray *)cityDataArray{
    if (_cityDataArray==nil) {
        NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        NSMutableArray * dataArray=[NSMutableArray new];
        for (NSDictionary * dict in array) {
            [dataArray addObject:[CustomChooseCityModel customChooseCityModel:dict]];
        }
        _cityDataArray=dataArray;
    }
    return _cityDataArray;
}

- (void)dealloc{
    NSLog(@"ChooseCity销毁");
}

@end
