//
//  CustomShareView.m
//  powerlife
//
//  Created by 陈行 on 16/4/19.
//  Copyright © 2016年 陈行. All rights reserved.
//

#import "CustomShareView.h"

#import "AppDelegate.h"

#define SELFWIDTH [UIScreen mainScreen].bounds.size.width
#define SELFHEIGHT [UIScreen mainScreen].bounds.size.height
#define SHARE_IMAGE_PATH [NSString stringWithFormat:@"%@/Library/Caches/shareImage.png",NSHomeDirectory()]

#define DEFAULT_TITLE @"电动生活"

@interface CustomShareView()

@property (weak, nonatomic) IBOutlet UIView *shareContainerView;
@property (weak, nonatomic) IBOutlet UIButton *shareSina;
@property (weak, nonatomic) IBOutlet UIButton *shareQQ;
@property (weak, nonatomic) IBOutlet UIButton *shareWechat;
@property (weak, nonatomic) IBOutlet UIButton *shareMoment;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewWidthCon;

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;


//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sinaLeftCon;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqRightCon;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatRightCon;

@property(nonatomic,strong)OSMessage * qqMessage;
@property(nonatomic,strong)OSMessage * wechatMessage;
@property(nonatomic,strong)OSMessage * sinaMessage;

@end

@implementation CustomShareView

- (void)awakeFromNib{
    self.shareContainerView.layer.masksToBounds=YES;
    self.shareContainerView.layer.cornerRadius=10;
    
    self.cancleBtn.layer.masksToBounds=YES;
    self.cancleBtn.layer.cornerRadius=10;
    
    self.shareViewWidthCon.constant = WIDTH/320*288;
    
    //隐藏没有安装的应用
//    int count = 3;
//    BOOL qqIsIn=[OpenShare isQQInstalled];
//    BOOL sinaIsIn=[OpenShare isWeiboInstalled];
//    BOOL wechatIsIn=[OpenShare isWeixinInstalled];
//    CGFloat thirdBtnWidth = 45;
//    if (!qqIsIn) {
//        self.shareQQ.hidden=YES;
//        count--;
//    }
//    if (!sinaIsIn) {
//        self.shareSina.hidden=YES;
//        count--;
//    }
//    if (!wechatIsIn) {
//        self.shareWechat.hidden=YES;
//        count--;
//    }
//    if (count==2){
//        CGFloat spaceWidth = (288-2*thirdBtnWidth)/3;
//        if (self.shareSina.hidden) {
//            self.qqRightCon.constant=2*spaceWidth+thirdBtnWidth;
//            self.wechatRightCon.constant=spaceWidth;
//        }else if (self.shareQQ.hidden){
//            self.sinaLeftCon.constant=spaceWidth;
//            self.wechatRightCon.constant=spaceWidth;
//        }else{
//            self.sinaLeftCon.constant=spaceWidth;
//            self.qqRightCon.constant=spaceWidth;
//        }
//    }else if (count==1){
//        CGFloat spaceWidth = (288-thirdBtnWidth)/2;
//        if (!self.shareSina.hidden) {
//            self.sinaLeftCon.constant=spaceWidth;
//        }else if (!self.shareQQ.hidden){
//            self.qqRightCon.constant=spaceWidth;
//        }else{
//            self.wechatRightCon.constant=spaceWidth;
//        }
//    }
}

+ (instancetype)shareViewWithShareData:(UIImage *)shareData andDesc:(NSString *)shareDesc{
    NSString * nibName = NSStringFromClass([self class]);
    CustomShareView * shareView = [[[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil] lastObject];
    shareView.shareDesc=shareDesc;
    shareView.shareImage=shareData;
    
    for (int i=1; i<4; i++) {
        OSMessage * message=[[OSMessage alloc]init];
        message.title=DEFAULT_TITLE;
        message.image=shareData?:[UIImage imageNamed:@"login_logo"];
        message.link=@"http://www.powerlife.com.cn";
        message.multimediaType=OSMultimediaTypeNews;
        
        if (i==1) {
            shareView.sinaMessage=message;
        }else if (i==2){
            shareView.wechatMessage=message;
        }else if (i==3){
            shareView.qqMessage=message;
        }
    }
    
    /**
     *  
     powerlife, wxb9a49d70863e14e6, tencent1105078855, tencent1105078855.content, wb486975381
     */
    /**
     *  
     powerlife, wxd930ea5d5a258f4f, tencent1103194207, tencent1103194207.content, QQ41C1685F, wb402180334, renrenshare228525, fb776442542471056
     */
    
    return shareView;
}

- (void)setShareUrl:(NSString *)shareUrl{
    _shareUrl=shareUrl;
    self.qqMessage.link=shareUrl;
    self.wechatMessage.link=shareUrl;
    self.sinaMessage.link=shareUrl;
}

- (void)setShareDesc:(NSString *)shareDesc{
    _shareDesc=shareDesc;
    self.qqMessage.desc=shareDesc;
    self.sinaMessage.desc=shareDesc;
    self.wechatMessage.desc=shareDesc;
}

- (void)setShareImage:(UIImage *)shareImage{
    _shareImage=shareImage;
    self.qqMessage.image = shareImage?:[UIImage imageNamed:@"login_logo"];
    self.sinaMessage.image=shareImage?:[UIImage imageNamed:@"login_logo"];
    self.wechatMessage.image = shareImage?:[UIImage imageNamed:@"login_logo"];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:CGRectMake(0, 0, SELFWIDTH, SELFHEIGHT)];
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    NSInteger tag=sender.tag-100;
    if(tag==1){
        self.sinaMessage.desc=self.shareDesc?:DEFAULT_TITLE;
        [OpenShare shareToWeibo:self.sinaMessage Success:^(OSMessage *message) {
            self.hidden=YES;
        } Fail:^(OSMessage *message, NSError *error) {
            NSLog(@"%@",error);
            self.hidden=YES;
        }];
//        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
//        authRequest.redirectURI = SERVER_URL;
//        authRequest.scope = @"all";
//        
//        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:nil];
//        request.userInfo = @{@"shareURL":self.shareUrl};
//        request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
//        [WeiboSDK sendRequest:request];
        
        
    }else if (tag==2){
        self.qqMessage.desc=self.shareDesc?:DEFAULT_TITLE;
        self.qqMessage.thumbnail=[UIImage imageNamed:@"login_logo"];
        [OpenShare shareToQQFriends:self.qqMessage Success:^(OSMessage *message) {
            self.hidden=YES;
        } Fail:^(OSMessage *message, NSError *error) {
            NSLog(@"%@",error);
            self.hidden=YES;
        }];
    }else if (tag==3){
        self.wechatMessage.desc=self.shareDesc?:DEFAULT_TITLE;
        self.wechatMessage.title=DEFAULT_TITLE;
        [OpenShare shareToWeixinSession:self.wechatMessage Success:^(OSMessage *message) {
            self.hidden=YES;
        } Fail:^(OSMessage *message, NSError *error) {
            NSLog(@"%@",error);
            self.hidden=YES;
        }];
    }else if (tag==4){
        self.wechatMessage.title=self.shareDesc?:DEFAULT_TITLE;
        [OpenShare shareToWeixinTimeline:self.wechatMessage Success:^(OSMessage *message) {
            self.hidden=YES;
        } Fail:^(OSMessage *message, NSError *error) {
            NSLog(@"%@",error);
            self.hidden=YES;
        }];
    }
}

- (IBAction)cancleBtnClick:(UIButton *)sender {
    self.hidden=YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
@end
