//
//  TLConversationCell.m
//  TLChat
//
//  Created by 李伯坤 on 16/1/23.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "AKConversationCell.h"
#import <UIImageView+WebCache.h>


#define     CONV_SPACE_X            10.0f
#define     CONV_SPACE_Y            9.5f
#define     REDPOINT_WIDTH          10.0f

@interface AKConversationCell()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *remindImageView;

@property (nonatomic, strong) UIView *redPointView;

@end

@implementation AKConversationCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftSeparatorSpace = CONV_SPACE_X;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.remindImageView];
        [self.contentView addSubview:self.redPointView];
        
        [self p_addMasonry];
    }
    return self;
}

#pragma mark - Public Methods
- (void) setConversation:(AKConversation *)conversation
{
    _conversation = conversation;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:conversation.partner.avatar] placeholderImage:nil];

    AKUser* me = [AK_MEDIATOR user_me];
   
    [self.usernameLabel setText:conversation.partner.nickname];
    int distance = [AppHelper getDistance:me.detail.latitude longitude:me.detail.longitude toLatitude:conversation.partner.detail.latitude toLongitude:conversation.partner.detail.longitude];
    if(conversation.partner.detail.longitude == 0 && conversation.partner.detail.latitude == 0){
        conversation.content = [NSString stringWithFormat:@"定位未获取,请稍后"];
    }else{
        conversation.content = [NSString stringWithFormat:@"距离  :%d 米",distance];
    }
    [self.detailLabel setText:conversation.content];
    
    [self.timeLabel setText:[conversation.partner.lastLoginTime stringValue]];
    
    switch (conversation.remindType) {
        case TLMessageRemindTypeNormal:
            [self.remindImageView setHidden:YES];
            break;
        case TLMessageRemindTypeClosed:
            [self.remindImageView setHidden:NO];
            [self.remindImageView setImage:[UIImage imageNamed:@"conv_remind_close"]];
            break;
        case TLMessageRemindTypeNotLook:
            [self.remindImageView setHidden:NO];
            [self.remindImageView setImage:[UIImage imageNamed:@"conv_remind_notlock"]];
            break;
        case TLMessageRemindTypeUnlike:
            [self.remindImageView setHidden:NO];
            [self.remindImageView setImage:[UIImage imageNamed:@"conv_remind_unlike"]];
            break;
        default:
            break;
    }
    
    self.conversation.isRead ? [self markAsRead] : [self markAsUnread];
}


/**
 *  标记为未读
 */
- (void) markAsUnread
{
    if (_conversation) {
        switch (_conversation.clueType) {
            case TLClueTypePointWithNumber:
                
                break;
            case TLClueTypePoint:
                [self.redPointView setHidden:NO];
                break;
            case TLClueTypeNone:
                
                break;
            default:
                break;
        }
    }
}

/**
 *  标记为已读
 */
- (void) markAsRead
{
    if (_conversation) {
        switch (_conversation.clueType) {
            case TLClueTypePointWithNumber:
                
                break;
            case TLClueTypePoint:
                [self.redPointView setHidden:YES];
                break;
            case TLClueTypeNone:
                
                break;
            default:
                break;
        }
    }
}

#pragma mark - Private Methods -
- (void)p_addMasonry
{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CONV_SPACE_X);
        make.top.mas_equalTo(CONV_SPACE_Y);
        make.bottom.mas_equalTo(- CONV_SPACE_Y);
        make.width.mas_equalTo(self.avatarImageView.mas_height);
    }];
    
    [self.usernameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(CONV_SPACE_X);
        make.top.mas_equalTo(self.avatarImageView).mas_offset(2.0);
        make.right.mas_lessThanOrEqualTo(self.timeLabel.mas_left).mas_offset(-5);
    }];
    
    [self.detailLabel setContentCompressionResistancePriority:110 forAxis:UILayoutConstraintAxisHorizontal];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.avatarImageView).mas_offset(-2.0);
        make.left.mas_equalTo(self.usernameLabel);
        make.right.mas_lessThanOrEqualTo(self.remindImageView.mas_left);
    }];
    
    [self.timeLabel setContentCompressionResistancePriority:300 forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameLabel);
        make.right.mas_equalTo(self.contentView).mas_offset(-CONV_SPACE_X);
    }];
    
    [self.remindImageView setContentCompressionResistancePriority:310 forAxis:UILayoutConstraintAxisHorizontal];
    [self.remindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.timeLabel);
        make.centerY.mas_equalTo(self.detailLabel);
    }];
    
    [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.avatarImageView.mas_right).mas_offset(-2);
        make.centerY.mas_equalTo(self.avatarImageView.mas_top).mas_offset(2);
        make.width.and.height.mas_equalTo(REDPOINT_WIDTH);
    }];
}

#pragma mark - Getter
- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView.layer setCornerRadius:3.0f];
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel
{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
     //   [_usernameLabel setFont:[UIFont fontConversationUsername]];
    }
    return _usernameLabel;
}

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
    //    [_detailLabel setFont:[UIFont fontConversationDetail]];
      //  [_detailLabel setTextColor:[UIColor colorTextGray]];
    }
    return _detailLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
      //  [_timeLabel setFont:[UIFont fontConversationTime]];
      //  [_timeLabel setTextColor:[UIColor colorTextGray1]];
    }
    return _timeLabel;
}

- (UIImageView *)remindImageView
{
    if (_remindImageView == nil) {
        _remindImageView = [[UIImageView alloc] init];
        [_remindImageView setAlpha:0.4];
    }
    return _remindImageView;
}

- (UIView *)redPointView
{
    if (_redPointView == nil) {
        _redPointView = [[UIView alloc] init];
        [_redPointView setBackgroundColor:[UIColor redColor]];
        
        [_redPointView.layer setMasksToBounds:YES];
        [_redPointView.layer setCornerRadius:REDPOINT_WIDTH / 2.0];
        [_redPointView setHidden:YES];
    }
    return _redPointView;
}

@end
