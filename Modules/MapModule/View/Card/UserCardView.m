//
//  UserCardView.m
//  Project
//
//  Created by ankye on 2016/11/30.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "UserCardView.h"

@interface UserCardView()
{
    UserModel* _user;
    UIImageView* _avatarView;
    UILabel*    _nicknameLabel;
    UILabel*    _uidLabel;
    UILabel*    _distanceLabel;
    
}
@end

@implementation UserCardView

-(id)init
{
    self = [super init];
    if(self){
        [self setupViews];
        
    }
    return self;
}

-(void)setupViews
{
    _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    [self addSubview:_avatarView];
    _nicknameLabel = [[UILabel alloc] init];
    [self addSubview:_nicknameLabel];
    _uidLabel = [[UILabel alloc] init];
    [self addSubview:_uidLabel];
    _distanceLabel = [[UILabel alloc] init];
    [self addSubview:_distanceLabel];
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerX);
        make.top.mas_equalTo(self.top).mas_offset(30);
        make.size.mas_equalTo(CGSizeMake(78, 78));
    }];
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 添加右、下边距约束
        make.left.mas_equalTo(20);
        // 添加高度约束，让高度等于黑色view
        make.height.mas_equalTo(30);
        // 添加上边距约束（上边距 = 黑色view的下边框 + 偏移量20）
        make.top.equalTo(_avatarView.mas_bottom).offset(20);
        
        
    }];
    [_uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nicknameLabel.mas_bottom).mas_offset(10);
        make.width.equalTo(self);
         make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);

       
    }];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_uidLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(30);
         make.left.mas_equalTo(20);
        make.width.equalTo(self);
    }];
    
}
//横屏大小
-(CGSize)portraitSize
{
    return CGSizeMake(250, 260);
}
//竖屏大小
-(CGSize)landscapeSize
{
    return CGSizeMake(250, 260);
}

/**
 加载数据
 
 @param data 数据
 */
-(void)loadData:(NSObject*)data
{
    _user = (UserModel*)data;
    [self updateUser];
    
}

-(void)updateUser
{
    [_avatarView setImageWithURL: [NSURL URLWithString:_user.head]
                         placeholder:nil
                             options:kNilOptions
                             manager:[FileHelper avatarImageManager]
                            progress:nil
                           transform:nil
                          completion:nil];
    UserModel *me = [[AKMediator sharedInstance] user_me];
    
    if(_user.latitude == 0 && _user.longitude == 0){
        [_distanceLabel setText:@"地理位置未获取到"];
    }else{
        [ _distanceLabel setText: [NSString stringWithFormat:@"距离:%d米",[AppHelper getDistance:me.latitude longitude:me.longitude toLatitude:_user.latitude toLongitude:_user.longitude]]];
    }
    [_nicknameLabel setText:_user.nickname];
    [_uidLabel setText:[_user.uid stringValue]];

    
}
@end
