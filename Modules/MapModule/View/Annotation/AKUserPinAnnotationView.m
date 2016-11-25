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

@end



@implementation AKUserPinAnnotationView


-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self){
        self.avatarView = [[UIImageView alloc] init];
        [self addSubview:self.avatarView];
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
        
        [self.avatarView setImageWithURL: [NSURL URLWithString:user.head]
                                     placeholder:nil
                                         options:kNilOptions
                                         manager:[FileHelper avatarImageManager]
                                        progress:nil
                                       transform:nil
                                      completion:nil];
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.centerX);
            make.size.mas_equalTo(CGSizeMake(34, 34));
            make.centerY.mas_equalTo(self.centerY).offset(-6);
        }];
    }
}

-(void)dealloc
{
    self.user = nil;
}
@end
