//
//  AKLoginViewController.m
//  Project
//
//  Created by ankye on 2016/11/16.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKLoginViewController.h"
#import "AKLoginButtonGroup.h"

@interface AKLoginViewController ()

@property (nonatomic,strong) NSArray* loginBtnInfos;

//@property (nonatomic,strong) UIButton* returnButton;

@end

@implementation AKLoginViewController

-(id)init
{
    self = [super init];
    if(self){
        self.loginBtnInfos = [NSArray arrayWithObjects:
                              @{@"type":@(UMSocialPlatformType_QQ),@"title":@"QQ", @"nornal":@"denglu-qq",@"selected":@"denglu-qq"},
                              @{@"type":@(UMSocialPlatformType_WechatSession),@"title":@"微信", @"nornal":@"denglu-weix",@"selected":@"denglu-weix"},
                              //   @{@"type":@"phone",@"title":@"手机", @"nornal":@"denglu-phone",@"selected":@"denglu-phone"},
                              @{@"type":@(UMSocialPlatformType_Sina),@"title":@"微博", @"nornal":@"denglu-xinlang",@"selected":@"denglu-xinlang"},
                              nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)setupViews
{
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default"]];
    
    [self.view addSubview:bg];
    
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [bg addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(bg);
    }];
    
    
    
    AKLoginButtonGroup* buttonGroup = [[AKLoginButtonGroup alloc] init];
    buttonGroup.delegate = self;
    [buttonGroup updateButtonInfos:self.loginBtnInfos];
    
    [self.view addSubview:buttonGroup];
    [buttonGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-50);
        make.height.mas_equalTo(80);
    }];
    
    
}

-(void)onButtonClick:(NSUInteger)index
{
    if(index < [self.loginBtnInfos count]){
        NSDictionary* dic = [self.loginBtnInfos objectAtIndex:index];
        
        UMSocialPlatformType platformType = [dic[@"type"] integerValue];
        
        @weakify(self);
        [AK_MEDIATOR share_getUserInfoForPlatform:platformType withController:self withCompletion:^(UMSocialUserInfoResponse *userinfo, NSError *error) {
            
           
            @strongify(self);
            [AK_REQUEST_MANAGER login_requestThridLoginWithOpenID:userinfo.openid withToken:userinfo.accessToken withPlatformType:platformType Success:^(__kindof YTKBaseRequest * _Nonnull request) {
                @strongify(self);
                NSData* jsonData = request.responseData;
                NSDictionary* response = [AppHelper dictionaryWithData:jsonData];
                NSLog(@"request login success %@",response);
            
                if([response[@"errcode"] integerValue] == 0){
                    NSDictionary* dic = response[@"data"];
                    NSString* uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
                    AKUser* user = [AK_MEDIATOR user_getUserInfo:uid];
                    
                    user.uid = uid;
                    user.avatar = dic[@"head"];
                    user.avatarHD = dic[@"head_640"];
                    user.lastLoginTime = @([AppHelper getTimestampFromString:dic[@"last_login_time"]]);
                    user.money = @([dic[@"money"] integerValue]);
                    user.nickname = dic[@"nickname"];
                    [GVUserDefaults standardUserDefaults].token = dic[@"token"];
                    [GVUserDefaults standardUserDefaults].uid = dic[@"uid"];
//                    NSNumber* time = @([dic[@"imtime"] integerValue]);
//                    
//                    [GVUserDefaults standardUserDefaults].imTime = time;
//                    [GVUserDefaults standardUserDefaults].imToken = dic[@"imtoken"];
                    
                    user.usernum = dic[@"usernum"];
                    user.detail.sex = [dic[@"sex"] integerValue];
                    user.detail.address = dic[@"address"];
                    user.detail.birthday = dic[@"birthday"];
                    user.detail.hometown = dic[@"hometown"];
                    
                    [AK_MEDIATOR user_loginSuccess:user];
                    [self didTappedReturnButton:nil];
                }else{
                    NSString *message = [NSString stringWithFormat:@"[%@]请重试!\n",response[@"msg"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录异常"
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSLog(@"Failed");
            }];
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


//- (UIButton *)returnButton
//{
//    if (_returnButton == nil) {
//        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_returnButton addTarget:self action:@selector(didTappedReturnButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_returnButton setTitle:@"return" forState:UIControlStateNormal];
//        [_returnButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    }
//    return _returnButton;
//}

#pragma mark - event response
- (void)didTappedReturnButton:(UIButton *)button
{
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)dealloc
{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
