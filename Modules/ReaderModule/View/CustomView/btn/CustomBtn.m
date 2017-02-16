//
//  CustomBtn.m
//  powerlife
//
//  Created by 陈行 on 16/6/16.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CustomBtn.h"
#import "UIImageView+WebCache.h"

@implementation CustomBtn

+ (instancetype)viewFromNib{
    NSString * nibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil] firstObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            self.imageView=(UIImageView *)view;
        }else if ([view isKindOfClass:[UILabel class]]){
            self.titleLabel=(UILabel *)view;
        }
    }
}

- (void)setSelected:(BOOL)selected{
    _selected=selected;
    [self refreshSelected];
}

- (void)setNormalImageName:(NSString *)normalImageName{
    _normalImageName=normalImageName;
    [self refreshSelected];
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor=normalColor;
    [self refreshSelected];
}

- (void)setSelectedImageName:(NSString *)selectedImageName{
    _selectedImageName=selectedImageName;
    [self refreshSelected];
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor=selectedColor;
    [self refreshSelected];
}

- (void)setNormalTitle:(NSString *)normalTitle{
    _normalTitle=normalTitle;
    [self refreshSelected];
}

- (void)setSelectedTitle:(NSString *)selectedTitle{
    _selectedTitle=selectedTitle;
    [self refreshSelected];
}

- (void)refreshSelected{
    if (_selected) {
        if (self.selectedImageName) {
            if ([self.selectedImageName hasPrefix:@"http"]) {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.selectedImageName] placeholderImage:[UIImage imageNamed:@"default_car"]];
            }else{
                self.imageView.image=[UIImage imageNamed:self.selectedImageName];
            }
        }
        if (self.selectedColor) {
            self.titleLabel.textColor=self.selectedColor;
        }
        self.titleLabel.text=self.selectedTitle?:self.normalTitle;
    }else{
        if (self.normalImageName) {
            if ([self.normalImageName hasPrefix:@"http"]) {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.normalImageName] placeholderImage:[UIImage imageNamed:@"default_car"]];
            }else{
                self.imageView.image=[UIImage imageNamed:self.normalImageName];
            }
        }
        if (self.normalColor) {
            self.titleLabel.textColor=self.normalColor;
        }
        self.titleLabel.text=self.normalTitle;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self imageBtnClick];
}

- (void)imageBtnClick{
    if (_btnClick) {
        _btnClick(self.index);
    }
}

@end
