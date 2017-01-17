//
//  CustomBtn.h
//  powerlife
//
//  Created by 陈行 on 16/6/16.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBtn : UIView

@property(nonatomic,weak) UIImageView * imageView;

@property(nonatomic,weak) UILabel * titleLabel;

@property (nonatomic, copy) NSString *normalImageName;

@property (nonatomic, copy) NSString *selectedImageName;

@property(nonatomic,strong)UIColor * normalColor;

@property(nonatomic,strong)UIColor * selectedColor;

@property (nonatomic, copy) NSString *normalTitle;

@property (nonatomic, copy) NSString *selectedTitle;

@property(nonatomic,assign)BOOL selected;

@property (nonatomic, assign) NSInteger index;

@property(nonatomic,copy)void (^btnClick)(NSInteger index);

+ (instancetype)viewFromNib;

@end
