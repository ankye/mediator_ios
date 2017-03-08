//
//  CustomNumbersView.m
//  myTest
//
//  Created by 陈行 on 16/6/20.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CustomNumbersView.h"
#import "CustomNumbersPlainFlowLayout.h"
#import "CustomNumbersLeftHeaderView.h"
#import "CustomNumbersRightHeaderView.h"
#import "CustomNumbersCell.h"


@interface CustomNumbersView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 *  左上角
 */
@property(nonatomic,weak) UIView * leftTopView;
/**
 *  左边
 */
@property(nonatomic,weak) UITableView * leftView;
/**
 *  上边
 */
@property(nonatomic,weak) UICollectionView * topView;
/**
 *  内容
 */
@property(nonatomic,weak) UICollectionView * conCollectionView;
/**
 *  包含右侧区域
 */
@property (strong, nonatomic) UIScrollView *slideScrollView;

@end

@implementation CustomNumbersView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.conItemWidth=self.leftItemWidth=100;
    self.conItemHeight=self.topItemHeight=44;
    self.defaultStr=@"未获取到数据，请检查";
    
    UIView * leftTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [self addBorderColor:leftTopView];
    self.leftTopView=leftTopView;
    [self addSubview:leftTopView];
    
    
    [self addSubview:self.slideScrollView];
    
    [self.slideScrollView addSubview:self.topView];
    [self.slideScrollView addSubview:self.conCollectionView];
    
    UITableView * leftView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    leftView.separatorStyle=UITableViewCellSeparatorStyleNone;
    leftView.showsVerticalScrollIndicator=NO;
    leftView.dataSource=self;
    leftView.delegate=self;
    leftView.bounces=YES;
    self.leftView=leftView;
    [self addSubview:leftView];
    
    [self refreshFrame];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView==self.topView) {
        return 1;
    }else{
        return [self numberOfSectionsInTableView:self.leftView];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==self.topView){
        return self.topDataArray.count;
    }else{
        return [self tableView:self.leftView numberOfRowsInSection:section]*self.topDataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==self.topView) {
        UICollectionViewCell * customCell = nil;
        if ([self.delegate respondsToSelector:@selector(numbersView:topCollectionView:cellForItemAtIndexPath:)]) {
            customCell = [self.delegate numbersView:self topCollectionView:collectionView cellForItemAtIndexPath:indexPath];
            if (customCell!=nil) {
                return customCell;
            }
        }
        
        static NSString * identifier = @"CustomNumbersCell";
        CustomNumbersCell * numbersCell = nil;// [collectionView collectionViewCellByNibWithIdentifier:identifier andIndexPath:indexPath];
        NSString * text = @"";
        if (self.topKey) {
            text=[self.topDataArray[indexPath.item] valueForKey:self.topKey];
        }else{
            text=self.topDataArray[indexPath.item];
        }
        numbersCell.conLabel.text=text;
        return numbersCell;
    }else{
        UICollectionViewCell * customCell = nil;
        if ([self.delegate respondsToSelector:@selector(numbersView:conCollectionView:cellForItemAtIndexPath:)]) {
            customCell = [self.delegate numbersView:self conCollectionView:collectionView cellForItemAtIndexPath:indexPath];
            if (customCell!=nil) {
                return customCell;
            }
        }
        
        static NSString * identifier = @"CustomNumbersCell";
        CustomNumbersCell * numbersCell = nil;// [collectionView collectionViewCellByNibWithIdentifier:identifier andIndexPath:indexPath];
        
        CustomNumbersModel * con = self.leftDataArray[indexPath.section];
        NSInteger row = indexPath.item/self.topDataArray.count;
        NSString * key = con.cellValueKeyDataArray[row];
        
        NSInteger section = indexPath.item%self.topDataArray.count;
        id obj = self.conDataArray[section];
        
        if (self.conDataArray.count>section) {
            id value = [obj valueForKey:key];
            if (value) {
                numbersCell.conLabel.text = [NSString stringWithFormat:@"%@",value];
            }else{
                numbersCell.conLabel.text = self.defaultStr;
            }
        }else{
            numbersCell.conLabel.text=@"未获取到数据，请检查";
        }
        return numbersCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==self.topView) {
        return CGSizeMake(self.conItemWidth,self.topItemHeight);
    }else{
        return CGSizeMake(self.conItemWidth,self.conItemHeight);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (collectionView==self.topView) {
        return CGSizeZero;
    }
    return CGSizeMake(self.width-self.leftItemWidth, 32);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView=nil;
    if (collectionView==self.conCollectionView && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        static NSString * identifier = @"CustomNumbersRightHeaderView";
        //1.要注册
        [collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
        //2.应用重用机制
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
        CustomNumbersRightHeaderView * headerView = (CustomNumbersRightHeaderView *)reusableView;
        headerView.titleLabelLeftCon.constant=self.slideScrollView.contentOffset.x;
    }
    return reusableView;
}
#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.leftDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftDataArray[section].cellNameDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * customCell = nil;
    if ([self.delegate respondsToSelector:@selector(numbersView:leftTableView:cellForRowAtIndexPath:)]) {
        customCell = [self.delegate numbersView:self leftTableView:self.leftView cellForRowAtIndexPath:indexPath];
        if (customCell) {
            return customCell;
        }
    }
    
    static NSString * identifier=@"UITableViewCell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }

    cell.textLabel.text = self.leftDataArray[indexPath.section].cellNameDataArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines=0;
    [self addBorderColor:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.conItemHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString * identifier=@"CustomNumbersLeftHeaderView";
     CustomNumbersLeftHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if(headerView==nil){
        UINib * nib = [UINib nibWithNibName:identifier bundle:nil];
        [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:identifier];
        headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    }
    headerView.headerTitleLabel.text = self.leftDataArray[section].titleName;
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != self.slideScrollView) {
        self.leftView.contentOffset=scrollView.contentOffset;
        self.conCollectionView.contentOffset=scrollView.contentOffset;
    }else{
        for (int i=0; i<self.conDataArray.count; i++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            CustomNumbersRightHeaderView * headerView = (CustomNumbersRightHeaderView *) [self.conCollectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            headerView.titleLabelLeftCon.constant=scrollView.contentOffset.x;
        }
    }
}

#pragma mark - refresh
- (void)refreshFrame{
    
    for (UIView * view in self.leftTopView.subviews) {
        [view removeFromSuperview];
    }
    
    self.leftTopView.frame=CGRectMake(0, 0, self.leftItemWidth, self.topItemHeight);
    
    if ([self.delegate respondsToSelector:@selector(leftTopViewNumbersView:)]) {
        UIView * leftTopView = [self.delegate leftTopViewNumbersView:self];
        if (leftTopView) {
            leftTopView.frame=self.leftTopView.bounds;
            [self.leftTopView addSubview:leftTopView];
        }
    }
    
    
    CGFloat width = self.width-self.leftItemWidth;

    if (self.conItemWidth*self.topDataArray.count>width) {
        width = self.conItemWidth*self.topDataArray.count;
    }else if(self.topDataArray.count>0){
        self.conItemWidth=width/self.topDataArray.count;
    }
    
    self.leftView.frame=CGRectMake(0, self.topItemHeight, self.leftItemWidth, self.height-self.topItemHeight);
    
    self.slideScrollView.frame=CGRectMake(self.leftItemWidth, 0, self.width-self.leftItemWidth, self.height);
    
    self.topView.frame=CGRectMake(0, 0, width, self.topItemHeight);
    
    self.conCollectionView.frame=CGRectMake(0, self.topItemHeight, width, self.height-self.topItemHeight);
    
    self.slideScrollView.contentSize=CGSizeMake(self.topView.width, self.height);
}

#pragma mark - getter
- (UIScrollView *)slideScrollView {//右侧滑动区域
    if (_slideScrollView==nil) {
        UIScrollView * slideScrollView = [UIScrollView new];
//        slideScrollView.backgroundColor=[UIColor orangeColor];
        slideScrollView.bounces = NO;
        slideScrollView.showsHorizontalScrollIndicator = NO;
        slideScrollView.delegate = self;
        
        _slideScrollView=slideScrollView;
    }
    return _slideScrollView;
}

- (UICollectionView *)topView{
    if (_topView==nil) {
        _topView=[self loadCollectionView];
    }
    return _topView;
}

- (UICollectionView *)conCollectionView{
    if (_conCollectionView==nil) {
        _conCollectionView=[self loadCollectionView];
    }
    return _conCollectionView;
}

- (NSArray *)diffItemIndexPathDataArray{
    if (_diffItemIndexPathDataArray==nil) {
        if (self.conDataArray==nil || self.topDataArray==nil || self.isShowDiffItem==false) {
            return nil;
        }
        
        NSMutableArray * tmpArray = [NSMutableArray new];

        for (int section=0; section<self.leftDataArray.count; section++) {
            CustomNumbersModel * numberModel=self.leftDataArray[section];
            
            for (int row=0;row<numberModel.cellValueKeyDataArray.count;row++) {
                NSString * key = numberModel.cellValueKeyDataArray[row];
                
                NSString * value = [NSString stringWithFormat:@"%@",[self.conDataArray[0] valueForKey:key]];
                for (NSObject * obj in self.conDataArray) {
                    NSString * tmpValue= [NSString stringWithFormat:@"%@",[obj valueForKey:key]];
                    if (![tmpValue isEqualToString:value]) {
                        NSLog(@"不同项-------->%d---%d",section,row);
                        [tmpArray addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                        break;
                    }
                }
            }
        }
        _diffItemIndexPathDataArray=tmpArray;
    }
    return _diffItemIndexPathDataArray;
}

#pragma mark - setter
- (void)setTopDataArray:(NSMutableArray *)topDataArray{
    _topDataArray=[NSMutableArray arrayWithArray:topDataArray];
}

- (void)setLeftDataArray:(NSMutableArray<CustomNumbersModel *> *)leftDataArray{
    _leftDataArray=[NSMutableArray arrayWithArray:leftDataArray];
}

- (void)setConDataArray:(NSMutableArray *)conDataArray{
    _conDataArray=[NSMutableArray arrayWithArray:conDataArray];
}

#pragma mark - 私有方法
- (UICollectionView *)loadCollectionView {
    CustomNumbersPlainFlowLayout *flowLayout = [CustomNumbersPlainFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1);
    
    UICollectionView *c = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    c.dataSource = self;
    c.delegate = self;
    c.backgroundColor = [UIColor clearColor];
    c.showsVerticalScrollIndicator = NO;
    c.bounces = YES;
    c.translatesAutoresizingMaskIntoConstraints = NO;
    return c;
}


#pragma mark - 公开方法
- (void)reloadData{
    [self.leftView reloadData];
    [self.topView reloadData];
    [self.conCollectionView reloadData];
    [self refreshFrame];
}

- (void)addBorderColor:(UIView *)view{
    view.layer.borderColor=[UIColor colorWithWhite:0.847 alpha:1.000].CGColor;
    view.layer.borderWidth=AK1PXLine;
}

- (NSIndexPath *)indexPathWithTopCell:(UICollectionViewCell *)collViewCell{
    if ([collViewCell isKindOfClass:[UICollectionViewCell class]]) {
        return [self.topView indexPathForCell:collViewCell];
    }
    return nil;
}


@end
