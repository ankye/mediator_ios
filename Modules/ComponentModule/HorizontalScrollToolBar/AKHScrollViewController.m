//
//  HSTB_DisplayViewController.m
//  ZKHorizontalScrollToolBar
//
//  Created by 郑凯 on 2016/11/30.
//  Copyright © 2016年 tzktzk1. All rights reserved.
//

#import "AKHScrollViewController.h"
#import "UIView+Frame.h"
#import "AKHScrollTitleLabel.h"
#import "AKHScrollToolBarHeader.h"
#import "AKHScrollFlowLayout.h"
#import "AKHContentView.h"

static NSString * const ID = @"ContentCell";

@interface AKHScrollViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIColor *_norColor;
    UIColor *_selColor;
}

/**
 *  下标宽度是否等于标题宽度
 */
@property (nonatomic, assign) BOOL isUnderLineEqualTitleWidth;

/**
 标题滚动视图背景颜色
 */

@property (nonatomic, strong) UIColor *titleScrollViewColor;

@property (nonatomic, assign) CGFloat headerHeight;
/**
 标题高度
 */
@property (nonatomic, assign) CGFloat titleHeight;

/**
 标题宽度
 */
@property (nonatomic, assign) CGFloat titleWidth;

/**
 正常标题颜色
 */
@property (nonatomic, strong) UIColor *norColor;

/**
 选中标题颜色
 */
@property (nonatomic, strong) UIColor *selColor;

/**
 标题字体
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 整体内容View : 包含标题和内容滚动视图
 */
@property (nonatomic, weak) UIView *contentView;

/**
 标题滚动视图
 */
@property (nonatomic, weak) UIScrollView *titleScrollView;

/**
 内容滚动视图
 */
@property (nonatomic, weak) UICollectionView *contentScrollView;

/**
 所有标题数组
 */
@property (nonatomic, strong) NSMutableArray *titleLabels;

/**
 所有标题宽度数组
 */
@property (nonatomic, strong) NSMutableArray *titleWidths;

/**
 下标视图
 */
@property (nonatomic, weak) UIView *underLine;

/**
 是否需要下标
 */
@property (nonatomic, assign) BOOL isShowUnderLine;

/**
 字体是否渐变
 */
@property (nonatomic, assign) BOOL isShowTitleGradient;

/**
 字体放大
 */
@property (nonatomic, assign) BOOL isShowTitleScale;

/**
 是否显示遮盖
 */
@property (nonatomic, assign) BOOL isShowTitleCover;

/**
 标题遮盖视图
 */
@property (nonatomic, weak) UIView *coverView;

/**
 记录上一次内容滚动视图偏移量
 */
@property (nonatomic, assign) CGFloat lastOffsetX;

/**
 记录是否点击
 */
@property (nonatomic, assign) BOOL isClickTitle;

/**
 记录是否在动画
 */
@property (nonatomic, assign) BOOL isAniming;

/**
 是否初始化
 */
@property (nonatomic, assign) BOOL isInitial;

/**
 标题间距
 */
@property (nonatomic, assign) CGFloat titleMargin;

/**
 计算上一次选中角标
 */
@property (nonatomic, assign) NSInteger selIndex;

/**
 颜色渐变样式
 */
@property (nonatomic, assign) HSTB_TitleColorGradientStyle titleColorGradientStyle;

/**
 字体缩放比例
 */
@property (nonatomic, assign) CGFloat titleScale;

/**
 是否延迟滚动下标
 */
@property (nonatomic, assign) BOOL isDelayScroll;

/**
 遮盖颜色
 */
@property (nonatomic, strong) UIColor *coverColor;

/**
 遮盖圆角半径
 */
@property (nonatomic, assign) CGFloat coverCornerRadius;

/**
 下标颜色
 */
@property (nonatomic, strong) UIColor *underLineColor;

/**
 下标高度
 */
@property (nonatomic, assign) CGFloat underLineH;

/**
 开始颜色,取值范围0~1
 */
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;

/**
 完成颜色,取值范围0~1
 */
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;

@end

@implementation AKHScrollViewController

#pragma mark - 初始化方法
- (instancetype)init
{
    if (self = [super init]) {
        [self initial];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initial];
    [super awakeFromNib];
}

- (void)initial
{
    // 初始化标题高度
    _titleHeight = HSTB_TitleScrollViewH;
    _headerHeight = HSTB_TitleScrollViewH;
    _contentViews = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 懒加载

- (UIFont *)titleFont
{
    if (_titleFont == nil) {
        _titleFont = HSTB_TitleFont;
    }
    return _titleFont;
}


- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

- (UIColor *)norColor
{
    if (_norColor == nil) self.norColor = [UIColor blackColor];
    
    return _norColor;
}

- (UIColor *)selColor
{
    if (_selColor == nil) self.selColor = [UIColor redColor];
    
    return _selColor;
}

- (UIView *)coverView
{
    if (_coverView == nil) {
        UIView *coverView = [[UIView alloc] init];
        
        coverView.backgroundColor = _coverColor?_coverColor:[UIColor whiteColor];
        
        coverView.layer.cornerRadius = _coverCornerRadius;
        
        [self.titleScrollView insertSubview:coverView atIndex:0];
        
        _coverView = coverView;
    }
    return _isShowTitleCover?_coverView:nil;
}

- (UIView *)underLine
{
    if (_underLine == nil) {
        
        UIView *underLineView = [[UIView alloc] init];
        
        underLineView.backgroundColor = _underLineColor?_underLineColor:[UIColor redColor];
        
        [self.titleScrollView addSubview:underLineView];
        
        _underLine = underLineView;
    }
    return _isShowUnderLine?_underLine : nil;
}

- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

// 懒加载标题滚动视图
- (UIScrollView *)titleScrollView
{
    if (_titleScrollView == nil) {
        
        UIScrollView *titleScrollView = [[UIScrollView alloc] init];
        titleScrollView.scrollsToTop = NO;
        titleScrollView.backgroundColor = _titleScrollViewColor?_titleScrollViewColor:[UIColor colorWithWhite:1 alpha:0.7];
        
        [self.contentView addSubview:titleScrollView];
        
        _titleScrollView = titleScrollView;
    }
    return _titleScrollView;
}

// 懒加载内容滚动视图
- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil) {
        
        // 创建布局
        AKHScrollFlowLayout *layout = [[AKHScrollFlowLayout alloc] init];
        
        UICollectionView *contentScrollView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentScrollView = contentScrollView;
        // 设置内容滚动视图
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.dataSource = self;
        _contentScrollView.scrollsToTop = NO;
        // 注册cell
        [_contentScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
        
        _contentScrollView.backgroundColor = self.view.backgroundColor;
        [self.contentView insertSubview:contentScrollView belowSubview:self.titleScrollView];
    }
    
    return _contentScrollView;
}

// 懒加载整个内容view
- (UIView *)contentView
{
    if (_contentView == nil) {
        
        UIView *contentView = [[UIView alloc] init];
        _contentView = contentView;
        [self.view addSubview:contentView];
    }
    
    return _contentView;
}

#pragma mark - 属性setter方法
- (void)setIsShowTitleScale:(BOOL)isShowTitleScale
{
    if (_isShowUnderLine) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"HSTB_DisplayViewControllerException" reason:@"字体放大效果和角标不能同时使用。" userInfo:nil];
        [excp raise];
    }
    
    _isShowTitleScale = isShowTitleScale;
}

- (void)setIsShowUnderLine:(BOOL)isShowUnderLine
{
    if (_isShowTitleScale) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"HSTB_DisplayViewControllerException" reason:@"字体放大效果和角标不能同时使用。" userInfo:nil];
        [excp raise];
    }
    
    _isShowUnderLine = isShowUnderLine;
}

- (void)setTitleScrollViewColor:(UIColor *)titleScrollViewColor
{
    _titleScrollViewColor = titleScrollViewColor;
    
    self.titleScrollView.backgroundColor = titleScrollViewColor;
}

- (void)setIsfullScreen:(BOOL)isfullScreen
{
    _isFullScreen = isfullScreen;
    
    self.contentView.frame = CGRectMake(0, 0, HSTB_ScreenW, HSTB_ScreenH);
}

// 设置整体内容的尺寸
- (void)setUpContentViewFrame:(void (^)(UIView *))contentBlock
{
    if (contentBlock) {
        contentBlock(self.contentView);
    }
}

// 一次性设置所有颜色渐变属性
- (void)setUpTitleGradient:(void(^)(HSTB_TitleColorGradientStyle *titleColorGradientStyle,UIColor **norColor,UIColor **selColor))titleGradientBlock;
{
    _isShowTitleGradient = YES;
    UIColor *norColor;
    UIColor *selColor;
    if (titleGradientBlock) {
        titleGradientBlock(&_titleColorGradientStyle,&norColor,&selColor);
        if (norColor) {
            self.norColor = norColor;
        }
        if (selColor) {
            self.selColor = selColor;
        }
    }
    
    if (_titleColorGradientStyle == HSTB_TitleColorGradientStyleFill && _titleWidth > 0) {
        @throw [NSException exceptionWithName:@"ERROR" reason:@"标题颜色填充不需要设置标题宽度" userInfo:nil];
    }
}

// 一次性设置所有遮盖属性
- (void)setUpCoverEffect:(void (^)(UIColor **, CGFloat *))coverEffectBlock
{
    UIColor *color;
    
    _isShowTitleCover = YES;
    
    if (coverEffectBlock) {
        
        coverEffectBlock(&color,&_coverCornerRadius);
        
        if (color) {
            _coverColor = color;
        }
    }
}

// 一次性设置所有字体缩放属性
- (void)setUpTitleScale:(void(^)(CGFloat *titleScale))titleScaleBlock
{
    _isShowTitleScale = YES;
    
//    if (_isShowUnderLine) {
//        @throw [NSException exceptionWithName:@"Error" reason:@"当前框架下标和字体缩放不能一起用" userInfo:nil];
//    }
//    
    if (titleScaleBlock) {
        titleScaleBlock(&_titleScale);
    }
}

// 一次性设置所有下标属性
- (void)setUpUnderLineEffect:(void(^)(BOOL *isUnderLineDelayScroll,CGFloat *underLineH,UIColor **underLineColor,BOOL *isUnderLineEqualTitleWidth))underLineBlock
{
    _isShowUnderLine = YES;
    
//    if (_isShowTitleScale) {
//        @throw [NSException exceptionWithName:@"Error" reason:@"当前框架下标和字体缩放不能一起用" userInfo:nil];
//    }
    
    UIColor *underLineColor;
    
    if (underLineBlock) {
        underLineBlock(&_isDelayScroll,&_underLineH,&underLineColor,&_isUnderLineEqualTitleWidth);
        
        _underLineColor = underLineColor;
    }
}

// 一次性设置所有标题属性
- (void)setUpTitleEffect:(void(^)(UIColor **titleScrollViewColor,UIColor **norColor,UIColor **selColor,UIFont **titleFont,CGFloat *headerHeight,CGFloat *titleHeight,CGFloat *titleWidth))titleEffectBlock{
    UIColor *titleScrollViewColor;
    UIColor *norColor;
    UIColor *selColor;
    UIFont *titleFont;
    if (titleEffectBlock) {
        titleEffectBlock(&titleScrollViewColor,&norColor,&selColor,&titleFont,&_headerHeight,&_titleHeight,&_titleWidth);
        if (norColor) {
            self.norColor = norColor;
        }
        if (selColor) {
            self.selColor = selColor;
        }
        if (titleScrollViewColor) {
            _titleScrollViewColor = titleScrollViewColor;
        }
        _titleFont = titleFont;
    }
    if (_titleColorGradientStyle == HSTB_TitleColorGradientStyleFill && _titleWidth > 0) {
        @throw [NSException exceptionWithName:@"ERROR" reason:@"标题颜色填充不需要设置标题宽度" userInfo:nil];
    }
}

#pragma mark - 控制器view生命周期方法
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (_isInitial == NO) {
        self.selectIndex = self.selectIndex;
        
        _isInitial = YES;
        
        CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        CGFloat titleY = self.navigationController.navigationBarHidden == NO ?HSTB_NavBarH:statusH;

        // 是否占据全屏
        if (_isFullScreen) {
            
            // 整体contentView尺寸
            self.contentView.frame = CGRectMake(0, 0, HSTB_ScreenW, HSTB_ScreenH);
            
            // 顶部标题View尺寸
            self.titleScrollView.frame = CGRectMake(0, titleY, HSTB_ScreenW, self.headerHeight);
            
            // 顶部内容View尺寸
            self.contentScrollView.frame = self.contentView.bounds;

        }else{
        
            if (self.contentView.frame.size.height == 0) {
                self.contentView.frame = CGRectMake(0, titleY, HSTB_ScreenW, HSTB_ScreenH - titleY);
            }
            
            // 顶部标题View尺寸
            self.titleScrollView.frame = CGRectMake(0, 0, HSTB_ScreenW, self.headerHeight);
            
            // 顶部内容View尺寸
            CGFloat contentY = CGRectGetMaxY(self.titleScrollView.frame);
            CGFloat contentH = self.contentView.height - contentY;
            self.contentScrollView.frame = CGRectMake(0, contentY, HSTB_ScreenW, contentH);
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isInitial == NO) {
        
        // 没有子控制器，不需要设置标题
        if (_contentViews.count == 0) return;
        
        if (_titleColorGradientStyle == HSTB_TitleColorGradientStyleFill || _titleWidth == 0) { // 填充样式才需要这样
            
            [self setUpTitleWidth];
        }
        [self setUpAllTitle];
    }
}

#pragma mark - 添加标题方法
// 计算所有标题宽度
- (void)setUpTitleWidth
{
    // 判断是否能占据整个屏幕
    NSUInteger count = _contentViews.count;
    
    NSArray *titles = [_contentViews valueForKeyPath:@"title"];
    
    CGFloat totalWidth = 0;
    
    // 计算所有标题的宽度
    for (NSString *title in titles) {
        
        if ([title isKindOfClass:[NSNull class]]) {
            // 抛异常
            NSException *excp = [NSException exceptionWithName:@"HSTB_DisplayViewControllerException" reason:@"没有设置Controller.title属性，应该把子标题保存到对应子控制器中" userInfo:nil];
            [excp raise];
        }
        CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
        
        CGFloat width = titleBounds.size.width;
        
        [self.titleWidths addObject:@(width)];
        
        totalWidth += width;
    }
    
    if (totalWidth > HSTB_ScreenW) {
        
        _titleMargin = margin;
        
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
        
        return;
    }
    
    CGFloat titleMargin = (HSTB_ScreenW - totalWidth) / (count + 1);
    
    _titleMargin = titleMargin < margin? margin: titleMargin;
    
    self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
}

// 设置所有标题
- (void)setUpAllTitle
{
    // 遍历所有的子控制器
    NSUInteger count = _contentViews.count;
    
    // 添加所有的标题
    CGFloat labelW = _titleWidth;
    CGFloat labelH = self.titleHeight;
    CGFloat labelX = 0;
    CGFloat labelY = self.headerHeight - self.titleHeight;
    
    for (int i = 0; i < count; i++) {
        
        AKHContentView *tempView = _contentViews[i];
        
        UILabel *label = [[AKHScrollTitleLabel alloc] init];
        
        label.tag = i;
        
        // 设置按钮的文字颜色
        label.textColor = self.norColor;
        
        label.font = self.titleFont;
        
        // 设置按钮标题
        label.text = [tempView getTitle];
    
        if (_titleColorGradientStyle == HSTB_TitleColorGradientStyleFill || _titleWidth == 0) { // 填充样式才需要
            labelW = [self.titleWidths[i] floatValue];
            
            // 设置按钮位置
            UILabel *lastLabel = [self.titleLabels lastObject];
            
            labelX = _titleMargin + CGRectGetMaxX(lastLabel.frame);
        } else {
            
            labelX = i * labelW;
        }
        
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
 
        // 监听标题的点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        
        // 保存到数组
        [self.titleLabels addObject:label];
        
        [_titleScrollView addSubview:label];
        
        if (i == _selectIndex) {
            [self titleClick:tap];
        }
    }
    // 设置标题滚动视图的内容范围
    UILabel *lastLabel = self.titleLabels.lastObject;
    _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), 0);
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(count * HSTB_ScreenW, 0);
}

#pragma mark - 标题效果渐变方法
// 设置标题颜色渐变
- (void)setUpTitleColorGradientWithOffset:(CGFloat)offsetX rightLabel:(AKHScrollTitleLabel *)rightLabel leftLabel:(AKHScrollTitleLabel *)leftLabel
{
    if (_isShowTitleGradient == NO) return;
    
    // 获取右边缩放
    CGFloat rightSacle = offsetX / HSTB_ScreenW - leftLabel.tag;
    
    // 获取左边缩放比例
    CGFloat leftScale = 1 - rightSacle;
    
    // RGB渐变
    if (_titleColorGradientStyle == HSTB_TitleColorGradientStyleRGB) {
        
        CGFloat r = _endR - _startR;
        CGFloat g = _endG - _startG;
        CGFloat b = _endB - _startB;
        
        // rightColor
        // 1 0 0
        UIColor *rightColor = [UIColor colorWithRed:_startR + r * rightSacle green:_startG + g * rightSacle blue:_startB + b * rightSacle alpha:1];
        
        // 0.3 0 0
        // 1 -> 0.3
        // leftColor
        UIColor *leftColor = [UIColor colorWithRed:_startR +  r * leftScale  green:_startG +  g * leftScale  blue:_startB +  b * leftScale alpha:1];
        
        // 右边颜色
        rightLabel.textColor = rightColor;
        
        // 左边颜色
        leftLabel.textColor = leftColor;
        return;
    }
    
    // 填充渐变
    if (_titleColorGradientStyle == HSTB_TitleColorGradientStyleFill) {
        
        // 获取移动距离
        CGFloat offsetDelta = offsetX - _lastOffsetX;
        
        if (offsetDelta > 0) { // 往右边
            rightLabel.textColor = self.norColor;
            rightLabel.fillColor = self.selColor;
            rightLabel.progress = rightSacle;
            
            leftLabel.textColor = self.selColor;
            leftLabel.fillColor = self.norColor;
            leftLabel.progress = rightSacle;
            
        } else if(offsetDelta < 0){ // 往左边
            
            rightLabel.textColor = self.norColor;
            rightLabel.fillColor = self.selColor;
            rightLabel.progress = rightSacle;
            
            leftLabel.textColor = self.selColor;
            leftLabel.fillColor = self.norColor;
            leftLabel.progress = rightSacle;
            
        }
    }
}

// 标题缩放
- (void)setUpTitleScaleWithOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    if (_isShowTitleScale == NO) return;
    
    // 获取右边缩放
    CGFloat rightSacle = offsetX / HSTB_ScreenW - leftLabel.tag;
    
    CGFloat leftScale = 1 - rightSacle;
    
    CGFloat scaleTransform = _titleScale?_titleScale:HSTB_TitleTransformScale;
    
    scaleTransform -= 1;
    
    // 缩放按钮
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * scaleTransform + 1, leftScale * scaleTransform + 1);
    
    // 1 ~ 1.3
    rightLabel.transform = CGAffineTransformMakeScale(rightSacle * scaleTransform + 1, rightSacle * scaleTransform + 1);
}

// 获取两个标题按钮宽度差值
- (CGFloat)widthDeltaWithRightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    CGRect titleBoundsR = [rightLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    CGRect titleBoundsL = [leftLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    return titleBoundsR.size.width - titleBoundsL.size.width;
}

// 设置下标偏移
- (void)setUpUnderLineOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    if (_isClickTitle) return;
    
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightLabel.x - leftLabel.x;
    
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel];
    
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / HSTB_ScreenW;
    
    // 宽度递增偏移量
    CGFloat underLineWidth = offsetDelta * widthDelta / HSTB_ScreenW;
    
    self.underLine.width += underLineWidth;
    self.underLine.x += underLineTransformX;
    
}

// 设置遮盖偏移
- (void)setUpCoverOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    if (_isClickTitle) return;
    
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightLabel.x - leftLabel.x;
    
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel];
    
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    
    // 计算当前下划线偏移量
    CGFloat coverTransformX = offsetDelta * centerDelta / HSTB_ScreenW;
    
    // 宽度递增偏移量
    CGFloat coverWidth = offsetDelta * widthDelta / HSTB_ScreenW;
    
    self.coverView.width += coverWidth;
    self.coverView.x += coverTransformX;
    
}

#pragma mark - 标题点击处理
- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    if (self.titleLabels.count) {
        
        UILabel *label = self.titleLabels[selectIndex];
        
        if (_selectIndex >= self.titleLabels.count) {
            @throw [NSException exceptionWithName:@"ERROR" reason:@"选中控制器的角标越界" userInfo:nil];
        }
        
        [self titleClick:[label.gestureRecognizers firstObject]];
    }
}

// 标题按钮点击
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    // 记录是否点击标题
    _isClickTitle = YES;
    
    // 获取对应标题label
    UILabel *label = (UILabel *)tap.view;
    
    // 获取当前角标
    NSInteger i = label.tag;
    
    // 选中label
    [self selectLabel:label];
    
    // 内容滚动视图滚动到对应位置
    CGFloat offsetX = i * HSTB_ScreenW;
    
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 记录上一次偏移量,因为点击的时候不会调用scrollView代理记录，因此需要主动记录
    _lastOffsetX = offsetX;
    
    // 添加控制器
    UIView *tempView = _contentViews[i];
    
    // 判断控制器的view有没有加载，没有就加载，加载完在发送通知
    if (tempView) {
        // 发出通知点击标题通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:HSTB_DisplayViewClickOrScrollDidFinshNote  object:tempView];
        
        
        // 发出重复点击标题通知
        if (_selIndex == i) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:HSTB_DisplayViewRepeatClickTitleNote object:tempView];
            [self scrollToolBarDidRepeatSelectedAtIndex:i];
        }else{
            [self scrollToolBarDidSelectedAtIndex:i];
        }
    }
    
    _selIndex = i;
    
    // 点击事件处理完成
    _isClickTitle = NO;
}

- (void)selectLabel:(UILabel *)label
{
    
    for (AKHScrollTitleLabel *labelView in self.titleLabels) {
        
        if (label == labelView) continue;
        
        if (_isShowTitleGradient) {
            
            labelView.transform = CGAffineTransformIdentity;
        }
        
        labelView.textColor = self.norColor;
        
        if (_isShowTitleGradient && _titleColorGradientStyle == HSTB_TitleColorGradientStyleFill) {
            
            labelView.fillColor = self.norColor;
            
            labelView.progress = 1;
        }
        
    }
    
    // 标题缩放
    if (_isShowTitleScale) {
        
        CGFloat scaleTransform = _titleScale?_titleScale:HSTB_TitleTransformScale;
        
        label.transform = CGAffineTransformMakeScale(scaleTransform, scaleTransform);
    }
    
    // 修改标题选中颜色
    label.textColor = self.selColor;
    
    // 设置标题居中
    [self setLabelTitleCenter:label];
    
    // 设置下标的位置
    if (_isShowUnderLine) {
        [self setUpUnderLine:label];
    }
    
    // 设置cover
    if (_isShowTitleCover) {
        [self setUpCoverView:label];
    }
    
}

// 设置蒙版
- (void)setUpCoverView:(UILabel *)label
{
    // 获取文字尺寸
    CGRect titleBounds = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    CGFloat border = 5;
    CGFloat coverH = titleBounds.size.height + 2 * border;
    CGFloat coverW = titleBounds.size.width + 2 * border;
    if(_isShowTitleScale){
        coverH = coverH * _titleScale;
        coverW = coverW * _titleScale;
        border = border * _titleScale;
    }
    self.coverView.centerY = label.centerY;
    self.coverView.height = coverH;
    
    
    // 最开始不需要动画
    if (self.coverView.x == 0) {
        self.coverView.width = coverW;
        
        self.coverView.x = label.x - border;
        return;
    }
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.width = coverW;
        
        self.coverView.x = label.x - border;
    }];
    
    
    
}

// 设置下标的位置
- (void)setUpUnderLine:(UILabel *)label
{
    // 获取文字尺寸
    CGRect titleBounds = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    CGFloat underLineH = _underLineH?_underLineH:HSTB_UnderLineH;
    
    
    CGFloat border = 5;

    CGFloat underLineW = titleBounds.size.width + 2 * border;
    if(_isUnderLineEqualTitleWidth == NO){
        underLineW = label.width + 2 * border;
    }
       
    
    self.underLine.y = self.headerHeight - underLineH;
    self.underLine.height = underLineH;
    
    
    // 最开始不需要动画
    if (self.underLine.x == 0) {
        self.underLine.width = underLineW;
        
        self.underLine.centerX = label.centerX;
        return;
    }
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        
        self.underLine.width = underLineW;
        self.underLine.centerX = label.centerX;
    }];
    
}

// 让选中的按钮居中显示
- (void)setLabelTitleCenter:(UILabel *)label
{
    
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = label.center.x - HSTB_ScreenW * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - HSTB_ScreenW + _titleMargin;
    
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 滚动区域
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

#pragma mark - 刷新界面方法
// 更新界面
- (void)refreshDisplay
{
    if (_contentViews.count == 0) {
        @throw [NSException exceptionWithName:@"ERROR" reason:@"请确定添加了所有子控制器" userInfo:nil];
    }
    
    // 清空之前所有标题
    [self.titleLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titleLabels removeAllObjects];
    
    // 刷新表格
    [self.contentScrollView reloadData];
    
    // 重新设置标题
    if (_titleColorGradientStyle == HSTB_TitleColorGradientStyleFill || _titleWidth == 0) {
        
        [self setUpTitleWidth];
    }
    
    [self setUpAllTitle];
    
    // 默认选中标题
    self.selectIndex = self.selectIndex;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _contentViews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    // 移除之前的子控件
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 添加控制器
    UIView *tempView = _contentViews[indexPath.row];
    
    tempView.frame = CGRectMake(0, 0, self.contentScrollView.width, self.contentScrollView.height);
    
//    CGFloat bottom = self.tabBarController == nil?0:49;
//    CGFloat top = _isFullScreen?CGRectGetMaxY(self.titleScrollView.frame):0;
//    if ([tempView isKindOfClass:[AKHContentView class]]) {
//       
//        tempView.frame=CGRectMake(0, top, SCREEN_WIDTH, top);
//    }
    
    
    [cell.contentView addSubview:tempView];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

// 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger offsetXInt = offsetX;
    NSInteger screenWInt = HSTB_ScreenW;
    
    NSInteger extre = offsetXInt % screenWInt;
    if (extre > HSTB_ScreenW * 0.5) {
        // 往右边移动
        offsetX = offsetX + (HSTB_ScreenW - extre);
        _isAniming = YES;
        [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else if (extre < HSTB_ScreenW * 0.5 && extre > 0){
        _isAniming = YES;
        // 往左边移动
        offsetX =  offsetX - extre;
        [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    // 获取角标
    NSInteger i = offsetX / HSTB_ScreenW;
    
    // 选中标题
    [self selectLabel:self.titleLabels[i]];
    
    [self scrollToolBarDidSelectedAtIndex:i];
    // 取出对应控制器发出通知
    //UIView *vc = _contentViews[i];
    
    
    // 发出通知
   // [[NSNotificationCenter defaultCenter] postNotificationName:HSTB_DisplayViewClickOrScrollDidFinshNote object:vc];
}


// 监听滚动动画是否完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _isAniming = NO;
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 点击和动画的时候不需要设置
    if (_isAniming || self.titleLabels.count == 0) return;
    
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 获取左边角标
    NSInteger leftIndex = offsetX / HSTB_ScreenW;
    
    // 左边按钮
    AKHScrollTitleLabel *leftLabel = self.titleLabels[leftIndex];
    
    // 右边角标
    NSInteger rightIndex = leftIndex + 1;
    
    // 右边按钮
    AKHScrollTitleLabel *rightLabel = nil;
    
    if (rightIndex < self.titleLabels.count) {
        rightLabel = self.titleLabels[rightIndex];
    }
    
    // 字体放大
    [self setUpTitleScaleWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 设置下标偏移
    if (_isDelayScroll == NO) { // 延迟滚动，不需要移动下标
        
        [self setUpUnderLineOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    }
    
    // 设置遮盖偏移
    [self setUpCoverOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 设置标题渐变
    [self setUpTitleColorGradientWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 记录上一次的偏移量
    _lastOffsetX = offsetX;
}

#pragma mark - 颜色操作

- (void)setNorColor:(UIColor *)norColor
{
    _norColor = norColor;
    [self setupStartColor:norColor];
    
}

- (void)setSelColor:(UIColor *)selColor
{
    _selColor = selColor;
    [self setupEndColor:selColor];
}

- (void)setupStartColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _startR = components[0];
    _startG = components[1];
    _startB = components[2];
}

- (void)setupEndColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _endR = components[0];
    _endG = components[1];
    _endB = components[2];
}



/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

-(void)scrollToolBarDidRepeatSelectedAtIndex:(NSInteger)index
{
    id<AKHScrollToolBarProtocol> view = self.contentViews[index];
    [view scrollToolBarDidRepeatSelectedAtIndex:index];
}

-(void)scrollToolBarDidSelectedAtIndex:(NSInteger)index
{
    id<AKHScrollToolBarProtocol> view = self.contentViews[index];
    [view scrollToolBarDidSelectedAtIndex:index];
}
@end
