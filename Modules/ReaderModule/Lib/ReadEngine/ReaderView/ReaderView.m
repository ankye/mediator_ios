//
//  ReaderView.m
//  创新版
//
//  Created by XuPeng on 16/5/21.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "ReaderView.h"
#import <CoreText/CoreText.h>
#import <AVFoundation/AVSpeechSynthesis.h>
#import "MagnifyingGlassView.h"
#import "NotesMenuView.h"
#import "CursorView.h"
#import "NoteContentButton.h"
#import "EnterNotesView.h"

#define kOrangeColor    [UIColor colorWithRed:252 / 255.0 green:136 / 255.0 blue:68 / 255.0 alpha:1]
#define kBlueColor      [UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0  alpha:1]
#define kGreenColor     [UIColor colorWithRed:86 / 255.0 green:187 / 255.0 blue:54 / 255.0  alpha:1]
#define kPurpleColor    [UIColor colorWithRed:164 / 255.0 green:95 / 255.0 blue:223 / 255.0 alpha:1]


@interface ReaderView ()<NotesMenuViewDelegate,EnterNotesViewDelegate>

// 光标类
@property (nonatomic, strong) CursorView          *leftCursor;
@property (nonatomic, strong) CursorView          *rightCursor;
// 放大镜
@property (nonatomic, strong) MagnifyingGlassView *magnifierView;
@property (nonatomic, strong) UIImage             *magnifiterImage;
// 菜单类
@property (nonatomic, strong)NotesMenuView        *notesMenuView;

@end

@implementation ReaderView {
    BOOL                         _isNight; // 夜间模式
    CTFrameRef                   _ctFrame;
    NSMutableString              *_totalString;
    CGFloat                      _fontSize;
    UIColor                      *_fontColor;
    NSRange                      selectedRange;//高亮选择区
    NSRange                      _bottomLineRange;// 底部线条选择区
    UIColor                      *_bottomLineColor; // 底部线条颜色
    BOOL                         _dragEnd; // 拖动结束，绘制菜单
    NSInteger                    _selectCursor;// -1 是左光标，0 是未选中，1是右光标
    NSInteger                    _anchor; // 拖动时的锚点
    EnterNotesView               *_enterNotesView; // 输入评论页面
    UILongPressGestureRecognizer *_longPressGestureRecognizer; // 长按出现放大镜或调出笔记菜单
    BOOL                         _isShowMenuView; // 显示笔记菜单
    UIPanGestureRecognizer       *_panGestureRecognizer;// 拖动鼠标
    NSMutableDictionary          *_tapBottomLineDic; // 点击的笔记数组
}
#pragma mark 释放
- (void)dealloc
{
    if (_ctFrame != NULL) {
        CFRelease(_ctFrame);
    }
}
#pragma mark 初始化
- (instancetype)initWithFontSize:(CGFloat)fontSize pageRect:(CGRect)pageRect fontColor:(UIColor *)fontColor txtContent:(NSString *)txtContent backgroundColorImage:(UIImage *)backgroundColorImage isNight:(BOOL)isNight {
    self = [super initWithFrame:pageRect];
    if (self) {
        if (!txtContent) {
            txtContent = @"";
        }
        _totalString                = [NSMutableString stringWithString:txtContent];
        _fontSize                   = fontSize;
        _fontColor                  = fontColor;
        _isNight                    = isNight;
        self.magnifiterImage        = backgroundColorImage;
        // 启用用户交互
        self.userInteractionEnabled = YES;
        // 背景为空
        self.backgroundColor        = [UIColor clearColor];
        [self render];
        // 添加长按手势
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:_longPressGestureRecognizer];
        
        // 添加拖动手势
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        _panGestureRecognizer.enabled = NO;
        [self addGestureRecognizer:_panGestureRecognizer];
        
    }
    return self;
}
#pragma mark 长按
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    CGPoint point = [longPress locationInView:self];
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self removeCursor];
            [self hideMenuUI];
            if ([self isShowMenuView:point]) {
                _isShowMenuView = YES;
                return;
            }
            CFIndex index = [self getTouchIndexWithTouchPoint:point];
            _anchor = index;
            selectedRange.location = index;
            selectedRange.length = 1;
            self.magnifierView.touchPoint = point;
            [self setNeedsDisplay];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (_isShowMenuView) {
                return;
            }
            [self hideMenuUI];
            CFIndex index = [self getTouchIndexWithTouchPoint:point];
            if (index == -1) {
                return;
            }
            if (_anchor == -1) {
                _anchor = index;
            }
            [self removeCursor];
            self.magnifierView.touchPoint = point;
            // 计算选择区域
            if (index > _anchor) {
                selectedRange.location = _anchor;
                selectedRange.length = index - _anchor;
            } else {
                selectedRange.location = index;
                selectedRange.length = _anchor - index;
            }
            [self setNeedsDisplay];
            break;
        }
        default: {
            if (_isShowMenuView) {
                _isShowMenuView = NO;
                return;
            }
            [self removeMaginfierView];
            if (selectedRange.length <= 1) {
                CFIndex index = [self getTouchIndexWithTouchPoint:point];
                if (index != -1 && index < _totalString.length) {
                    //获取长按手指下面的词
                    NSRange range = [self characterRangeAtIndex:index];
                    selectedRange = NSMakeRange(range.location, range.length);
                } else {
                    break;
                }
            }
            if (selectedRange.length != 0 && selectedRange.location != NSNotFound ) {
                _dragEnd       = YES;
                // 长按结束，未选择光标
                _selectCursor  = 0;
                // 启动编辑模式
                [self startEditMode];
                [self setNeedsDisplay];
            }
            break;
        }
    }
}
#pragma mark 拖动
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取点击位置
    CGPoint point = [panGestureRecognizer locationInView:self];
    // 拖动开始
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (_leftCursor && CGRectContainsPoint(CGRectMake(_leftCursor.frame.origin.x - 22, _leftCursor.frame.origin.y + _leftCursor.frame.size.height - 88, 44, 88), point)) {
            //左
            _selectCursor = -1;
            // 移动的是左侧的光标，起始位置就是右光标
            _anchor = selectedRange.location + selectedRange.length;
            
        } else if (_rightCursor && CGRectContainsPoint(CGRectMake(_rightCursor.frame.origin.x - 22, _rightCursor.frame.origin.y, 44, 88), point)) {
            //右
            _selectCursor = 1;
            // 移动的是右侧的光标，起始位置就是左光标
            _anchor = selectedRange.location;
        }else{
            [self removeMaginfierView];
        }
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){ // 拖动中
        // 上下两个光标都未选择，就不响应手势
        if (_selectCursor == 0) {
            return;
        }
        
        CFIndex index = [self getTouchIndexWithTouchPoint:point];
        self.magnifierView.touchPoint = point;
        [self hideMenuUI];
        
        if (index == -1) {
            return;
        }
        // 计算选择区域
        if (index > _anchor) {
            selectedRange.location = _anchor;
            selectedRange.length = index - _anchor;
        } else {
            selectedRange.location = index;
            selectedRange.length = _anchor - index;
        }

    }else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded ||
              panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        _selectCursor    = 0;
        _dragEnd         = YES;
        // 移除放大镜
        [self removeMaginfierView];
    }
    [self setNeedsDisplay];
}

#pragma mark - 绘制相关方法
#pragma mark 设置绘制所需上下文
- (void)render
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:_totalString];
    
    [attrString setAttributes:self.coreTextAttributes range:NSMakeRange(0, attrString.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
    if (_ctFrame != NULL) {
        CFRelease(_ctFrame), _ctFrame = NULL;
    }
    _ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    CFRelease(path);
    CFRelease(frameSetter);
}
#pragma mark 设置文本属性
- (NSDictionary *)coreTextAttributes
{
    UIFont *font_                           = [UIFont fontWithName:@"HelveticaNeue" size:_fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    /**
     alignment //对齐方式
     firstLineHeadIndent //首行缩进
     headIndent //缩进
     tailIndent  //尾部缩进
     lineBreakMode  //断行方式
     maximumLineHeight  //最大行高
     minimumLineHeight  //最低行高
     lineSpacing  //行距
     paragraphSpacing  //段距
     paragraphSpacingBefore  //段首空间
     baseWritingDirection  //句子方向
     lineHeightMultiple  //可变行高,乘因数。
     hyphenationFactor //连字符属性
     */
    
    // 设置行间距
    paragraphStyle.lineSpacing      = font_.pointSize / 3;
    paragraphStyle.paragraphSpacing = font_.pointSize * 0.5;
    
    paragraphStyle.alignment        = NSTextAlignmentJustified;
    NSDictionary *dic               = @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:font_,NSForegroundColorAttributeName:_fontColor};
    
    return dic;
}

#pragma mark 重写父类的绘制方法
- (void)drawRect:(CGRect)rect
{
    if (!_ctFrame) return;
    CGContextRef context        = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGAffineTransform transform = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, transform);
    // 绘制选择区域
    [self showSelectRect:selectedRange];

    // 删除所有的小圆球按钮
    NSArray *subViewArr = self.subviews;
    for (UIView *button in subViewArr) {
        if ([[NSString stringWithUTF8String:object_getClassName(button)] isEqualToString:@"NoteContentButton"]) {
            [button removeFromSuperview];
        }
    }
    // 绘制底线
    for (NSMutableDictionary *dic in _bottomLineArr) {
        [self showBottomLine:dic];
    }
    
    CTFrameDraw(_ctFrame, context);
}
#pragma mark - 对外方法
#pragma mark 开启/关闭 笔记功能
- (void)openOrClosedNotesFunction:(BOOL)notesState {
    self.userInteractionEnabled = notesState;
}
#pragma mark 绘制章节名称
- (void)drawTitle:(NSString *)titleStr {
    if (!titleStr || [titleStr isEqualToString:@""]) {
        return;
    }
    
    // 计算行高度
    CGFloat lineHeight = [self getHeightByWidth:self.frame.size.width title:@"中文万维" font:[UIFont systemFontOfSize:_fontSize + 2]];
    // 计算实际高度
    CGFloat actualHeight = [self getHeightByWidth:self.frame.size.width title:titleStr font:[UIFont systemFontOfSize:_fontSize + 2]];
    UILabel *titleLabel;
    if (actualHeight > lineHeight) {
        // 章节名称
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, lineHeight * 2)];
        titleLabel.numberOfLines = 2;
    } else {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, lineHeight)];
    }

    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:_fontSize + 2];
    titleLabel.text = titleStr;
    titleLabel.textColor = _fontColor;
    [self addSubview:titleLabel];
    
    // 下划线
    UIView *titleLine = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height + 10, self.frame.size.width, 1)];
    titleLine.backgroundColor = _fontColor;
    [self addSubview:titleLine];
}
#pragma mark 是否需要显示笔记菜单
- (BOOL)isShowMenuView:(CGPoint)point {
    // 1.获取点击位置的文字索引
    CFIndex index = [self getTouchIndexWithTouchPoint:point];
    if (index == -1) {
        return NO;
    }
    // 2、根据索引，获得检索字符串
    NSString *markStr;
    if (index + 5 < _totalString.length) {
        markStr = [_totalString substringWithRange:NSMakeRange(index, 5)];
    } else {
        markStr = [_totalString substringWithRange:NSMakeRange(_totalString.length - 5, 5)];
    }
    // 3、查询检索字符串是否有下划线
    for (NSMutableDictionary *dic in _bottomLineArr) {
        NSString *bottomLineStr = dic[@"selectedContentStr"];
        if ([bottomLineStr rangeOfString:markStr].location != NSNotFound) {
            // 找到了，创建菜单
            _tapBottomLineDic = dic;
            double pointY     = [dic[@"noteContentButtonY"] doubleValue];
            point.y           = pointY;
            
            if (self.frame.size.height - point.y > 138 + 26 + 88) {
                [self showMenuUI:point isUp:YES notesContentDic:dic];
            } else {
                if (point.y < 138 + 26) {
                    [self showMenuUI:CGPointMake(0, self.frame.size.width / 2) isUp:YES notesContentDic:dic];
                } else {
                    [self showMenuUI:point isUp:NO notesContentDic:dic];
                }
            }
            // 启动编辑模式
            [self startEditMode];
            return YES;
        }
    }
    return NO;
}


#pragma mark - 内部方法
#pragma mark 获取行高度
- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text          = title;
    label.font          = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height      = label.frame.size.height;
    return height;
}
#pragma mark 获取色板颜色
- (UIColor *)getColor:(NSString *)colorStr {
    NSInteger colorIndex = [colorStr integerValue];
    UIColor *color;
    switch (colorIndex) {
        default:
        case 0: {
            color = kOrangeColor;
            break;
        }
        case 1: {
            color = kBlueColor;
            break;
        }
        case 2: {
            color = kGreenColor;
            break;
        }
        case 3: {
            color = kPurpleColor;
            break;
        }
    }
    return color;
}
#pragma mark 启动编辑模式
- (void)startEditMode {
    // 启动拖动手势
    _panGestureRecognizer.enabled = YES;
    // 启动编辑模式
    [self.delegate readerViewStartEditMode:self];
}
#pragma mark 关闭编辑模式
- (void)closeEditMode {
    // 关闭拖动手势
    _panGestureRecognizer.enabled = NO;
    // 关闭编辑模式
    [self.delegate readerViewCloseEditMode:self];
}

#pragma mark 计算范围  及相关数组
- (NSMutableArray *)calculateRangeArrayWithKeyWord:(NSString *)searchWord{
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < searchWord.length; i ++) {
        [blankWord appendString:@" "];
    }
    NSMutableArray *feedBackArray = [NSMutableArray array];
    for (int i = 0; i < INT_MAX; i++){
        if ([_totalString rangeOfString:searchWord options:1].location != NSNotFound){
            NSRange newRange = [_totalString rangeOfString:searchWord options:1];
            [feedBackArray addObject:NSStringFromRange(newRange)];
            [_totalString replaceCharactersInRange:newRange withString:blankWord];
            
        }else{
            break;
        }
    }
    return feedBackArray;
}
#pragma mark 帧信息
- (CTFrameRef)getCTFrame {
    return _ctFrame;
}

#pragma mark 最后一行位置
- (CGFloat)get_LastLinePosition {
    
    NSArray *lines   = (NSArray*)CTFrameGetLines([self getCTFrame]);
    if (lines.count == 0) {
        return 0;
    }
    CGPoint *origins = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins([self getCTFrame], CFRangeMake(0,0), origins);
    CGPoint origin   = origins[lines.count - 1];
    
    CTLineRef line       = (__bridge CTLineRef) [lines objectAtIndex:lines.count - 1];
    CGFloat ascent, descent;
    CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
    CGRect selectionRect = CGRectMake(0, origin.y - descent,0, 0);
    
    CGPoint rightCursorPoint    = CGRectFromString(NSStringFromCGRect(selectionRect)).origin;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform                   = CGAffineTransformScale(transform, 1.f, -1.f);
    rightCursorPoint            = CGPointApplyAffineTransform(rightCursorPoint, transform);
    free(origins);
    return rightCursorPoint.y;
}
#pragma mark 绘制选择区域
- (void)showSelectRect:(NSRange)selectRect{
    if (selectRect.length == 0 || selectRect.location == NSNotFound) {
        return;
    }
    NSMutableArray *pathRects = [[NSMutableArray alloc] init];
    NSArray *lines            = (NSArray*)CTFrameGetLines([self getCTFrame]);
    CGPoint *origins          = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins([self getCTFrame], CFRangeMake(0,0), origins);

    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line       = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange    = CTLineGetStringRange(line);
        NSRange range        = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:selectRect];
        if (intersection.length > 0) {

            CGFloat xStart       = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);//获取整段文字中charIndex位置的字符相对line的原点的x值

            CGFloat xEnd         = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGPoint origin       = origins[i];
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(origin.x + xStart, origin.y - descent, xEnd - xStart, ascent + descent);
            [pathRects addObject:NSStringFromCGRect(selectionRect)];//放入数组
        }
    }
    free(origins);
    [self drawPathFromRects:pathRects];//画选择框
}
#pragma mark 绘制底线
- (void)showBottomLine:(NSMutableDictionary *)bottomLineDic {
    NSString *bottomLineStr = bottomLineDic[@"selectedContentStr"];
    // 如果一条笔记被分到了两个页面
    // 检查头和尾
    NSString *headStr, *tailStr;
    NSRange bottomLineRange, headRange, tailRange;
    
    if (bottomLineStr.length >= 10) {
        headStr = [bottomLineStr substringToIndex:10];
        tailStr = [bottomLineStr substringFromIndex:bottomLineStr.length - 10];
    } else {
        headStr = tailStr = bottomLineStr;
    }
    
    headRange = [_totalString rangeOfString:headStr];
    tailRange = [_totalString rangeOfString:tailStr];

    if (headRange.location != NSNotFound && tailRange.location == NSNotFound) {
        bottomLineRange.location = headRange.location;
        bottomLineRange.length   = _totalString.length - headRange.location;
    } else if (headRange.location == NSNotFound && tailRange.location != NSNotFound) {
        bottomLineRange.location = 0;
        bottomLineRange.length   = tailRange.location + tailRange.length;
    } else {
        bottomLineRange          = [_totalString rangeOfString:bottomLineStr];
    }
    
    if (bottomLineRange.length == 0 || bottomLineRange.location == NSNotFound) {
        return;
    }
    NSMutableArray *pathRects = [[NSMutableArray alloc] init];
    NSArray *lines            = (NSArray*)CTFrameGetLines([self getCTFrame]);
    CGPoint *origins          = (CGPoint*)malloc([lines count] * sizeof(CGPoint));
    CTFrameGetLineOrigins([self getCTFrame], CFRangeMake(0,0), origins);
    
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line       = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange lineRange    = CTLineGetStringRange(line);
        NSRange range        = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection = [self rangeIntersection:range withSecond:bottomLineRange];
        if (intersection.length > 0) {
            
            CGFloat xStart       = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);//获取整段文字中charIndex位置的字符相对line的原点的x值
            
            CGFloat xEnd         = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGPoint origin       = origins[i];
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGRect selectionRect = CGRectMake(origin.x + xStart, origin.y - descent, xEnd - xStart, 2);
            [pathRects addObject:NSStringFromCGRect(selectionRect)];//放入数组
        }
    }
    free(origins);
    [self drawBottomLineFromRects:pathRects bottomLineDic:bottomLineDic];// 绘制底线
}

#pragma mark 绘制底线
- (void)drawBottomLineFromRects:(NSMutableArray*)array bottomLineDic:(NSMutableDictionary *)bottomLineDic {
    UIColor *color = [self getColor:bottomLineDic[@"color"]];
    if (array==nil || [array count] == 0) {
        return;
    }

    // 创建一个Path句柄
    CGMutablePathRef _path = CGPathCreateMutable();
    [_bottomLineColor setFill];
    for (int i = 0; i < [array count]; i++) {
        CGRect firstRect = CGRectFromString([array objectAtIndex:i]);
        CGPathAddRect(_path, NULL, firstRect);//向path路径添加一个矩形
    }
    // 绘制右下角按钮
    [self setNoteContentButtonFrame:array bottomLineDic:bottomLineDic];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], components[3]);//填充颜色
    
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);//用当前的填充颜色或样式填充路径线段包围的区域。
    CGPathRelease(_path);
}

#pragma mark 画背景色
- (void)drawPathFromRects:(NSMutableArray*)array
{
    if (array==nil || [array count] == 0) {
        return;
    }
    CGFloat height = 0.0f;
    // 创建一个Path句柄
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0  alpha:0.2f] setFill];
    for (int i = 0; i < [array count]; i++) {
        CGRect firstRect = CGRectFromString([array objectAtIndex:i]);
        // 绘制区域的高度
        height           = firstRect.size.height;
        CGPathAddRect(_path, NULL, firstRect);//向path路径添加一个矩形
    }
    // 绘制光标
    [self showCursor:height];
    [self resetCursor:array];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);//用当前的填充颜色或样式填充路径线段包围的区域。
    CGPathRelease(_path);
}

#pragma mark 设置内容按钮位置
- (void)setNoteContentButtonFrame:(NSMutableArray *)rectArray bottomLineDic:(NSMutableDictionary *)bottomLineDic {
    UIColor *color = [self getColor:bottomLineDic[@"color"]];
    NSString *noteContentStr = bottomLineDic[@"noteContentStr"];

    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform                   = CGAffineTransformScale(transform, 1.f, -1.f);
    CGPoint rightCursorPoint    = CGRectFromString([rectArray lastObject]).origin;
    rightCursorPoint.x          = rightCursorPoint.x + CGRectFromString([rectArray lastObject]).size.width;
    rightCursorPoint            = CGPointApplyAffineTransform(rightCursorPoint, transform);

    // 记录末尾位置,数值类型不能直接保存，转为字符串形式保存
    bottomLineDic[@"noteContentButtonY"] = [NSString stringWithFormat:@"%f",rightCursorPoint.y];
    
    // 如果笔记内容不为空，就绘制笔记详情按钮
    if (noteContentStr && ![noteContentStr isEqualToString:@""]) {
        NoteContentButton *noteContentButton = [NoteContentButton shareNoteContentButton:color noteContent:noteContentStr isNight:_isNight];
        noteContentButton.frame = CGRectMake(rightCursorPoint.x, rightCursorPoint.y - 8, 44, 44);
        [self addSubview:noteContentButton];
        [self sendSubviewToBack:noteContentButton];
    }
}

#pragma mark 重新设置光标的位置
- (void)resetCursor:(NSMutableArray*)rectArray{
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform                   = CGAffineTransformScale(transform, 1.f, -1.f);

    CGPoint leftCursorPoint     = CGRectFromString([rectArray objectAtIndex:0]).origin;
    leftCursorPoint             = CGPointApplyAffineTransform(leftCursorPoint, transform);
    _leftCursor.setupPoint      = leftCursorPoint;

    CGPoint rightCursorPoint    = CGRectFromString([rectArray lastObject]).origin;
    rightCursorPoint.x          = rightCursorPoint.x + CGRectFromString([rectArray lastObject]).size.width;
    rightCursorPoint            = CGPointApplyAffineTransform(rightCursorPoint, transform);
    _rightCursor.setupPoint     = rightCursorPoint;
    
    if (_dragEnd) {
        // 创建笔记数组
        NSMutableDictionary *notesContentDic = [NSMutableDictionary dictionary];
        notesContentDic[@"selectedContentStr"] = [_totalString substringWithRange:selectedRange];
        
        if (self.frame.size.height- rightCursorPoint.y > 138 + 26 + 88) {
            [self showMenuUI:rightCursorPoint isUp:YES notesContentDic:notesContentDic];
        } else {
            if (leftCursorPoint.y < 138 + 26) {
                [self showMenuUI:CGPointMake(0, self.frame.size.width / 2) isUp:YES notesContentDic:notesContentDic];
            } else {
                [self showMenuUI:leftCursorPoint isUp:NO notesContentDic:notesContentDic];
            }
        }
    }
    _dragEnd = NO;
}

#pragma mark 初始化光标
- (void)showCursor:(CGFloat)height {
    if (selectedRange.length == 0 || selectedRange.location == NSNotFound ) {
        return;
    }
    
    [self removeCursor];
    _leftCursor  = [[CursorView alloc] initWithType:CursorLeft andHeight:height byDrawColor:[UIColor blueColor]];
    _rightCursor = [[CursorView alloc] initWithType:CursorRight andHeight:height byDrawColor:[UIColor blueColor]];
    [self addSubview:_leftCursor];
    [self addSubview:_rightCursor];
    [self setNeedsDisplay];
}
#pragma mark 隐藏menu
- (void)hideMenuUI {
    [self.notesMenuView removeFromSuperview];
}

#pragma mark 显示menu
- (void)showMenuUI:(CGPoint)point isUp:(BOOL)isUp notesContentDic:(NSMutableDictionary *)notesContentDic {
    if (self.notesMenuView) {
        [self.notesMenuView removeFromSuperview];
    }
    self.notesMenuView                 = [NotesMenuView shareNotesMenuView:point isUp:isUp];
    self.notesMenuView.delegate        = self;
    self.notesMenuView.notesContentDic = notesContentDic;
    [self addSubview:self.notesMenuView];
    self.notesMenuView.alpha = 0.0f;
    
    CGAffineTransform newTransform =
    CGAffineTransformScale(self.notesMenuView.transform, 0.9, 0.9);
    [self.notesMenuView setTransform:newTransform];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.notesMenuView.alpha = 1.0f;
        CGAffineTransform newTransform =
        CGAffineTransformScale(self.notesMenuView.transform, 1.1, 1.1);
        [self.notesMenuView setTransform:newTransform];
    } completion:^(BOOL finished) {
        self.notesMenuView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark 移除放大镜
- (void)removeMaginfierView {
    if (_magnifierView) {
        [_magnifierView removeFromSuperview];
        _magnifierView = nil;
    }
}

#pragma mark 移除光标
- (void)removeCursor{
    if (_leftCursor) {
        [_leftCursor removeFromSuperview];
        _leftCursor = nil;
    }
    if (_rightCursor) {
        [_rightCursor removeFromSuperview];
        _rightCursor = nil;
    }
}

#pragma mark 根据用户手指的坐标获得 手指下面文字在整页文字中的index
- (CFIndex)getTouchIndexWithTouchPoint:(CGPoint)touchPoint{
    CTFrameRef textFrame = [self getCTFrame];
    NSArray *lines       = (NSArray*)CTFrameGetLines(textFrame);
    if (!lines) {
        return -1;
    }
    CFIndex index       = -1;
    NSInteger lineCount = [lines count];
    CGPoint *origins    = (CGPoint*)malloc(lineCount * sizeof(CGPoint));
    if (lineCount != 0) {
        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), origins);
        
        for (int i = 0; i < lineCount; i++){
            CGPoint baselineOrigin = origins[i];
            baselineOrigin.y       = CGRectGetHeight(self.frame) - baselineOrigin.y;
            CTLineRef line         = (__bridge CTLineRef)[lines objectAtIndex:i];
            // 上行高度，下行高度，行间距
            CGFloat ascent, descent, leading;
            // 行宽度
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineFrame       = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, self.frame.size.width, ascent + descent * 2);
            if (CGRectContainsPoint(lineFrame, touchPoint)){
                index = CTLineGetStringIndexForPosition(line, touchPoint);
                if (index >= _totalString.length) {
                    index = _totalString.length - 1;
                }
                NSString *string = [_totalString substringWithRange:NSMakeRange(index, 1)];
                if ([string isEqualToString:@"　"]) {
                    index --;
                }
                break;
            }
        }
    }
    free(origins);
    return index;
}

#pragma mark 获取手指所在段
- (NSRange)characterRangeAtIndex:(NSInteger)index {
    NSRange range = NSMakeRange(index, 1);
    NSInteger beforeIndex = 0, afterInxed = _totalString.length;
    
    // 获取段首位置
    for (NSInteger i = index; i >= 0; i--) {
        range.location = i - 1;
        range.length = 2;
        NSString *str = [_totalString substringWithRange:range];
        if ([str isEqualToString:@"　　"]) {
            beforeIndex = i + 1;
            break;
        }
    }

    // 获得段尾位置
    for (NSInteger i = index; i < _totalString.length; i ++) {
        range.location = i;
        range.length = 1;
        NSString *str = [_totalString substringWithRange:range];
        if ([str isEqualToString:@"\n"]) {
            afterInxed = i;
            break;
        }
    }
    range = NSMakeRange(beforeIndex, afterInxed - beforeIndex );
    return range;
}
//字符串反转
#pragma mark 反转字符串
- (NSString *)stringReverse:(NSString *)string {
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i = [string length]; i > 0; i--) {
        [s appendString:[string substringWithRange:NSMakeRange(i-1,1)]];
    }
    return s;
}

#pragma mark Range区域
- (NSRange)rangeIntersection:(NSRange)first withSecond:(NSRange)second
{
    NSRange result = NSMakeRange(NSNotFound, 0);
    if (first.location > second.location)
    {
        NSRange tmp = first;
        first       = second;
        second      = tmp;
    }
    if (second.location < first.location + first.length)
    {
        result.location = second.location;
        NSUInteger end  = MIN(first.location + first.length, second.location + second.length);
        result.length   = end - result.location;
    }
    return result;
}
#pragma mark 重置
- (void)resetting {
    selectedRange.location = 0;
    selectedRange.length   = 0;
    [self removeCursor];
    [self setNeedsDisplay];
}
#pragma mark 保存笔记
- (void)saveNotes {
    // 查询笔记是否已经存在
    NSString *enterSelectedContentStr = _enterNotesView.selectedContentStr;
    for (NSMutableDictionary *dic in _bottomLineArr) {
        NSString *selectedContentStr = dic[@"selectedContentStr"];
        if ([selectedContentStr isEqualToString:enterSelectedContentStr]) {
            if (![_enterNotesView.noteContentStr isEqualToString:@"请输入您想说的话"]) {
                dic[@"noteContentStr"]     = _enterNotesView.noteContentStr;
            } else {
                dic[@"noteContentStr"] = @"";
            }
            [self resetting];
            [self hideMenuUI];
            [self.delegate readerViewAddNotes:self notesContentDic:dic];
            return;
        }
    }
    
    NSMutableDictionary *bottomLineDic   = [NSMutableDictionary dictionary];
    bottomLineDic[@"color"]              = _enterNotesView.color;
    
    if (![_enterNotesView.noteContentStr isEqualToString:@"请输入您想说的话"]) {
        bottomLineDic[@"noteContentStr"]     = _enterNotesView.noteContentStr;
    }
    bottomLineDic[@"selectedContentStr"] = _enterNotesView.selectedContentStr;
    
    if (!_bottomLineArr) {
        _bottomLineArr = [NSMutableArray array];
    }
    [_bottomLineArr addObject:bottomLineDic];
    [self resetting];
    [self hideMenuUI];
    [self.delegate readerViewAddNotes:self notesContentDic:bottomLineDic];
}
#pragma mark - EnterNotesView 代理
- (void)enterNotesViewGoBack:(EnterNotesView *)enterNotesView isSave:(BOOL)isSave {
    // 关闭编辑模式
    [self closeEditMode];
    
    if (isSave) {
        [self saveNotes];
    }
    CGRect rect   = _enterNotesView.frame;
    rect.origin.y = [[UIScreen mainScreen] bounds].size.height;
    // 收起评论页
    [UIView animateWithDuration:0.3f animations:^{
        _enterNotesView.frame = rect;
    } completion:^(BOOL finished) {
        [_enterNotesView removeFromSuperview];
        _enterNotesView = nil;
    }];
}

#pragma mark - NotesMenuView 代理
#pragma mark 添加下划线
- (void)drawBottomLineColor:(NSInteger)colorIndex {
    // 添加下划线，但是不移除笔记菜单
    // 已经存在，就改变颜色
    NSString *enterSelectedContentStr = self.notesMenuView.notesContentDic[@"selectedContentStr"];
    for (NSMutableDictionary *dic in _bottomLineArr) {
        NSString *selectedContentStr = dic[@"selectedContentStr"];
        if ([selectedContentStr isEqualToString:enterSelectedContentStr]) {
            dic[@"color"] = [NSString stringWithFormat:@"%ld",colorIndex];
            [self resetting];
            [self.delegate readerViewAddNotes:self notesContentDic:dic];
            return;
        }
    }
    self.notesMenuView.notesContentDic[@"color"] = [NSString stringWithFormat:@"%ld",colorIndex];
    // 不存在，就创建，并且调起笔记编辑框
    [self notesMenuViewNotes:_notesMenuView];
}
#pragma mark 删除按钮
- (void)notesMenuViewDelete:(NotesMenuView *)notesMenuView {
    // 关闭编辑模式
    [self closeEditMode];
    // 调用代理，删除数据
    [self.delegate readerViewDeleteNotes:self notesContentDic:notesMenuView.notesContentDic];

    [_bottomLineArr removeObject:self.notesMenuView.notesContentDic];
    // 从新绘制
    [self resetting];
    [self hideMenuUI];
}
#pragma mark 复制按钮
- (void)notesMenuViewCopy:(NotesMenuView *)notesMenuView {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setString:notesMenuView.notesContentDic[@"selectedContentStr"]];
    [self closeEditMode];
    [self resetting];
    [self hideMenuUI];
}
#pragma mark 笔记按钮
- (void)notesMenuViewNotes:(NotesMenuView *)notesMenuView {
    if (!self.notesMenuView.notesContentDic[@"color"]) {
        self.notesMenuView.notesContentDic[@"color"] = @"0";
    }
    // 弹出评论框
    _enterNotesView                              = [[EnterNotesView alloc] init];
    _enterNotesView.noteContentStr               = self.notesMenuView.notesContentDic[@"noteContentStr"];
    _enterNotesView.selectedContentStr           = self.notesMenuView.notesContentDic[@"selectedContentStr"];
    _enterNotesView.color                        = self.notesMenuView.notesContentDic[@"color"];
    
    _enterNotesView.delegate                     = self;
    _enterNotesView.frame                        = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    // 添加到主视图上
    [[[UIApplication sharedApplication] keyWindow] addSubview:_enterNotesView];
    [UIView animateWithDuration:0.3f animations:^{
        _enterNotesView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }];
    [self resetting];
    [self hideMenuUI];
}
#pragma mark 收起菜单
- (void)deleteNotesMenuView:(NotesMenuView *)notesMenuView {
    // 关闭编辑模式
    [self closeEditMode];
    [self resetting];
    [self hideMenuUI];
}
#pragma mark - get/set
#pragma mark 放大镜
- (MagnifyingGlassView *)magnifierView {
    if (_magnifierView == nil) {
        _magnifierView = [[MagnifyingGlassView alloc] init];
        if (_magnifiterImage == nil) {
            _magnifierView.backgroundColor = [UIColor clearColor];
        }else{
            _magnifierView.backgroundColor = [UIColor colorWithPatternImage:_magnifiterImage];
        }
        _magnifierView.viewToMagnify = self;
        [self addSubview:_magnifierView];
    }
    return _magnifierView;
}
#pragma mark 笔记数组
- (void)setBottomLineArr:(NSMutableArray *)bottomLineArr {
    _bottomLineArr = bottomLineArr;
    // 从新绘制页面
    [self resetting];
    [self hideMenuUI];
}
#pragma mark 最后一行位置
- (CGFloat)lastLinePosition {
    if (_lastLinePosition != 0.0f) {
        return _lastLinePosition;
    } else {
        // 计算最后一行位置
        _lastLinePosition = [self get_LastLinePosition];
        return _lastLinePosition;
    }
}
@end
