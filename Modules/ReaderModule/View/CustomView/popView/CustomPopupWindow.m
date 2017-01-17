//
//  MainWindow.m
//  PopupViewStudy
//
//  Created by caiqiujun on 15/12/29.
//  Copyright © 2015年 caiqiujun. All rights reserved.
//

#import "CustomPopupWindow.h"

@implementation CustomPopupWindow

- (instancetype)initWithPopup:(CustomPopupItem *)popup;
{
    self = [super init];
    if (self) {
        
        // 获取屏幕信息
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        CGFloat screenWidth = size.width;
        CGFloat mainWidth = screenWidth * 0.7;
        
        self.popup = popup;
        self.progress = 0;
        self.themeColor = [UIColor colorWithRed:68/255.0 green:180/255.0 blue:255/255.0 alpha:1];
        self.clipsToBounds = YES;// 如果子视图的范围超出了父视图的边界，那么超出的部分就会被裁剪掉。
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth * 0.05, mainWidth * 0.02, mainWidth * 0.8, mainWidth * 0.16)];
        titleLabel.text = popup.title;
        titleLabel.textColor = self.themeColor;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:titleLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, mainWidth * 0.56, mainWidth, mainWidth * 0.15)];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:self.themeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnTouch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.userInteractionEnabled=NO;
        self.btn=btn;
        
        UITextView *msgTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, mainWidth * 0.19, mainWidth, mainWidth * 0.35)];
        msgTextView.textContainerInset = UIEdgeInsetsMake(mainWidth * 0.05, mainWidth * 0.05, mainWidth * 0.05, mainWidth * 0.05);
        msgTextView.userInteractionEnabled=NO;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 10.f;
        /*
        paragraphStyle.lineHeightMultiple = 10.f;
        paragraphStyle.maximumLineHeight = 20.f;
        paragraphStyle.minimumLineHeight = 10.f;
        paragraphStyle.firstLineHeadIndent = 10.f; // 首行缩进
        */
        paragraphStyle.alignment = NSTextAlignmentJustified;
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithWhite:0.5 alpha:1]};
        msgTextView.attributedText = [[NSAttributedString alloc]initWithString:self.popup.msgContent attributes:attributes];
        
        // 设置不可编辑
        [msgTextView setEditable:YES];
        
        [self addSubview:msgTextView];
    }
    return self;
}

- (void)btnTouch{
    [self.delegate determineTouch];
    [self.superview removeFromSuperview];
}

// UIColor-->UIImage
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
    if(self.progress==1){
        self.btn.userInteractionEnabled=YES;
    }
}

- (void)drawRect:(CGRect)rect {
    CGSize size = rect.size;
    CGFloat viewWidth = size.width;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    UIColor *sourceColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    CGContextSetStrokeColorWithColor(ctx, sourceColor.CGColor);
    
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    // 设置起点坐标
    CGContextMoveToPoint(ctx, viewWidth * self.progress, viewWidth * 0.19);
    // 设置终点坐标
    CGContextAddLineToPoint(ctx, viewWidth, viewWidth * 0.19);
    // 绘制
    CGContextStrokePath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, self.themeColor.CGColor);
    // 设置起点坐标
    CGContextMoveToPoint(ctx, 0, viewWidth * 0.19);
    // 设置终点坐标
    CGContextAddLineToPoint(ctx, viewWidth * self.progress, viewWidth * 0.19);
    // 绘制
    CGContextStrokePath(ctx);
}

- (void)dealloc
{
//    NSLog(@"%@被销毁",[self class]);
}

@end
