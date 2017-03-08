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
#import "ReaderEngineManager.h"

#import "YDirectoryViewController.h"
#import "AKReaderMenuView.h"

//#import "YMenuViewController.h"

#import "AKReaderSetting.h"

#import "YSummaryViewController.h"
#import "AKAutoReadSettingView.h"
#import "AKReaderSetting.h"
#import "AKLanguageHelper.h"

#define EquipmentWidth     [[UIScreen mainScreen] bounds].size.width
#define EquipmentHeight    [[UIScreen mainScreen] bounds].size.height


@interface AKReaderViewController ()<ReaderEngineManagerDataSource,ReaderEngineManagerDelegate>

//现在需要获取小说数据下标
@property (nonatomic, assign) NSInteger currDataIndex;
//现在需要获取小说数据对象
@property(nonatomic,strong)BookChapter * currBookChapter;





@property (strong, nonatomic) YDirectoryViewController *directoryVC;
@property (strong, nonatomic) YSummaryViewController *summaryVC;


@property (strong, nonatomic) ReaderEngineManager   *pageGenerationManager;
@property (strong ,nonatomic) AKAutoReadSettingView                  *automaticMenuView;

@property (nonatomic, assign) NSInteger               automaticReadingSpeed;
@property (nonatomic, assign) AutomaticReadingTypes automaticReadingTypes;

@end

@implementation AKReaderViewController {
    
    
    NSMutableArray          *_notesModelArr;
    NSMutableArray          *_bookmarksModelArr;

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    _notesModelArr                            = [NSMutableArray array];
    self.automaticReadingSpeed                                     = 1;
    self.automaticReadingTypes                                      = CoverPatterns;
    
    // 创建阅读引擎
    _pageGenerationManager                    = [ReaderEngineManager shareReaderEngineManager];
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
    [_pageGenerationManager.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self setupViews];

}


- (void)buttonClick:(UIButton *)button {
    _pageGenerationManager.animationTypes = button.tag - 1;
}
- (void)goBackClick {

    if (!self.book.isBookmark) {
       
        NSMutableDictionary* attributes = [AKPopupManager buildPopupAttributes:NO showNav:NO style:STPopupStyleFormSheet actionType:AKPopupActionTypeTop onClick:^(NSInteger channel, NSDictionary *attributes) {
            switch (channel) {
                case 1:{
                    //do clean book
                }
                    break;
                case 2:
                {
                    [[AKReaderManager sharedInstance] bookmark:self.book];
                   
                }
                    break;
                default:
                    break;
            }
        } onClose:^(NSDictionary *attributes) {
            
        } onCompleted:^(NSDictionary *attributes) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
                [self.navigationController popViewControllerAnimated:YES];
            });

        }];
        NSArray* items =
        @[MMItemMake(@"不了", MMItemTypeNormal, 1),
          MMItemMake(@"加入", MMItemTypeHighlight, 2)
          ];
        [[AKPopupManager sharedInstance] showChooseAlert:@"提示信息" withDetail:@"是否加入我的追书架？" withItems:items withAttributes:attributes];
        
    }else{

        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)addAutomaticMenuView {
    if (!_automaticMenuView) {
        _automaticMenuView                     = [[AKAutoReadSettingView alloc] initWithFrame:CGRectMake(0, EquipmentHeight - 180, EquipmentWidth, 180)];
        _automaticMenuView.backgroundColor     = [UIColor grayColor];
        [_automaticMenuView selectedButton:self.automaticReadingTypes];
        __weak typeof(self) wself = self;
        
        _automaticMenuView.settingTapAction = ^(NSInteger tag) {
            switch (tag) {
                case 800: //减速
                {
                    [wself speedButton:tag];
                }
                    break;
                case 801: //加速
                {
                    [wself speedButton:tag];
                }
                    break;
                case 802: //覆盖模式
                {
                    [wself.pageGenerationManager automaticReadingModel:CoverPatterns];
                    [wself.automaticMenuView selectedButton:CoverPatterns];
                    wself.automaticReadingTypes = CoverPatterns;
                }
                    break;
                case 803://滚动模式
                {
                    [wself.pageGenerationManager automaticReadingModel:ScrollMode];
                    [wself.automaticMenuView selectedButton:ScrollMode];
                    wself.automaticReadingTypes = ScrollMode;
                }
                    break;
                case 804: //退出自动阅读
                {
                    wself.pageGenerationManager.currentPage--;
                    if (wself.pageGenerationManager.automaticReadingTypes == ScrollMode) {
                        wself.pageGenerationManager.currentPage--;
                    }
                    // 退出自动阅读
                    [wself.pageGenerationManager automaticReading:0 speed:0];
                    // 收起自动阅读菜单
                    [wself ReaderEngineManagerAutomaticReadingIsShowMenu:NO];
                }
                    break;
                default:
                    break;
            }
        };
        

    }
    [self.view addSubview:_automaticMenuView];
}




- (void)speedButton:(NSInteger)tag {
    if (tag == 801) {
        self.automaticReadingSpeed ++;
    } else {
        self.automaticReadingSpeed --;
    }
    if (self.automaticReadingSpeed <= 0) {
        self.automaticReadingSpeed = 1;
    }
    if (self.automaticReadingSpeed >= 5) {
        self.automaticReadingSpeed = 5;
    }
    [_pageGenerationManager automaticReadingSpeed:self.automaticReadingSpeed];
}
- (void)removeAutomaticMenuView {
    [_automaticMenuView removeFromSuperview];
}

#pragma mark - ReaderEngineManager 数据源
#pragma mark 获取展示内容
- (NSString *)ReaderEngineManagerDataSourceTagString:(DataSourceTag)dataSourceTag {
    
    if(self.book == nil ) return nil;
    
    if(dataSourceTag == PreviousContent){
        self.book.read_chapter_section = self.book.read_chapter_section -1 ;
    }else if(dataSourceTag == NextContent){
        self.book.read_chapter_section = self.book.read_chapter_section +1;
    }
    if(self.book.read_chapter_section < 0 ){
        self.book.read_chapter_section = 0;
    }
    
    if( self.book.read_chapter_section >= [self.book.bookChapters count]){
        return nil;
    }
    
    BookChapter * bookChapter = self.book.bookChapters[self.book.read_chapter_section];
    self.currBookChapter = bookChapter;
    _pageGenerationManager.chapterName = self.currBookChapter.name;
    
    NSString* filePath = [[AKDownloadManager sharedInstance] getDownloadFilePath:_downloadGroup.groupName withUrl:bookChapter.url];
  
    if(! [[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [self setupDownloadEvent];
        return nil;
    }
    
    NSString * text =[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUnicodeStringEncoding error:nil];
    return text;
       
}

#pragma mark - ReaderEngineManager 代理
#pragma mark 是否显示菜单
- (void)ReaderEngineManagerIsShowMenu:(BOOL)isShowMenu {
    if (isShowMenu) {
        // 添加顶部和底部菜单
        [self.menuVC showMenuView];
    } else {

        [self.menuVC hideMenuView];
    }

}

#pragma mark 是否显示自动阅读菜单
- (void)ReaderEngineManagerAutomaticReadingIsShowMenu:(BOOL)isShowMenu {
    if (isShowMenu) {
        [self addAutomaticMenuView];
    } else {
        [self removeAutomaticMenuView];
    }
}
#pragma mark 获得页眉
- (UIView *)ReaderEngineManagerHeader:(ReaderEngineManager *)pageGenerationManager {
    PageGenerationHeader *pageGenerationHeader = [PageGenerationHeader sharePageGenerationHeader];

    pageGenerationHeader.bookName = _book.novel.name;
    pageGenerationHeader.textColor = [AKReaderSetting sharedInstance].otherTextColor;
    return pageGenerationHeader;
}
#pragma mark 获得页脚
- (UIView *)ReaderEngineManagerFooter:(ReaderEngineManager *)pageGenerationManager {
    PageGenerationFooter *pageGenerationFooter = [PageGenerationFooter sharePageGenerationFooter];
    pageGenerationFooter.chapterName           = self.currBookChapter.name; // @"章节名称";
    CGFloat progress                           = (_pageGenerationManager.currentPage * 1.0 + 1) /_pageGenerationManager.pageCount;
    pageGenerationFooter.readerProgress        = progress;
    pageGenerationFooter.batteryImageName      = @"电池";
    pageGenerationFooter.textColor             = [AKReaderSetting sharedInstance].otherTextColor;
    return pageGenerationFooter;
}
#pragma mark 添加笔记
- (void)ReaderEngineManagerAddNotes:(NSMutableDictionary *)notesContentDic {
    // 笔记保存在 _notesModelArr 数组内
    NSLog(@"选中内容 ： %@",notesContentDic[@"selectedContentStr"]);
    NSLog(@"笔记内容 ： %@",notesContentDic[@"noteContentStr"]);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}

////Interface的方向是否会跟随设备方向自动旋转，如果返回NO,后两个方法不会再调用
//- (BOOL)shouldAutorotate {
//    return YES;
//}
////返回直接支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape ;
//}
////返回最优先显示的屏幕方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait |UIInterfaceOrientationLandscapeLeft;
//}


- (void)setupNav{
    

    self.navigationItem.title = self.book.novel.name;
    self.navigationController.navigationBarHidden = YES;
   [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}



-(void)setupViews
{
 
    [self setupMenuView];

    if(_book && _book.bookChapters.count == 0){
        [AKPopupManager showProgressHUDAtView:self.view];
        
        [_book.onChaptersChange addObserver:self callback:^(typeof(self) self, NSMutableArray * _Nonnull mutableArray) {
            [AKPopupManager hideProgressHUDAtView:self.view];
            [self setupDownloadEvent];
        }];
        [[AKReaderManager sharedInstance] requestBookChapters:_book];

    }else{
        
        [self setupDownloadEvent];
    }

}

-(void)setupDownloadEvent
{
    if( self.downloadGroup == nil )
    {
        self.downloadGroup =  [[AKReaderManager sharedInstance] startDownloadBook:self.book atIndex:self.book.read_chapter_section];
        [self.downloadGroup.onDownloadItemCompleted addObserver:self callback:^(typeof(self) self, NSDictionary * _Nonnull dictionary) {
            NSString* url = dictionary[@"url"];
            if([self.currBookChapter.url isEqualToString:url]){
                [self.pageGenerationManager refreshViewController];
            }
        }];
        
        [self.pageGenerationManager refreshViewController];

    }
}


#pragma mark - 系统协议
- (BOOL)prefersStatusBarHidden{
    return self.navigationController.navigationBarHidden;
}

#pragma mark - menu view
- (void)setupMenuView {
    __weak typeof(self) wself = self;
    self.menuVC = [[YMenuViewController alloc] init];
    self.menuVC.view.frame = self.view.bounds;
    [self.view addSubview:self.menuVC.view];
    self.menuVC.view.backgroundColor = [UIColor clearColor];
    self.menuVC.view.hidden = YES;


    
    self.menuVC.menuTapAction = ^(NSInteger tag) {
        switch (tag) {
            case 100: {          //换源
                [wself presentViewController:wself.summaryVC animated:YES completion:nil];
            }
                break;
            case 101:           //播放
                
                break;
            case 102: {          //关闭
                [wself goBackClick];
               
            }
                break;
            case 200:           //日/夜间模式切换
            {
                [wself.pageGenerationManager nightModel:NO];
                [wself.pageGenerationManager refreshViewController];
            }
                break;
            case 201:{      //翻页方式
                [wself choosePageEffect];
            }
                break;
            case 202: {          //目录
                [wself.pageGenerationManager showOrHideMenu];
                
                [wself presentViewController:wself.directoryVC animated:YES completion:nil];
            }
                break;
            case 203: {          //下载
                [wself chooseDownloadChapter];
                
            }
                break;
            case 400:{ //隐藏menuview
                [wself.pageGenerationManager showOrHideMenu];
                
            }
                break;
            case 300:{ //字体缩小
                [AKReaderSetting sharedInstance].fontSize = [AKReaderSetting sharedInstance].fontSize -1;
                [wself.pageGenerationManager refreshViewController];
            }
                break;
            case 301:{ //字体放大
                [AKReaderSetting sharedInstance].fontSize = [AKReaderSetting sharedInstance].fontSize + 1;
                [wself.pageGenerationManager refreshViewController];
            }
                break;
            case 302: {             //繁简体
                [wself.pageGenerationManager refreshViewController];
            }
                break;
            case 303:{              //字体设置
                [wself chooseFont];
            }
                break;
            case 304:{ //行距紧密
                [AKReaderSetting sharedInstance].lineSpaceType = AKPagingLineSpaceTypeSmall;
                [wself.pageGenerationManager refreshViewController];
            }
                break;
            case 305:{ //行距正常
                [AKReaderSetting sharedInstance].lineSpaceType = AKPagingLineSpaceTypeNormal;
                [wself.pageGenerationManager refreshViewController];
            }
                break;
            case 306:{ //行距稀疏
                
                [AKReaderSetting sharedInstance].lineSpaceType = AKPagingLineSpaceTypeLarge;
                [wself.pageGenerationManager refreshViewController];
            }
                break;
             case 307: {             //自动翻页
                 [wself.pageGenerationManager showOrHideMenu];
                  [wself.pageGenerationManager automaticReading:wself.automaticReadingTypes speed:wself.automaticReadingSpeed];
                 
             }
                break;
            case 308: {             //横竖屏
                
//                UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//                if (orientation == UIDeviceOrientationLandscapeLeft) // home键靠右
//                {
//                    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
//                }else{
//                    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
//                }
               
                
            }
                break;
            case 700:{  //刷新主题
                wself.pageGenerationManager.backgroundImage = [AKReaderSetting sharedInstance].themeImage;
                [wself.pageGenerationManager refreshViewController];
            }
            default:
                break;
        }
    };
}

-(void)chooseDownloadChapter
{
    NSMutableDictionary* attributes = [AKPopupManager buildPopupAttributes:NO showNav:NO style:STPopupStyleBottomSheet actionType:AKPopupActionTypeBottom onClick:^(NSInteger channel, NSDictionary *attributes) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.pageGenerationManager refreshViewController];
        });
        
        
    } onClose:^(NSDictionary *attributes) {
        
    } onCompleted:^(NSDictionary *attributes) {
        
    }];
    
    NSArray* items = @[MMItemMake(@"后面50章", MMItemTypeNormal, 1),
                       MMItemMake(@"后面全部", MMItemTypeNormal, 2),
                       MMItemMake(@"全部章节", MMItemTypeNormal, 3)
                       ];
    
    [[AKPopupManager sharedInstance] showSheetAlert:@"选择缓存章节方式" withItems:items withAttributes:attributes];
}


-(void)choosePageEffect
{
    NSMutableDictionary* attributes = [AKPopupManager buildPopupAttributes:NO showNav:NO style:STPopupStyleBottomSheet actionType:AKPopupActionTypeBottom onClick:^(NSInteger channel, NSDictionary *attributes) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pageGenerationManager setAnimationTypes: channel];
            [self.pageGenerationManager refreshViewController];
        });
        
        
    } onClose:^(NSDictionary *attributes) {
        
    } onCompleted:^(NSDictionary *attributes) {
        
    }];
    
    AKTurnPageAnimationStyle type = self.pageGenerationManager.animationTypes;
    
    NSArray* items = @[MMItemMake(@"仿真", type == TheSimulationEffectOfPage ? MMItemTypeHighlight :MMItemTypeNormal, TheSimulationEffectOfPage),
                       MMItemMake(@"覆盖", type == TheKeepOutEffectOfPage ? MMItemTypeHighlight :MMItemTypeNormal, TheKeepOutEffectOfPage),
                       MMItemMake(@"左右滑动", type == TheSlidingEffectOfPage ? MMItemTypeHighlight :MMItemTypeNormal, TheSlidingEffectOfPage)
                              ];
    
    [[AKPopupManager sharedInstance] showSheetAlert:@"翻页方式选择" withItems:items withAttributes:attributes];
}

-(void)chooseFont
{
    NSMutableDictionary* attributes = [AKPopupManager buildPopupAttributes:NO showNav:NO style:STPopupStyleBottomSheet actionType:AKPopupActionTypeBottom onClick:^(NSInteger channel, NSDictionary *attributes) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* fontName = [UIFont systemFontOfSize:12].fontName;
            if(channel == 2){
                fontName = @"Yuppy SC";
            }else if(channel == 3){
                fontName = @"STXINWEI";
            }
            [AKReaderSetting sharedInstance].fontName = fontName;
            [self.pageGenerationManager refreshViewController];
        });
        
        
    } onClose:^(NSDictionary *attributes) {
        
    } onCompleted:^(NSDictionary *attributes) {
        
    }];
    
    NSString* font = [AKReaderSetting sharedInstance].fontName;
    NSString* systemFont = [UIFont systemFontOfSize:12].fontName;
    
    NSArray* items = @[MMItemMake(@"默认", [font isEqualToString:systemFont]  ? MMItemTypeHighlight :MMItemTypeNormal, 1),
                       MMItemMake(@"雅痞", [font isEqualToString:@"Yuppy SC"] ? MMItemTypeHighlight :MMItemTypeNormal, 2),
                       MMItemMake(@"新魏", [font isEqualToString:@"STXINWEI"] ? MMItemTypeHighlight :MMItemTypeNormal, 3)
                       ];
    
    [[AKPopupManager sharedInstance] showSheetAlert:@"字体选择" withItems:items withAttributes:attributes];
}

#pragma mark - 选择章节页面
- (YDirectoryViewController *)directoryVC {
    if (!_directoryVC) {
        _directoryVC = [[YDirectoryViewController alloc] init];
        __weak typeof(self) wself = self;
        _directoryVC.selectChapter = ^(NSUInteger chapter) {
            wself.book.read_chapter_section = chapter;
            [wself.pageGenerationManager refreshViewController];
        };
    }
    _directoryVC.chaptersArr = self.book.bookChapters;
    _directoryVC.readingChapter = self.book.read_chapter_section;
    return _directoryVC;
}

#pragma mark - 更新来源
- (YSummaryViewController *)summaryVC {
    if (!_summaryVC) {
        _summaryVC = [[YSummaryViewController alloc] init];
       // __weak typeof(self) wself = self;
        _summaryVC.updateSelectSummary = ^(YBookSummaryModel *summary){
          //  [wself updateReaderBookSummary:summary];
        };
    }
   // _summaryVC.bookM = self.readingBook;
   
    return _summaryVC;
}




@end
