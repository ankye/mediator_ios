//
//  ReaderEngineManager.m
//  创新版
//
//  Created by XuPeng on 16/5/20.
//  Copyright © 2016年 cxb. All rights reserved.
//

#import "ReaderEngineManager.h"
#import "FormatString.h"
#import "Paging.h"
#import "ReaderViewController.h"
#import "AKReaderSetting.h"

#define kHeaderViewX             _pageRect.origin.x
#define kHeaderViewY             0.0f
#define kHeaderViewWidth         _pageRect.size.width
#define kHeaderViewHeight        44.0f

#define kFooterViewX             _pageRect.origin.x
#define kFooterViewY             (_pageRect.origin.y + _pageRect.size.height)
#define kFooterViewWidth         _pageRect.size.width
#define kFooterViewHeight        44.0f

@interface ReaderEngineManager ()<PageAnimationViewControllerDelegate,ReaderViewControllerDelegate,AutomaticReadingViewControllerDelegate>

// 私有数据
@property (nonatomic, assign) BOOL                           isNextPage;// 是否为后翻，用来恢复翻页失败
@property (nonatomic, assign) BOOL                           isNewDataSource;// 是否为新数据源
@property (nonatomic, copy  ) NSString                       *txtContent;// 获取的内容缓存
@property (nonatomic, strong) Paging                         *paging;// 保存分页后的内容
@property (nonatomic, strong) ReaderViewController           *readerViewController;// 页面控制器
@property (nonatomic, strong) PageAnimationViewController    *pageAnimationViewController;// 翻页动画控制器
@property (nonatomic, strong) AutomaticReadingViewController *automaticReadingViewController;// 自动阅读控制器

// 页眉页脚
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) AKReaderSetting* settings;

@end


@implementation ReaderEngineManager {
    BOOL                  _isNight;
    NSInteger             _speed; // 自动阅读速度
}

// 防止修改出错
@synthesize  pageRect = _pageRect, currentPage = _currentPage, currentPageStr = _currentPageStr, backgroundImage = _backgroundImage,  bookName = _bookName, chapterName = _chapterName, animationTypes = _animationTypes,  pageCount = _pageCount, notesArr = _notesArr, bookmarksArr = _bookmarksArr,notesFunctionState = _notesFunctionState;



+ (ReaderEngineManager *)shareReaderEngineManager {
    ReaderEngineManager *pageGenerationManager = [[ReaderEngineManager alloc] init];
    return pageGenerationManager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置默认属性
        
        
        
        _pageRect = CGRectMake(15, 53, [[UIScreen mainScreen] bounds].size.width - 30, [[UIScreen mainScreen] bounds].size.height - 106);
        
        _pageCount = 0;
        _currentPage = 0;
        _backgroundImage = [AKReaderSetting sharedInstance].themeImage;
    
        _animationTypes = TheSimulationEffectOfPage;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - 刷新控制器
- (void)refreshViewController {
    [self initializeController];
}
#pragma mark - 夜间模式
- (void)nightModel:(BOOL)isNight {
    _isNight = isNight;
}
#pragma mark - 跳转到指定字符串页面
- (void)jumpStringPage:(NSString *)str {
    for (int i = 0; i < self.paging.pageCount; i++) {
        NSString *pageStr = [self.paging stringOfPage:i];
        if ([pageStr rangeOfString:str].location != NSNotFound) {
            // 跳转到i页，并结束
            _currentPage = i;
            return;
        }
    }
    _currentPage = 0;
}
#pragma mark - 开启/设置自动阅读
- (void)automaticReading:(AutomaticReadingTypes)automaticReadingTypes speed:(NSInteger)speed{
    
    // 自动阅读模式为0，则退出自动阅读
    if (automaticReadingTypes == 0) {
        _automaticReadingTypes = 0;
        [self refreshViewController];
        return;
    }
    
    // 删除手动翻页控制器
    [self.pageAnimationViewController removeFromParentViewController];
    [self.pageAnimationViewController.view removeFromSuperview];
    if (self.automaticReadingViewController) {
        return;
    }
    _automaticReadingTypes                       = automaticReadingTypes;
    _speed                                       = speed;
    self.readerViewController                    = [self createReaderViewController];
    self.automaticReadingViewController          = [AutomaticReadingViewController shareAutomaticReadingViewController:self.readerViewController topHeight:_pageRect.origin.y bottomHeight:self.view.frame.size.height - kFooterViewY  automaticReadingTypes:_automaticReadingTypes speed:speed];
    self.automaticReadingViewController.delegate = self;
    [self.view addSubview:self.automaticReadingViewController.view];
    [self.automaticReadingViewController refreshViewController];
}
#pragma mark - 设置自动阅读模式
- (void)automaticReadingModel:(AutomaticReadingTypes)automaticReadingTypes {
    if (_automaticReadingTypes == automaticReadingTypes) {
        return;
    }
    _currentPage--;
    if (_automaticReadingTypes == ScrollMode) {
        _currentPage--;
    }
    _automaticReadingTypes = automaticReadingTypes;
    [self.automaticReadingViewController automaticReadingModel:automaticReadingTypes];
    [self.automaticReadingViewController automaticStopReading];
}
#pragma mark - 设置自动阅读速度
- (void)automaticReadingSpeed:(NSInteger)speed {
    _speed = speed;
    [self.automaticReadingViewController automaticReadingSpeed:_speed];
}

#pragma mark 初始化控制器
- (void)initializeController {
    if (self.dataSource) {
        // 1、获取数据
        [self getData:CurrentContent];
    }
    if (_automaticReadingTypes == 0) {
        // 防止自动阅读存在
        if (self.automaticReadingViewController.view) {
            [self.automaticReadingViewController.view removeFromSuperview];
            self.automaticReadingViewController = nil;
        }
        // 创建翻页动画控制器
        [self addPageAnimationViewController];
    }
}

#pragma mark - 获取内容,并从新分页
- (BOOL)getData:(DataSourceTag)dataSourceTag {
    // 获取文件内容
    NSString *txtContent;
    if([self.dataSource respondsToSelector:@selector(ReaderEngineManagerDataSourceTagString:)]){
        txtContent = [self.dataSource ReaderEngineManagerDataSourceTagString:dataSourceTag];
    }
    if (!txtContent) {
        return NO;
    }
    self.txtContent = txtContent;
    
    // 格式化字符串
    self.txtContent = [FormatString formatString:self.txtContent];
    
    // 分页
    self.paging = [[Paging alloc] initWithFont:self.settings.fontSize withLineSpace:self.settings.lineSpaceType pageRect:_pageRect];
    [self.paging paginate:self.txtContent];
    
    _pageCount = [self.paging pageCount];
    return YES;
}

#pragma mark - 添加翻页控制器
- (void)addPageAnimationViewController {
    if (self.pageAnimationViewController) {
        [self.pageAnimationViewController.view removeFromSuperview];
        [self.pageAnimationViewController removeFromParentViewController];
    }
    // 创建页面控制器
    self.readerViewController = [self createReaderViewController];
    // 创建翻页控制器
    self.pageAnimationViewController          = [[PageAnimationViewController alloc] initWithViewController:_readerViewController className:[ReaderViewController class] backgroundImage:_backgroundImage];
    // 背面透明度
    [self.pageAnimationViewController setAlpha:0.4f];
    // 翻页方式
    [self.pageAnimationViewController setAnimationTypes:_animationTypes];
    self.pageAnimationViewController.delegate = self;
    [self addChildViewController:self.pageAnimationViewController];
    [self.view addSubview:self.pageAnimationViewController.view];
}
#pragma mark - 创建展示控制器
- (ReaderViewController *)createReaderViewController {
    // 创建页面展示控制器
    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithPageRect:self.pageRect fontSize:self.settings.fontSize lineSpaceType:self.settings.lineSpaceType fontColor:self.settings.textColor contentString:[self.paging stringOfPage:_currentPage] backgroundColorImage:_backgroundImage isNight:_isNight];
    
    [readerViewController openOrClosedNotesFunction:self.notesFunctionState];
    readerViewController.notesArr = self.notesArr;
    readerViewController.delegate = self;
    // 判断当前页面时候有书签
    NSString *currentPageStr = [self.paging stringOfPage:_currentPage];
    for (NSMutableDictionary *bookmarkDic in _bookmarksArr) {
        NSString *bookmarkStr = bookmarkDic[@"markContent"];
        NSString *str;
        if (bookmarkStr.length > 30) {
            str = [bookmarkStr substringToIndex:30];
        } else {
            str = [NSString stringWithString:bookmarkStr];
        }
        if ([currentPageStr rangeOfString:str].location != NSNotFound) {
            [readerViewController setBookmarkState:YES];
            break;
        }
    }

    // 获取页眉
    if([self.delegate respondsToSelector:@selector(ReaderEngineManagerHeader:)]){
        // 添加页眉页脚
        self.headerView = [self.delegate ReaderEngineManagerHeader:self];
        self.headerView.frame = CGRectMake(kHeaderViewX, kHeaderViewY, kHeaderViewWidth, kHeaderViewHeight);
        [readerViewController.view addSubview:self.headerView];
        
    }
    // 获取页脚
    if([self.delegate respondsToSelector:@selector(ReaderEngineManagerFooter:)]){
        self.footerView = [self.delegate ReaderEngineManagerFooter:self];
        self.footerView.frame = CGRectMake(kFooterViewX, kFooterViewY, kFooterViewWidth, kFooterViewHeight);
        [readerViewController.view addSubview:self.footerView];
       
    }
    // 如果是第一页，就绘制标题
    if (_currentPage == 0) {
        readerViewController.titleStr = _chapterName;
    }
    return readerViewController;
}

#pragma mark - ReaderViewController代理
#pragma mark 显示菜单
- (void)ReaderViewControllerOnClick:(ReaderViewController *)readerViewController {
    
    [self showOrHideMenu];
    
}


-(void)showOrHideMenu
{
    
    if(_isShowMenu){
        _isShowMenu = NO;
        if([self.delegate respondsToSelector:@selector(ReaderEngineManagerIsShowMenu:)]) {
            // 开启翻页
            [self.pageAnimationViewController setGestureRecognizerState:YES];
            [self.delegate ReaderEngineManagerIsShowMenu:NO];
        }
    }else{
        _isShowMenu = YES;
        if([self.delegate respondsToSelector:@selector(ReaderEngineManagerIsShowMenu:)]) {
            // 屏蔽翻页
            [self.pageAnimationViewController setGestureRecognizerState:NO];
            [self.delegate ReaderEngineManagerIsShowMenu:YES];
        }
    }
}

//#pragma mark 隐藏菜单
//- (void)ReaderViewControllerHiddenMenu:(ReaderViewController *)readerViewController {
//    if([self.delegate respondsToSelector:@selector(ReaderEngineManagerIsShowMenu:)]) {
//        // 开启翻页
//        [self.pageAnimationViewController setGestureRecognizerState:YES];
//        [self.delegate ReaderEngineManagerIsShowMenu:NO];
//    }
//}
#pragma mark 设置翻页手势状态
- (void)ReaderViewControllerPageState:(BOOL)pageState {
   [self.pageAnimationViewController setGestureRecognizerState:pageState];
}
#pragma mark 添加笔记
- (void)ReaderViewControllerAddNotes:(NSMutableDictionary *)notesContentDic {
    if([self.delegate respondsToSelector:@selector(ReaderEngineManagerAddNotes:)]) {
        [self.delegate ReaderEngineManagerAddNotes:notesContentDic];
    }
}
#pragma mark 删除笔记
- (void)ReaderViewControllerDeleteNotes:(NSMutableDictionary *)notesContentDic {
    if ([self.delegate respondsToSelector:@selector(ReaderEngineManagerDeleteNotes:)]) {
        [self.delegate ReaderEngineManagerDeleteNotes:notesContentDic];
    }
}

#pragma mark - PageAnimationViewController 代理
#pragma mark 向前翻页
- (UIViewController *)pageAnimationViewControllerBeforeViewController:(UIViewController *)viewController {
    NSLog(@"向前翻页");
    // 标记为向前翻页
    self.isNextPage = NO;
    // 1、当前页指针向前移动
    _currentPage --;
    if (_currentPage < 0) {
        // 新数据源设置为YES
        self.isNewDataSource = YES;
        // 获取上一章内容,并从新分页
        BOOL state = [self getData:PreviousContent];
        if (!state) {
            _currentPage++;
            return nil;
        }
        _currentPage = _pageCount - 1;
    }
    // 2、创建阅读页面
    return self.readerViewController = [self createReaderViewController];
}
#pragma mark 向后翻页
- (UIViewController *)pageAnimationViewControllerAfterViewController:(UIViewController *)viewController {
    NSLog(@"向后翻页");
    // 标记为向后翻页
    self.isNextPage = YES;
    
    // 1.当前页指针后移
    _currentPage ++;
    if (_currentPage >= _pageCount) {
        // 新数据源设置为YES
        self.isNewDataSource = YES;
        
        // 获取下一章内容，并从新分页
        BOOL state = [self getData:NextContent];
        if (!state) {
            _currentPage--;
            return nil;
        }
        _currentPage = 0;
    }
    // 2.创建阅读页面
    return self.readerViewController = [self createReaderViewController];
}
#pragma mark 动画开始
- (void)pageAnimationViewControllerToViewControllers:(UIViewController *)pendingViewControllers {
    NSLog(@"动画开始");
    // 屏蔽翻页手势
    
}
- (void)pageAnimationViewControllerCompleted:(BOOL)completed {
    NSLog(@"动画结束");
    // 翻页失败，进行还原
    if (!completed) {
        NSLog(@"翻页失败");
        if (self.isNextPage) {
            // 如果向后翻页，则向前恢复数据
            if (self.isNewDataSource) {
                // 回滚到上一章，当前页指针设置为最后一页
                [self getData:PreviousContent];
                _currentPage = _pageCount - 1;
            } else {
                _currentPage --;
            }
        } else {
            NSLog(@"%ld",(long)_currentPage);
            // 如果向前翻页，则向后恢复数据
            if (self.isNewDataSource) {
                // 回滚到下一章，当前指针指向第一页
                [self getData:NextContent];
                _currentPage = 0;
            } else {
                _currentPage ++;
            }
            NSLog(@"%ld",(long)_currentPage);
        }
    }
    self.isNewDataSource = NO;
}
#pragma mark - AutomaticReadingViewControllerDelegate 自动翻页代理
#pragma mark 获取下一页
- (UIViewController *)AutomaticReadingViewControllerNextViewController:(AutomaticReadingViewController *)automaticReadingViewController {
    // 1.当前页指针后移
    _currentPage ++;
    if (_currentPage >= _pageCount) {
        // 新数据源设置为YES
        self.isNewDataSource = YES;
        // 获取下一章内容，并从新分页
        BOOL state = [self getData:NextContent];
        if (!state) {
            _currentPage--;
            return nil;
        }
        _currentPage         = 0;
    }
    // 2.创建阅读页面
    return self.readerViewController = [self createReaderViewController];
}
#pragma mark 是否显示自动阅读菜单
- (void)AutomaticReadingViewControllerIsShowMenu:(BOOL)isShowMenu {
    if ([self.delegate respondsToSelector:@selector(ReaderEngineManagerAutomaticReadingIsShowMenu:)]) {
        [self.delegate ReaderEngineManagerAutomaticReadingIsShowMenu:isShowMenu];
    }
}
#pragma mark 退出自动阅读
- (void)AutomaticReadingViewControllerExit {
    _automaticReadingTypes = 0;
    [self refreshViewController];
}

#pragma mark - set/get



#pragma mark 设置页面大小
- (void)setPageRect:(CGRect)pageRect {
    _pageRect = pageRect;
}
- (CGRect)pageRect {
    return _pageRect;
}
#pragma mark 当前页位置
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    if (_currentPage >= _pageCount) {
        _currentPage = _pageCount - 1;
    }
    if (_currentPage < 0) {
        _currentPage = 0;
    }
}
- (NSInteger)currentPage {
    return _currentPage;
}
#pragma mark 当前页面内容
- (NSString *)currentPageStr {
    _currentPageStr = [NSString stringWithString:[self.paging stringOfPage:_currentPage]];
    return _currentPageStr;
}
#pragma mark 设置背景图
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    
    if (!backgroundImage) {
        return;
    }
    _backgroundImage = backgroundImage;
}
- (UIImage *)backgroundImage {
    return _backgroundImage;
}


#pragma mark 书籍名称
- (void)setBookName:(NSString *)bookName {
    if (!bookName) {
        return;
    }
    _bookName = bookName;
}
- (NSString *)bookName {
    return _bookName;
}
#pragma mark 章节名称
- (void)setChapterName:(NSString *)chapterName {
    _chapterName = chapterName;
}
- (NSString *)chapterName {
    return _chapterName;
}
#pragma mark 翻页模式
- (void)setAnimationTypes:(AKTurnPageAnimationStyle)animationTypes {
    _animationTypes = animationTypes;
}
- (AKTurnPageAnimationStyle)animationTypes {
    return _animationTypes;
}
#pragma mark 分页后的总页数
- (NSInteger)pageCount {
    return _pageCount;
}
#pragma mark 笔记数组
- (void)setNotesArr:(NSMutableArray *)notesArr {
    if (notesArr) {
        _notesArr = notesArr;
        self.readerViewController.notesArr = _notesArr;
    }
}
#pragma mark 书签数组
- (void)setBookmarksArr:(NSMutableArray *)bookmarksArr {
    if (bookmarksArr) {
        _bookmarksArr = bookmarksArr;
    }
}
#pragma mark 笔记功能设置
- (void)setNotesFunctionState:(BOOL)notesFunctionState {
    _notesFunctionState = notesFunctionState;
    [self.readerViewController openOrClosedNotesFunction:_notesFunctionState];
}
- (BOOL)notesFunctionState {
    return _notesFunctionState;
}
#pragma mark 设置菜单显示状态
//- (void)setIsShowMenu:(BOOL)isShowMenu {
//    if (isShowMenu) {
//        // 屏蔽笔记功能
//        self.notesFunctionState = NO;
//        // 屏蔽翻页手势
//        [self.pageAnimationViewController setGestureRecognizerState:NO];
//    }
//    self.isShowMenu = isShowMenu;
//}

-(AKReaderSetting*)settings{
    if(_settings == nil){
        _settings = [AKReaderSetting sharedInstance];
    }
    return _settings;
}
@end
