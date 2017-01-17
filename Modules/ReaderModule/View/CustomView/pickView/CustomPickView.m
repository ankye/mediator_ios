//
//  CustomPickView.m
//  testPickView
//
//  Created by 陈行 on 16-1-16.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "CustomPickView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define SELFWIDTH self.frame.size.width
#define SELFHEIGHT self.frame.size.height

#define PICKVIEW_THEME_COLOR [UIColor colorWithRed:0.31f green:0.78f blue:0.97f alpha:1.00f]

@interface CustomPickView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,assign)NSInteger component;

@property(nonatomic,assign)BOOL isDependPre;

@end

@implementation CustomPickView

+ (instancetype)customPickViewWithDataArray:(NSArray *)dataArray andComponent:(NSInteger)component andIsDependPre:(BOOL)isDependPre andFrame:(CGRect)frame{
    CustomPickView * pv=[[self alloc]initWithFrame:frame];
    pv.component=component;
    pv.isDependPre=isDependPre;
    pv.dataArray=dataArray;
    return pv;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(-1, 0, SCREENWIDTH+2, 40)];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.borderWidth=1.f;
        view.layer.borderColor=[PICKVIEW_THEME_COLOR CGColor];
        [self addSubview:view];
        
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(16, 0, 80, 40);
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius=4.f;
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:PICKVIEW_THEME_COLOR forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancleTouch) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UIButton * btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame=CGRectMake(SCREENWIDTH-80-16, 0, 80, 40);
        btn2.layer.masksToBounds=YES;
        btn2.layer.cornerRadius=4.f;
        [btn2 setTitle:@"确定" forState:UIControlStateNormal];
        [btn2 setTitleColor:PICKVIEW_THEME_COLOR forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(makeSureTouch) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn2];
        
        UIPickerView * pickView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SELFHEIGHT-40)];
        pickView.dataSource=self;
        pickView.delegate=self;
        [self addSubview:pickView];
        self.pickView=pickView;
    }
    return self;
}

- (void)cancleTouch{
    if([self.delegate respondsToSelector:@selector(customPickViewCancleTouch:)]){
        [self.delegate customPickViewCancleTouch:self];
    }
}

- (void)makeSureTouch{
    [self.delegate customPickView:self andSelectedArray:self.selectedArray andDataArray:self.dataArray];
}

- (void)customPickerViewSelectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    [self.pickView selectRow:row inComponent:component animated:animated];
    self.selectedArray[component]=@(row);
}

#pragma mark - pickView代理协议
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.component?:1;//有几列
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{//每一列有几行
    if(self.isDependPre){
        NSInteger number = 0 ;
        if(component==0){
            number = self.dataArray.count;
        }
        NSArray * currentArray=self.dataArray;
        for (int i=1; i<self.selectedArray.count; i++) {
            NSInteger index=[self.selectedArray[i-1] integerValue];
            if([currentArray count]){
                NSObject * object=currentArray[index];
                currentArray=[object valueForKey:self.dataArrayKey[i-1]];
                if(component==i){
                    number = currentArray.count;
                }
            }
        }
//        NSLog(@"%ld-->%ld",component,number);
        return number;
    }else{
        if([self.dataArray[component] isKindOfClass:[NSArray class]]){
            return [self.dataArray[component] count]?:1;;
        }else{
            return self.dataArray.count;
        }
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{//返回的名称
    NSObject * obj;
    if(self.isDependPre){
        if(component==0){
            obj = [self.dataArray[row] valueForKey:self.titleKey];
        }else{
            NSArray * currentArray=self.dataArray;
//            NSLog(@"%ld--->%ld-->%@",component,[currentArray count],obj);
            for (int i=1; i<self.selectedArray.count; i++) {
                NSInteger index=[self.selectedArray[i-1] integerValue];
                if([currentArray count]){
                    NSObject * object=currentArray[index];
                    currentArray=[object valueForKey:self.dataArrayKey[i-1]];
                    if(component==i){
                        if(currentArray[row]){
                            return [currentArray[row] valueForKey:self.titleKey];
                        }else{
                            return @"";
                        }
                    }
                }else{
                    return @"";
                }
            }
        }
    }else{
        if([self.dataArray[component] isKindOfClass:[NSArray class]]){
            if(self.keyArray==nil || self.keyArray.count<component+1){
                return [self.dataArray[component] objectAtIndex:row];
            }else{
                return  [[self.dataArray[component] objectAtIndex:row] valueForKey:self.keyArray[component]];
            }
        }else{
            return [[self.dataArray objectAtIndex:row] valueForKey:self.titleKey];
        }
    }
    return [NSString stringWithFormat:@"%@",obj];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment=NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedArray[component]=@(row);
    if(self.isDependPre){
        for (NSInteger i=component+1; i<self.component; i++) {
            [pickerView reloadComponent:i];
            [pickerView selectRow:0 inComponent:i animated:YES];
            self.selectedArray[i]=@(0);
        }
    }
}

- (NSMutableArray *)selectedArray{
    if(_selectedArray==nil){
        _selectedArray=[NSMutableArray new];
        for (int i=0; i<self.component; i++) {
            [_selectedArray addObject:@(0)];
        }
    }
    return _selectedArray;
}

- (void)reloadSelectArray{
    _selectedArray=nil;
    [self customPickerViewSelectRow:0 inComponent:0 animated:NO];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    [self.pickView reloadAllComponents];
}

- (void)dealloc{
    NSLog(@"销毁customPickView");
}

@end
