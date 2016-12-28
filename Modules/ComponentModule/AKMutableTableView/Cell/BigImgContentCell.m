//
//  BigImgContentCell.m
//  pro
//
//  Created by TuTu on 16/8/17.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "BigImgContentCell.h"
#import "Content.h"
//#import "UIImageView+WebCache.h"

//#import "UIImageView+QNExtention.h"
#import <YYKit/UIImageView+YYWebImage.h>

@interface BigImgContentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelKind;
@property (weak, nonatomic) IBOutlet UILabel *labelRead;

@property (weak, nonatomic) IBOutlet UIView *topline;
@property (weak, nonatomic) IBOutlet UIView *leftline;
@property (weak, nonatomic) IBOutlet UIView *rightline;
@property (weak, nonatomic) IBOutlet UIImageView *OnTopImage;


@end

@implementation BigImgContentCell

- (void)setAContent:(Content *)aContent
{
    _aContent = aContent ;
        
//    [_imgView photoFromQiNiu:aContent.cover] ;
  //  [_imgView setImageWithURL:[NSURL URLWithString:aContent.cover]] ;

    [_imgView setImageWithURL:[NSURL URLWithString:aContent.cover] options:YYWebImageOptionShowNetworkActivity];
    
    _labelTitle.text = aContent.title ;
    _labelKind.text = aContent.kindName ;
    _labelRead.text = [NSString stringWithFormat:@"阅 %d",aContent.readNum] ;
    _OnTopImage.hidden = !aContent.isTop ;
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
    CGFloat h_bigImage = (SCREEN_WIDTH - 10. * 2) * 398. / 705. ;
    
    return 10. + h_bigImage + 10. + h_title + 10 + 19 + 10 ;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    _imgView.layer.masksToBounds = YES ;
    
    _topline.backgroundColor = [UIColor theme_table_cellSeparatorColor] ;
    _leftline.backgroundColor = [UIColor theme_table_cellSeparatorColor] ;
    _rightline.backgroundColor = [UIColor theme_table_cellSeparatorColor] ;
    
    _labelTitle.textColor = [UIColor theme_news_table_cellTitleFontColor] ;

    _labelKind.backgroundColor = [UIColor clearColor] ;
    _labelKind.textColor = [UIColor theme_news_table_cellDescFontColor] ;
    _labelRead.textColor = [UIColor theme_news_table_cellDescFontColor] ;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
