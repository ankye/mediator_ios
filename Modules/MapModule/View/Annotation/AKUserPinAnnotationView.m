//
//  AKUserPinAnnotationView.m
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKUserPinAnnotationView.h"
#import "AKUserPointAnnotation.h"

@interface AKUserPinAnnotationView()

@property (nonatomic,strong) UIImageView* avatarView;
@property (nonatomic,strong) UILabel*    nicknameLabel;
@end



@implementation AKUserPinAnnotationView


-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.nicknameLabel = [[UILabel alloc] init];
        [self addSubview:self.nicknameLabel];
        
        [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(-20);
            make.centerX.mas_equalTo(self.centerX);
            make.size.mas_equalTo(CGSizeMake(100, 20));
            
        }];
        self.avatarView = [[UIImageView alloc] init];
        [self addSubview:self.avatarView];
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.centerX);
            make.size.mas_equalTo(CGSizeMake(34, 34));
            make.centerY.mas_equalTo(self.centerY).offset(-6);
        }];
       
        self.userInteractionEnabled = YES;
  
        [AK_SIGNAL_MANAGER.onUserFaceChange addObserver:self callback:^(typeof(self) self, UserModel *user) {
          
            if(user == self.user){
                [self updateFace];
            }
        }];
    }
    return self;
}

-(void)updateViews:(UserModel*)user
{
    if(user){
        self.user = user;
        self.canShowCallout   = NO;
        self.animatesDrop     = NO;
        self.draggable        = NO;
        if([self.user.sex integerValue] == 1){
            self.image            = [UIImage imageNamed:@"blugbgFace"];
        }else{
            self.image            = [UIImage imageNamed:@"pinkbgFace"];
        }
        [self.nicknameLabel setFont:[UIFont systemFontOfSize:12]];
        [self.nicknameLabel setTextColor:[UIColor blueColor]];
        [self.nicknameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.nicknameLabel setText:user.nickname];
        [self updateFace];
        
    }
}


-(void)updateFace
{
    [self.avatarView setImageWithURL: [NSURL URLWithString:_user.head]
                         placeholder:nil
                             options:kNilOptions
                             manager:[FileHelper avatarImageManager]
                            progress:nil
                           transform:nil
                          completion:nil];
}


-(void)dealloc
{
    self.user = nil;
    [AK_SIGNAL_MANAGER.onUserFaceChange removeObserver:self];
}
@end
