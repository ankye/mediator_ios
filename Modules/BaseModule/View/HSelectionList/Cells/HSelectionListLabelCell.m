//
//  HSelectionListLabelCell.m
//  HSelectionList Example
//
//  Created by Erik Ackermann on 2/26/15.
//  Copyright (c) 2015 Hightower. All rights reserved.
//

#import "HSelectionListLabelCell.h"

#import <M13BadgeView/M13BadgeView.h>

@interface HSelectionListLabelCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) M13BadgeView *badgeView;

@property (nonatomic, strong) NSMutableDictionary *titleColorsByState;
@property (nonatomic, strong) NSMutableDictionary *titleFontsByState;

@end

@implementation HSelectionListLabelCell

@synthesize  badgeValue = _badgeValue;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
   
        [self.contentView addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_offset(40);
        }];


        _badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 8, 14)];
        _badgeView.font = [UIFont systemFontOfSize:10];
        _badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
        _badgeView.alignmentShift = CGSizeMake(-5, (self.frame.size.height - _badgeView.frame.size.height) * 0.5);
        _badgeView.hidesWhenZero = YES;
        [_titleLabel addSubview:_badgeView];

        _titleColorsByState = [NSMutableDictionary dictionary];
        _titleColorsByState[@(UIControlStateNormal)] = [UIColor blackColor];

        _titleFontsByState = [NSMutableDictionary dictionary];
        _titleFontsByState[@(UIControlStateNormal)] = [UIFont systemFontOfSize:13];

      //  _state = UIControlStateNormal;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.title = nil;
    self.titleLabel.textColor = self.titleColorsByState[@(UIControlStateNormal)];
    self.titleLabel.font = self.titleFontsByState[@(UIControlStateNormal)];
    self.titleColorsByState = [NSMutableDictionary dictionary];
    self.titleColorsByState[@(UIControlStateNormal)] = [UIColor blackColor];
    self.titleFontsByState = [NSMutableDictionary dictionary];
    self.titleFontsByState[@(UIControlStateNormal)] = [UIFont systemFontOfSize:13];


}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.contentView layoutSubviews];
    [self.titleLabel layoutSubviews];

    self.badgeView.text = self.badgeValue ?: @"0";
}

#pragma mark - Public Methods

+ (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font {
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];

    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}

#pragma mark - Custom Getters and Setters

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;

    [self setNeedsLayout];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateTitleColor];
    [self updateTitleFont];
}


- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    self.titleColorsByState[@(state)] = color;

    [self updateTitleColor];
}

- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state {
    self.titleFontsByState[@(state)] = font;

    [self updateTitleFont];
}

#pragma mark - Private Methods

- (void)updateTitleColor {
    if(self.selected){
        self.titleLabel.textColor = self.titleColorsByState[@(UIControlStateSelected)];
    }else{
        self.titleLabel.textColor = self.titleColorsByState[@(UIControlStateNormal)];
    }
}

- (void)updateTitleFont {
    
    if(self.selected){
        self.titleLabel.font = self.titleFontsByState[@(UIControlStateSelected)];
    }else{
        self.titleLabel.font = self.titleFontsByState[@(UIControlStateNormal)];
    }
 
}

@end
