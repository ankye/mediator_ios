//
//  YMenuViewController.m
//  YReaderDemo
//
//  Created by yanxuewen on 2016/12/13.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "YMenuViewController.h"

#import "YBottomButton.h"
#import "ReaderEngineThemeFactory.h"
#import "AKReaderSetting.h"
#import "YThemeViewCell.h"

@interface YMenuViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *downloadView;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downloadViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTop;
@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIButton *fontSizeReduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *fontSizeAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *fontFanBtn;
@property (weak, nonatomic) IBOutlet UIButton *spaceSmallBtn;
@property (weak, nonatomic) IBOutlet UIButton *spaceNormalBtn;
@property (weak, nonatomic) IBOutlet UIButton *spaceBigBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *themeCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceBtnInterval;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fontSizeBtnInterval;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fontFanBtnInterval;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingViewBottom;

@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;


@property (strong, nonatomic) NSArray *themeArr;
@property (strong, nonatomic) AKReaderSetting * settings;

@end

@implementation YMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBottomViewUI];
    [self setupSettingViewUI];
    [self setupSettingButtonStatus];
    self.settingView.backgroundColor =AKColor(128,128, 128, 1.0);
    self.themeArr = [[ReaderEngineThemeFactory sharedInstance] getThemes];

    
    _brightnessSlider.value = [[UIScreen mainScreen] brightness];
    self.topView.backgroundColor =  [UIColor colorWithHexString:@"#3c93d6"];
    [self.themeCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YThemeViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([YThemeViewCell class])];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.themeCollectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(50, 90);
    layout.minimumLineSpacing = (kScreenWidth - 50 - 200) / 4;
    layout.minimumInteritemSpacing = 10;
    [self.themeCollectionView setCollectionViewLayout:layout];
    
    __weak typeof(self) wself = self;
    [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if( wself.menuTapAction){
            wself.menuTapAction(400);
        }
    }]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.themeArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YThemeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YThemeViewCell class]) forIndexPath:indexPath];
    cell.themeImage.layer.cornerRadius = 5;
    NSDictionary* themeDic = [self.themeArr objectAtIndex:indexPath.row];
    cell.themeImage.image = [UIImage imageNamed:themeDic[@"bg"]];
    cell.themeName.text = themeDic[@"name"];
    AKReaderTheme theme = [AKReaderSetting sharedInstance].theme;
    if (indexPath.row == theme) {
        cell.selectImage.hidden = NO;
    } else {
        cell.selectImage.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s %@",__func__,indexPath);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [[AKReaderSetting sharedInstance] selectdTheme:indexPath.row];
    self.menuTapAction(700); //刷新主题
    [collectionView reloadData];
}


#pragma mark - 点击上/下部按钮
- (IBAction)handleButton:(UIButton *)btn {
    if (self.menuTapAction) {
        self.menuTapAction(btn.tag);
    }
//    if (btn.tag != 102) { //102:close
//        [self hideMenuView];
//    }
}



#pragma mark - 点击设置里面按钮
- (IBAction)settingButtonAction:(UIButton *)btn {
    NSLog(@"%s %zi",__func__,btn.tag);
    switch (btn.tag) {
        case 300: {             //字体-
            [self handleButton:btn];
        }
            break;
        case 301: {             //字体+

            [self handleButton:btn];
        }
            break;
        case 302: {             //繁简体
            BOOL isTraditional = [AKReaderSetting sharedInstance].isTraditional;
            
            isTraditional = ! isTraditional;
            if (isTraditional) {
                [self.fontFanBtn setImage:[UIImage imageNamed:@"setting_font_jian"] forState:UIControlStateNormal];
            } else {
                [self.fontFanBtn setImage:[UIImage imageNamed:@"setting_font_fan"] forState:UIControlStateNormal];
            }
            [AKReaderSetting sharedInstance].isTraditional = isTraditional;
             [self handleButton:btn];
        }
            break;
        case 303: {             //字体
            [self handleButton:btn];
        }
            break;
        case 304: {             //行间距:密集
            [self handleButton:btn];
        }
            break;
        case 305: {             //行间距:正常

            [self handleButton:btn];
        }
            break;
        case 306: {             //行间距:稀疏

            [self handleButton:btn];
        }
            break;
        case 307: {             //自动翻页
            [self handleButton:btn];
        }
            break;
        case 308: {             //横竖屏
           [self handleButton:btn];
            // [AKPopupManager showTips:@"横竖屏设置暂未开放"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - show views
- (void)showSettingView {
    if (self.settingViewBottom.constant == self.bottomView.height) {
        return;
    }

    [UIView animateWithDuration:0.25 animations:^{
        self.settingViewBottom.constant = self.bottomView.height;
        self.bgViewBottom.constant = self.settingView.height + self.bottomView.height;
        [self.view layoutIfNeeded];
    }];
}

- (void)hideSettingView {
    if (self.settingViewBottom.constant == -self.settingView.height) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.settingViewBottom.constant = -self.settingView.height;
        self.bgViewBottom.constant = self.bottomView.height;
        [self.view layoutIfNeeded];
    }];
}


- (void)showMenuView {
    self.view.hidden = NO;

    [UIView animateWithDuration:0.25 animations:^{
        self.topViewTop.constant = 0;
        self.bottomViewBottom.constant = 0;
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }];
    
}

- (void)hideMenuView {
    [UIView animateWithDuration:0.25 animations:^{
        self.topViewTop.constant = -self.topView.height;
        self.bottomViewBottom.constant = -self.bottomView.height - self.downloadView.height;
        self.downloadViewBottom.constant = -self.downloadView.height;
        self.settingViewBottom.constant = -self.settingView.height;
        self.bgViewBottom.constant = self.bottomView.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.view.hidden = YES;
            
        }
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}



- (AKReaderSetting *)settings {
    if (!_settings) {
        _settings = [AKReaderSetting sharedInstance];
    }
    return _settings;
}

#pragma mark - setup UI
- (void)setupSettingButtonStatus {
   
    if (self.settings.isTraditional) {
        [self.fontFanBtn setImage:[UIImage imageNamed:@"setting_font_jian"] forState:UIControlStateNormal];
    } else {
        [self.fontFanBtn setImage:[UIImage imageNamed:@"setting_font_fan"] forState:UIControlStateNormal];
    }
}

- (void)setupSettingViewUI {
    CGFloat space = kScreenWidth - 15 * 2 - self.fontSizeAddBtn.width * 2 - self.fontFanBtn.width * 2;
    self.fontSizeBtnInterval.constant = space / 80 * 30.0;
    self.fontFanBtnInterval.constant = space / 80 * 25.0;
    self.spaceBtnInterval.constant = (self.fontSizeAddBtn.width * 2 + self.fontSizeBtnInterval.constant - self.spaceBigBtn.width * 3)/2.0;
    
}
- (IBAction)brightnessChanged:(id)sender {
    UISlider* slider = (UISlider*)sender;
    
    [[UIScreen mainScreen] setBrightness: slider.value];
}

- (void)setupBottomViewUI {
    NSArray *imgArr = @[@"night_mode",@"feedback",@"directory",@"preview_btn",@"reading_setting"];
    NSArray *titleArr = @[@"夜间",@"翻页",@"目录",@"缓存",@"设置"];
    __weak typeof(self) wself = self;
    void (^tapAction)(NSInteger) = ^(NSInteger tag){
        NSLog(@"tapAction %zi",tag);
        switch (tag) {
            case 200:           //日/夜间模式切换
            case 201:           //翻页
            case 202:           //目录
            case 203: {         //下载
                if (wself.menuTapAction) {
                    wself.menuTapAction(tag);
                }
                
            }
                break;
            case 204:           //设置
                [wself showSettingView];
                break;
            default:
                break;
        }
    };
    
    
    for (NSInteger i = 0; i < imgArr.count; i++) {
        YBottomButton *btn = [YBottomButton bottonWith:titleArr[i] imageName:imgArr[i] tag:i];
        btn.tapAction = tapAction;
        [self.bottomView addSubview:btn];
    }
    
    float spacing = 0.0;
    
    [self.bottomView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:kScreenWidth/5.0 leadSpacing:spacing tailSpacing:spacing];
    [self.bottomView.subviews mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        make.top.mas_equalTo(2);
        make.height.mas_equalTo(self.bottomView.mas_height);
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
