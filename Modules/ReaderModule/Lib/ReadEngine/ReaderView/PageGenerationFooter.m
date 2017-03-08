//
//  PageGenerationFooter.m
//  创新版
//
//  Created by XuPeng on 16/5/24.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "PageGenerationFooter.h"
#import "AKReaderSetting.h"
#import "AKLanguageHelper.h"

#define kChapterNameLabelX            0.0f
#define kChapterNameLabelY            0.0f
#define kChapterNameLabelWidth        200.0f
#define kChapterNameLabelHeight       44.0f

#define kProgressLabelX               kBatteryViewX - 5.0f - 70.0f
#define kProgressLabelY               0.0f
#define kProgressLabelWidth           70.0f
#define kProgressLabelHeight          44.0f

#define kBatteryViewX                 (self.frame.size.width - 25.0f)
#define kBatteryViewY                 17.0f
#define kBatteryViewWidth             25.0f
#define kBatteryViewHeight            10.0f

#define kBatteryFillX                 1.5f
#define kBatteryFillY                 1.5f
#define kBatteryFillWidth             (25.0f - 5.0f)
#define kBatteryFillHeight            (kBatteryViewHeight - 3.0f)

#define kFontColor                    [UIColor colorWithRed:153 / 255.0f green:153 / 255.0 blue:153 / 255.0 alpha:1.0f]

@implementation PageGenerationFooter {
    UILabel     *_chapterNameLabel; // 章节名称
    UILabel     *_progressLabel;    // 阅读进度
    UIImageView *_batteryView;      // 电池信息
    UIView      *_batteryFill;      // 电池填充
}

+(PageGenerationFooter *)sharePageGenerationFooter {
    return [[PageGenerationFooter alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.batteryImageName = @"电池";
        [self initializeView];
    }
    return self;
}
- (void)initializeView {
    self.backgroundColor            = [UIColor clearColor];

    // 绘制章节名称
    _chapterNameLabel               = [[UILabel alloc] init];
    _chapterNameLabel.textAlignment = NSTextAlignmentLeft;
    _chapterNameLabel.font          = [UIFont fontWithName:[AKReaderSetting sharedInstance].fontName size:12.0f];
    _chapterNameLabel.textColor     = kFontColor;
    [self addSubview:_chapterNameLabel];

    // 绘制进度
    _progressLabel                  = [[UILabel alloc] init];
    _progressLabel.textAlignment    = NSTextAlignmentRight;
    _progressLabel.font             = [UIFont fontWithName:[AKReaderSetting sharedInstance].fontName size:12.0f];
    _progressLabel.textColor        = kFontColor;
    [self addSubview:_progressLabel];

    // 绘制电池信息
    _batteryView                    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.batteryImageName]];
    // 电池电量
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float electricity               = [[UIDevice currentDevice] batteryLevel];
    // 绘制0.5的电量  电池的内部宽度定为45
    _batteryFill                    = [[UIView alloc] initWithFrame:CGRectMake(kBatteryFillX, kBatteryFillY, kBatteryFillWidth * electricity, kBatteryFillHeight)];
    _batteryFill.backgroundColor    = kFontColor;
    [_batteryView addSubview:_batteryFill];

    [self addSubview:_batteryView];
}

#pragma mark - get/set
- (void)setChapterName:(NSString *)chapterName {
    if([AKReaderSetting sharedInstance].isTraditional){
        chapterName = [[AKLanguageHelper sharedInstance] transformToTraditionalWith:chapterName];
    }

    
    _chapterName           = chapterName;
    _chapterNameLabel.text = _chapterName;
}
- (void)setReaderProgress:(CGFloat)readerProgress {
    _readerProgress       = readerProgress;
    NSString *percent     = @"%";
    NSString *progressStr = [NSString stringWithFormat:@"%.2f%@",_readerProgress * 100, percent];
    _progressLabel.text   = progressStr;
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor                   = textColor;
    _chapterNameLabel.textColor  = _textColor;
    _progressLabel.textColor     = _textColor;
    _batteryFill.backgroundColor = _textColor;
}
- (void)setBatteryImageName:(NSString *)batteryImageName {
    _batteryImageName  = batteryImageName;
    _batteryView.image = [UIImage imageNamed:_batteryImageName];
}
#pragma mark - 重写父类方法
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _chapterNameLabel.frame = CGRectMake(kChapterNameLabelX, kChapterNameLabelY, kChapterNameLabelWidth, kChapterNameLabelHeight);
    _progressLabel.frame    = CGRectMake(kProgressLabelX, kProgressLabelY, kProgressLabelWidth, kProgressLabelHeight);
    _batteryView.frame      = CGRectMake(kBatteryViewX, kBatteryViewY, kBatteryViewWidth, kBatteryViewHeight);
    
}
@end
