//
//  BSNumbersCollectionCell.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "BSNumbersCollectionCell.h"

@interface BSNumbersCollectionCell ()

@property (strong ,nonatomic) CAShapeLayer *separatorLayer;

- (void)setup;
- (void)updateFrame;

@end

@implementation BSNumbersCollectionCell

#pragma mark - Override
- (void)awakeFromNib {
    // Initialization code
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateFrame];
}

#pragma mark - Private
- (void)setup {
    [self addSubview:self.label];
    [self.layer addSublayer:self.separatorLayer];
}

- (void)updateFrame {
    self.label.frame = CGRectMake(self.horizontalMargin,
                                  0,
                                  self.bounds.size.width - 2 * self.horizontalMargin,
                                  self.bounds.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.bounds.size.width - 1, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width - 1, self.bounds.size.height)];

    self.separatorLayer.path = path.CGPath;
}

#pragma mark - Setter
- (void)setHorizontalMargin:(CGFloat)horizontalMargin {
    _horizontalMargin = horizontalMargin;
    
    [self updateFrame];
}

#pragma mark - Getter
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor clearColor];
    }
    return _label;
}

- (CAShapeLayer *)separatorLayer {
    if (!_separatorLayer) {
        _separatorLayer = [CAShapeLayer layer];
        _separatorLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _separatorLayer.lineWidth = 0.5;
    }
    return _separatorLayer;
}

@end
