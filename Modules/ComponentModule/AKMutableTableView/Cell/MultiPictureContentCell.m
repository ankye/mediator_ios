//
//  MultiPictureContentCell.m
//  pro
//
//  Created by TuTu on 16/8/17.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "MultiPictureContentCell.h"
#import "SinglePicCollectCell.h"
#import "Content.h"


@interface MultiPictureContentCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;

@property (weak, nonatomic) IBOutlet UIView *topline;
@property (weak, nonatomic) IBOutlet UIView *leftline;
@property (weak, nonatomic) IBOutlet UIView *rightline;
@property (weak, nonatomic) IBOutlet UIImageView *OnTopImage;

@end

@implementation MultiPictureContentCell

- (void)setAContent:(Content *)aContent
{
    _aContent = aContent ;
    
    _titleLabel.text = aContent.title ;
    _kindLabel.text = aContent.kindName ;
    _readLabel.text = [NSString stringWithFormat:@"阅 %d",aContent.readNum] ;
    _OnTopImage.hidden = !aContent.isTop ;

    [_collectionView reloadData] ;
}

+ (float)getHeightWithTitle:(NSString *)strTitle
{
    UIFont *font = [UIFont systemFontOfSize:17.] ;
    CGSize size = CGSizeMake(SCREEN_WIDTH - 18. * 2, 100) ;
    CGSize labelsize = [strTitle boundingRectWithSize:size
                                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil].size ;
    CGFloat h_title = labelsize.height ;
    return 20. + h_title + 10  + 7.* (SCREEN_WIDTH - 20.) / 30. + 39. ;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    _titleLabel.backgroundColor = [UIColor whiteColor] ;
    _titleLabel.textColor = [UIColor theme_news_table_cellTitleFontColor] ;
    _kindLabel.backgroundColor = [UIColor clearColor] ;
    _kindLabel.textColor = [UIColor theme_news_table_cellDescFontColor] ;
    _readLabel.textColor = [UIColor theme_news_table_cellDescFontColor] ;
    
    _topline.backgroundColor = [UIColor theme_table_cellSeparatorColor] ;
    _leftline.backgroundColor = [UIColor theme_table_cellSeparatorColor] ;
    _rightline.backgroundColor = [UIColor theme_table_cellSeparatorColor] ;
    
    self.collectionView.dataSource = self ;
    self.collectionView.delegate = self ;
    self.collectionView.backgroundColor = [UIColor whiteColor] ;
    self.collectionView.userInteractionEnabled = false ;
    
    UINib *nib = [UINib nibWithNibName:identifier_SinglePicCollectionCell bundle: [NSBundle mainBundle]] ;
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier_SinglePicCollectionCell] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark --
#pragma mark - collection dataSourse
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.aContent.imgs.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SinglePicCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier_SinglePicCollectionCell forIndexPath:indexPath] ;
    cell.images = self.aContent.imgs.count > 0 ? self.aContent.imgs[indexPath.row] : nil ;
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float height    = ( SCREEN_WIDTH - 20. ) * 7 / 30 ;
    float wid       = height * 94. / 70. ;
    return CGSizeMake(wid , height) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
