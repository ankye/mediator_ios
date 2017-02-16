//
//  CustomTremblingView.m
//  testGuoShanChe
//
//  Created by 陈行 on 16/8/5.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CustomTremblingView.h"


#import "CustomBtn.h"

@interface CustomTremblingView()

@property (nonatomic, assign) CGFloat screenHeight;

@end

@implementation CustomTremblingView

- (instancetype)initWithFrame:(CGRect)frame andDataArray:(NSArray<CustomTremblingItem *> *)dataArray{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.dataArray=dataArray;
        [self loadBlurEffectView];
        [self loadUI];
        [self loadBtnUI];
    }
    return self;
}

- (void)loadBlurEffectView{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = self.bounds;
    [self addSubview:effectview];
}

- (void)loadUI{
    UIButton * cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame=CGRectMake(0, self.height-40, self.width, 40);
    [cancleBtn setImage:[UIImage imageNamed:@"center_exit"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.transform=CGAffineTransformMakeRotation(M_PI_4);
    [self addSubview:cancleBtn];
    self.cancleBtn=cancleBtn;
    
}

- (void)loadBtnUI{
    if (self.dataArray.count==0) {
        return;
    }
    CGFloat width = 80;
    CGFloat space=(WIDTH-width*3)/4;
    CGFloat initialY=200;
    
    
    self.btnArray = [NSMutableArray new];
    
    
    for (int i=0; i<self.dataArray.count; i++) {
        
        CustomTremblingItem * item = self.dataArray[i];
        
        CGFloat x=0;
        if (self.dataArray.count==1) {
            x=(WIDTH-width)/2;
        }else{
            x=i%3*(width+space)+space;
        }
        
        CGFloat y=initialY+i/3*(width+50)+10+HEIGHT-200;
        
        CustomBtn * button = [CustomBtn viewFromNib];
        button.backgroundColor=[UIColor clearColor];
        button.frame = CGRectMake(x, y, width, width+20);
        button.normalImageName=item.normalImageName;
        button.selectedImageName=item.selectedImageName;
        button.normalColor=item.normalColor;
        button.selectedColor=item.selectedColor;
        button.normalTitle=item.normalTitle;
        button.selectedTitle=item.selectedTitle;
        button.selected=item.selected;
        
        
        button.btnClick=self.btnClick;
        button.index=i;
        
        [self.btnArray addObject:button];
        [self addSubview:button];
    }
}

- (void)setBtnClick:(void (^)(NSInteger))btnClick{
    _btnClick=btnClick;
    for (CustomBtn * button in self.btnArray) {
        button.btnClick=btnClick;
    }
}

- (void)show{
    self.hidden=NO;
    for (NSInteger index = 0; index < self.btnArray.count; index ++) {
        __block UIButton *btn = self.btnArray[index];
        [UIView animateWithDuration:0.7 delay:index * 0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformMakeTranslation(0, 200-HEIGHT);
        } completion:nil];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.cancleBtn.transform=CGAffineTransformIdentity;
    }];
}

- (void)hidden{
    for (NSInteger index = 0; index < self.btnArray.count; index ++) {
        __block UIButton *btn = self.btnArray[index];
        [UIView animateWithDuration:0.5 delay:index * 0.05 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.hidden=YES;
        }];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.cancleBtn.transform=CGAffineTransformMakeRotation(M_PI_4);
    } completion:^(BOOL finished) {
        if (self.cancleBtnClick) {
            self.cancleBtnClick();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hidden];
}

@end
