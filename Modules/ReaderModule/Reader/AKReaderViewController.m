//
//  ViewController.m
//  ReadEngine
//
//  Created by XuPeng on 16/9/2.
//  Copyright © 2016年 XP. All rights reserved.
//

#import "AKReaderViewController.h"

#import "PageGenerationHeader.h"
#import "PageGenerationFooter.h"
#import "PageGenerationManager.h"
#import "BookDatabase.h"
#import "NSFileManager+FileCategory.h"

#import "YDirectoryViewController.h"
#import "YMenuViewController.h"
#import "YReaderManager.h"
#import "YNetworkManager.h"
#import "YReaderSettings.h"
#import "YSummaryViewController.h"


#define EquipmentWidth     [[UIScreen mainScreen] bounds].size.width
#define EquipmentHeight    [[UIScreen mainScreen] bounds].size.height


@interface AKReaderViewController ()<PageGenerationManagerDataSource,PageGenerationManagerDelegate>

//现在需要获取小说数据下标
@property (nonatomic, assign) NSInteger currDataIndex;
//现在需要获取小说数据对象
@property(nonatomic,strong)BookChapter * currBookChapter;


@property (strong, nonatomic) YReaderManager *readerManager;
@property (strong, nonatomic) YNetworkManager *netManager;

@property (strong, nonatomic) YDirectoryViewController *directoryVC;
@property (strong, nonatomic) YSummaryViewController *summaryVC;
@property (strong, nonatomic) YReaderSettings *settings;


@end

@implementation AKReaderViewController {
    
    PageGenerationManager   *_pageGenerationManager;
    NSMutableArray          *_notesModelArr;
    NSMutableArray          *_bookmarksModelArr;
    UIView                  *_bottomMenuView;
    UIView                  *_topMenuView;
    UIView                  *_setView;
    UIView                  *_automaticMenuView;
    NSInteger               speed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    _notesModelArr                            = [NSMutableArray array];
    speed                                     = 1;
    // 创建阅读引擎
    _pageGenerationManager                    = [PageGenerationManager sharePageGenerationManager];
    _pageGenerationManager.dataSource         = self;
    _pageGenerationManager.delegate = self;
//    // 设置字体大小
//    _pageGenerationManager.fontSize           = 15;
//    // 设置页面位置
//    _pageGenerationManager.pageRect           = CGRectMake(20, 53, EquipmentWidth - 40, EquipmentHeight - 106);
    // 设置背景颜色
 //   _pageGenerationManager.backgroundImage    = [UIImage imageWithColor:[UIColor redColor]];
//    // 设置字体颜色
//    _pageGenerationManager.fontColor          = [UIColor blackColor];
//    // 设置翻页动画
    _pageGenerationManager.animationTypes     = TheSimulationEffectOfPage;
    // 开启笔记功能
    _pageGenerationManager.notesFunctionState = YES;
    // 设置笔记数组
    _pageGenerationManager.notesArr           = _notesModelArr;
//    // 设置书签数组
//    _pageGenerationManager.bookmarksArr       = _bookmarksModelArr;
//    // 设置当前页
//    _pageGenerationManager.currentPage        = 0;
    // 刷新阅读器
    [_pageGenerationManager refreshViewController];
    [self.view addSubview:_pageGenerationManager.view];
    
    [self setupViews];

}
- (void)automaticReadButtonClick {
  //  [self removeMenuView];
    [_pageGenerationManager automaticReading:1 speed:speed];
}
//- (UIButton *)createSetButton {
//    UIButton *button                = [UIButton buttonWithType:0];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    button.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_setView addSubview:button];
//    return button;
//}
//- (void)setButtonClick {
//    if (!_setView) {
//        _setView                 = [[UIView alloc] initWithFrame:CGRectMake(0, EquipmentHeight - 44 - 44, EquipmentWidth, 44)];
//        _setView.backgroundColor = [UIColor colorWithRed:0.828 green:0.580 blue:0.542 alpha:1.000];
//
//        UIButton *button1        = [self createSetButton];
//        button1.frame            = CGRectMake(0, 0, EquipmentWidth / 4, 44);
//        button1.tag              = 1;
//        [button1 setTitle:@"仿真" forState:UIControlStateNormal];
//
//        UIButton *button2        = [self createSetButton];
//        button2.frame            = CGRectMake(EquipmentWidth / 4, 0, EquipmentWidth / 4, 44);
//        button2.tag              = 2;
//        [button2 setTitle:@"覆盖" forState:UIControlStateNormal];
//
//        UIButton *button3        = [self createSetButton];
//        button3.frame            = CGRectMake(EquipmentWidth / 4 * 2, 0, EquipmentWidth / 4, 44);
//        button3.tag              = 3;
//        [button3 setTitle:@"滑动" forState:UIControlStateNormal];
//
//        UIButton *button4        = [self createSetButton];
//        button4.frame            = CGRectMake(EquipmentWidth / 4 * 3, 0, EquipmentWidth / 4, 44);
//        button4.tag              = 4;
//        [button4 setTitle:@"无" forState:UIControlStateNormal];
//    }
//    [self.view addSubview:_setView];
//}
- (void)buttonClick:(UIButton *)button {
    _pageGenerationManager.animationTypes = button.tag - 1;
}
- (void)goBackClick {

    [[UIApplication sharedApplication] setStatusBarHidden:NO];

//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//- (void)addMenuView {
//    if (!_topMenuView) {
//        _topMenuView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, EquipmentWidth, 64)];
//        _topMenuView.backgroundColor = [UIColor colorWithRed:0.828 green:0.580 blue:0.542 alpha:1.000];
//        UIButton *goBack             = [UIButton buttonWithType:0];
//        goBack.frame                 = CGRectMake(10, 20, 40, 44);
//        [goBack setTitle:@"返回" forState:UIControlStateNormal];
//        [goBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [goBack addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
//        [_topMenuView addSubview:goBack];
//    }
//    if (!_bottomMenuView) {
//        _bottomMenuView                 = [[UIView alloc] initWithFrame:CGRectMake(0, EquipmentHeight - 44, EquipmentWidth, 44)];
//        _bottomMenuView.backgroundColor = [UIColor colorWithRed:0.828 green:0.580 blue:0.542 alpha:1.000];
//        UIButton *automaticReadButton   = [UIButton buttonWithType:0];
//        automaticReadButton.frame       = CGRectMake(50, 0, 100, 44);
//        [automaticReadButton setTitle:@"自动阅读" forState:UIControlStateNormal];
//        [automaticReadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [automaticReadButton addTarget:self action:@selector(automaticReadButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomMenuView addSubview:automaticReadButton];
//
//        UIButton *setButton             = [UIButton buttonWithType:0];
//        setButton.frame                 = CGRectMake(EquipmentWidth - 150, 0, 100, 44);
//        [setButton setTitle:@"设置" forState:UIControlStateNormal];
//        [setButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [setButton addTarget:self action:@selector(setButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomMenuView addSubview:setButton];
//        
//    }
//    [self.view addSubview:_topMenuView];
//    [self.view addSubview:_bottomMenuView];
//}
//- (void)removeMenuView {
//    [_pageGenerationManager refreshViewController];
//    [_topMenuView removeFromSuperview];
//    [_bottomMenuView removeFromSuperview];
//    [_setView removeFromSuperview];
//}
//
//- (void)addAutomaticMenuView {
//    if (!_automaticMenuView) {
//        _automaticMenuView                     = [[UIView alloc] initWithFrame:CGRectMake(0, EquipmentHeight - 120, EquipmentWidth, 120)];
//        _automaticMenuView.backgroundColor     = [UIColor colorWithRed:0.828 green:0.580 blue:0.542 alpha:1.000];
//
//
//        UIButton *speedAdd                     = [UIButton buttonWithType:0];
//        speedAdd.frame                         = CGRectMake(10, 0, 50, 40);
//        [speedAdd setTitle:@"速度+" forState:UIControlStateNormal];
//        [speedAdd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        speedAdd.tag                           = 1;
//        speedAdd.titleLabel.textAlignment      = NSTextAlignmentLeft;
//        [speedAdd addTarget:self action:@selector(speedButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_automaticMenuView addSubview:speedAdd];
//
//        UIButton *speedSubtract                = [UIButton buttonWithType:0];
//        speedSubtract.frame                    = CGRectMake(EquipmentWidth - 60, 0, 50, 40);
//        [speedSubtract setTitle:@"速度-" forState:UIControlStateNormal];
//        [speedSubtract setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        speedSubtract.tag                      = 2;
//        speedSubtract.titleLabel.textAlignment = NSTextAlignmentRight;
//        [speedSubtract addTarget:self action:@selector(speedButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_automaticMenuView addSubview:speedSubtract];
//
//        UIButton *coverPatterns                = [UIButton buttonWithType:0];
//        coverPatterns.frame                    = CGRectMake(0, 40, 100, 40);
//        [coverPatterns setTitle:@"覆盖模式" forState:UIControlStateNormal];
//        [coverPatterns setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        coverPatterns.tag                      = 1;
//        coverPatterns.titleLabel.textAlignment = NSTextAlignmentLeft;
//        [coverPatterns addTarget:self action:@selector(patternsButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_automaticMenuView addSubview:coverPatterns];
//
//        UIButton *scrollMode                   = [UIButton buttonWithType:0];
//        scrollMode.frame                       = CGRectMake(EquipmentWidth - 100, 40, 100, 40);
//        [scrollMode setTitle:@"滚动模式" forState:UIControlStateNormal];
//        [scrollMode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        scrollMode.tag                         = 2;
//        scrollMode.titleLabel.textAlignment    = NSTextAlignmentRight;
//        [scrollMode addTarget:self action:@selector(patternsButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_automaticMenuView addSubview:scrollMode];
//
//        UIButton *stopButton                   = [UIButton buttonWithType:0];
//        stopButton.frame                       = CGRectMake(0, 80, EquipmentWidth, 40);
//        [stopButton setTitle:@"退出自动阅读" forState:UIControlStateNormal];
//        [stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        stopButton.titleLabel.textAlignment    = NSTextAlignmentCenter;
//        [stopButton addTarget:self action:@selector(stopButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [_automaticMenuView addSubview:stopButton];
//    }
//    [self.view addSubview:_automaticMenuView];
//}

//- (void)stopButtonClick {
//    _pageGenerationManager.currentPage--;
//    if (_pageGenerationManager.automaticReadingTypes == 2) {
//        _pageGenerationManager.currentPage--;
//    }
//    // 退出自动阅读
//    [_pageGenerationManager automaticReading:0 speed:0];
//    // 收起自动阅读菜单
//    [self PageGenerationManagerAutomaticReadingIsShowMenu:NO];
//}

//- (void)patternsButton:(UIButton *)button {
//    [_pageGenerationManager automaticReadingModel:button.tag];
//}

//- (void)speedButton:(UIButton *)button {
//    if (button.tag == 1) {
//        speed ++;
//    } else {
//        speed --;
//    }
//    if (speed <= 0) {
//        speed = 1;
//    }
//    if (speed >= 5) {
//        speed = 5;
//    }
//    [_pageGenerationManager automaticReadingSpeed:speed];
//}
//- (void)removeAutomaticMenuView {
//    [_automaticMenuView removeFromSuperview];
//}

#pragma mark - PageGenerationManager 数据源
#pragma mark 获取展示内容
- (NSString *)PageGenerationManagerDataSourceTagString:(DataSourceTag)dataSourceTag {
    _pageGenerationManager.chapterName = self.currBookChapter.name;
//    NSString * path                    = [[NSBundle mainBundle] pathForResource:@"411054" ofType:@""];
//    NSString *str                      = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[self.currBookChapter.url md5]];
    NSString * text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUnicodeStringEncoding error:nil];
    
    return text;
}

#pragma mark - PageGenerationManager 代理
#pragma mark 是否显示菜单
- (void)PageGenerationManagerIsShowMenu:(BOOL)isShowMenu {
//    if (isShowMenu) {
//        // 添加顶部和底部菜单
//      //  [self addMenuView];
//   //     self.menuView.view.hidden = NO;
//
//        [self.menuView showMenuView];
//    } else {
//       // [self removeMenuView];
//        self.menuView.view.hidden = YES;
//    }
    [self.menuView showMenuView];
}

#pragma mark 是否显示自动阅读菜单
- (void)PageGenerationManagerAutomaticReadingIsShowMenu:(BOOL)isShowMenu {
//    if (isShowMenu) {
//        [self addAutomaticMenuView];
//    } else {
//        [self removeAutomaticMenuView];
//    }
}
#pragma mark 获得页眉
- (UIView *)PageGenerationManagerHeader:(PageGenerationManager *)pageGenerationManager {
    PageGenerationHeader *pageGenerationHeader = [PageGenerationHeader sharePageGenerationHeader];
    pageGenerationHeader.bookName = @"橙红年代";
    pageGenerationHeader.textColor = [UIColor colorWithWhite:0.000 alpha:0.4f];
    return pageGenerationHeader;
}
#pragma mark 获得页脚
- (UIView *)PageGenerationManagerFooter:(PageGenerationManager *)pageGenerationManager {
    PageGenerationFooter *pageGenerationFooter = [PageGenerationFooter sharePageGenerationFooter];
    pageGenerationFooter.chapterName           = @"章节名称";
    CGFloat progress                           = (_pageGenerationManager.currentPage * 1.0 + 1) /_pageGenerationManager.pageCount;
    pageGenerationFooter.readerProgress        = progress;
    pageGenerationFooter.batteryImageName      = @"电池";
    pageGenerationFooter.textColor             = [UIColor colorWithWhite:0.000 alpha:0.4f];
    return pageGenerationFooter;
}
#pragma mark 添加笔记
- (void)PageGenerationManagerAddNotes:(NSMutableDictionary *)notesContentDic {
    // 笔记保存在 _notesModelArr 数组内
    NSLog(@"选中内容 ： %@",notesContentDic[@"selectedContentStr"]);
    NSLog(@"笔记内容 ： %@",notesContentDic[@"noteContentStr"]);
}

- (void)setupNav{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    self.navigationItem.title = self.book.novel.name;
    self.navigationController.navigationBarHidden = YES;
//    UIBarButtonItem * lbbi = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreViewController)];
//    self.navigationItem.leftBarButtonItem = lbbi;
}

- (void)backToPreViewController{
    
    if (!self.book.isCaseBook) {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"是否加入我的藏书阁？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的",@"不了", nil];
        
        [av show];
    }else{
    //    NSIndexPath * indexPath = [[self.mainView indexPathsForVisibleItems] firstObject];
        
     //   [BookDatabase saveBookToDataBaseWithIndexPath:indexPath andBook:self.book];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setupViews
{
    if (!self.readIndexPath) {
        
        Book * book = [[BookDatabase bookDataListFromDatabaseWithNovelId:self.book.novel.Id] firstObject];
        
        self.book.isCaseBook = book!=nil;
        
        self.readIndexPath = book.currIndexPath;
    }
    

    BookChapter * bookChapter = self.chapterArray[self.readIndexPath.section];
    
    if (bookChapter) {
        
        if ([self isExitNovelByNovelTextUrl:bookChapter.url]) {
            [self getDataByNovelTextUrl:bookChapter.url];
        }
    }
    self.currBookChapter = bookChapter;
    
    self.readIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.readIndexPath.section];
    
    [self setupMenuView];
  //  AKWeakSelf(self);
//    
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//        
//        [weakself.menuView showMenuView];
////        [weakself.readerManager updateReadingChapter:weakself.currBookChapter page:weakself.page];
//    }]];

    
}


//获取数据，有则加载，无则请求
- (void)getDataByNovelTextUrl:(NSString *)novelTextUrl{
    if([self isExitNovelByNovelTextUrl:novelTextUrl]){
        
        NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[novelTextUrl md5]];
        NSString * text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUnicodeStringEncoding error:nil];
        
        
    }else{
      
    }
}

//判断本地是否缓存
- (BOOL)isExitNovelByNovelTextUrl:(NSString *)novelTextUrl{
    NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",FILEPATH_BOOK_NOVEL_PATH,self.book.novel.Id,[novelTextUrl md5]];
    
    if ([NSFileManager isExistsFileWithFilePath:filePath]) {
        
        
        NSError * error = nil;
        
        NSString * text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUnicodeStringEncoding error:&error];
        
        if (![text isEqualToEmptyStr]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - 系统协议
- (BOOL)prefersStatusBarHidden{
    return self.navigationController.navigationBarHidden;
}

#pragma mark - menu view
- (void)setupMenuView {
    __weak typeof(self) wself = self;
    self.menuView = [[YMenuViewController alloc] init];
    self.menuView.view.frame = self.view.bounds;
    [self.view addSubview:self.menuView.view];
    self.menuView.view.backgroundColor = [UIColor clearColor];
    self.menuView.view.hidden = YES;
    self.menuView.menuTapAction = ^(NSInteger tag) {
        switch (tag) {
            case 100: {          //换源
                [wself presentViewController:wself.summaryVC animated:YES completion:nil];
            }
                break;
            case 101:           //播放
                
                break;
            case 102: {          //关闭
                [wself dismissViewControllerAnimated:YES completion:^{
               //     [wself.readerManager updateReadingChapter:wself.chapter page:wself.page];
                    [wself.readerManager closeReadingBook];
                }];
            }
                break;
            case 202: {          //目录
                [wself presentViewController:wself.directoryVC animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    };
}

#pragma mark - 选择章节页面
- (YDirectoryViewController *)directoryVC {
    if (!_directoryVC) {
        _directoryVC = [[YDirectoryViewController alloc] init];
       // __weak typeof(self) wself = self;
        //_directoryVC.selectChapter = ^(NSUInteger chapter) {
         //   wself.isPageBefore = NO;
         //   [wself updateReaderChapter:chapter page:0];
        //};
    }
    _directoryVC.chaptersArr = self.readerManager.chaptersArr;
   // _directoryVC.readingChapter = self.chapter;
    return _directoryVC;
}

#pragma mark - 更新来源
- (YSummaryViewController *)summaryVC {
    if (!_summaryVC) {
        _summaryVC = [[YSummaryViewController alloc] init];
        __weak typeof(self) wself = self;
        _summaryVC.updateSelectSummary = ^(YBookSummaryModel *summary){
          //  [wself updateReaderBookSummary:summary];
        };
    }
   // _summaryVC.bookM = self.readingBook;
    _summaryVC.summaryM = self.readerManager.selectSummary;
    return _summaryVC;
}


#pragma mark - getter
- (NSMutableArray<BookChapter *> *)chapterArray{
    if (!_chapterArray) {
        _chapterArray = [NSMutableArray new];
    }
    return _chapterArray;
}


@end
