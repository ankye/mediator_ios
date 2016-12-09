//
//  TLChatViewController.m
//  TLChat
//
//  Created by 李伯坤 on 16/2/15.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLChatViewController.h"
#import "TLChatViewController+Delegate.h"
#import "TLChatDetailViewController.h"
#import "TLChatGroupDetailViewController.h"
#import "TLMoreKBHelper.h"
#import "TLEmojiKBHelper.h"
#import "TLChatBaseViewController+Proxy.h"


@interface TLChatViewController()

@property (nonatomic, strong) TLMoreKBHelper *moreKBhelper;

@property (nonatomic, strong) TLEmojiKBHelper *emojiKBHelper;

@property (nonatomic, strong) UIBarButtonItem *rightBarButton;

@end

@implementation TLChatViewController

SINGLETON_IMPL(TLChatViewController)

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:self.rightBarButton];

    
    self.contentSizeInPopup =CGSizeMake(YYScreenSize().width, YYScreenSize().height/2.0);
    self.landscapeContentSizeInPopup = CGSizeMake(YYScreenSize().height, YYScreenSize().width/2.0);
    
    self.user = (id<TLChatUserProtocol>)[TLUserHelper sharedHelper].user;
    self.moreKBhelper = [[TLMoreKBHelper alloc] init];
    [self setChatMoreKeyboardData:self.moreKBhelper.chatMoreKeyboardData];
    self.emojiKBHelper = [TLEmojiKBHelper sharedKBHelper];
    TLWeakSelf(self);
    [self.emojiKBHelper emojiGroupDataByUserID:[TLUserHelper sharedHelper].userID complete:^(NSMutableArray *emojiGroups) {
        [weakself setChatEmojiKeyboardData:emojiGroups];
    }];
    
    [AK_SIGNAL_MANAGER.onIMMessageReceived addObserver:self callback:^(typeof(self) self, TLMessage *message) {
        
        if(self.partner && [[message.fromUser chat_userID] isEqualToString:[self.partner chat_userID]]){
            [self receivedMessage:message];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)dealloc
{
    
    [AK_SIGNAL_MANAGER.onIMMessageReceived removeObserver:self];
#ifdef DEBUG_MEMERY
    NSLog(@"dealloc ChatVC");
#endif
}

#pragma mark - # Public Methods
- (void)setPartner:(id<TLChatUserProtocol>)partner
{
    [super setPartner:partner];
    if ([partner chat_userType] == TLChatUserTypeUser) {
        [self.rightBarButton setImage:[UIImage imageNamed:@"nav_chat_single"]];
    }
    else if ([partner chat_userType] == TLChatUserTypeGroup) {
        [self.rightBarButton setImage:[UIImage imageNamed:@"nav_chat_multi"]];
    }
}

#pragma mark - # Event Response
- (void)rightBarButtonDown:(UINavigationBar *)sender
{
    if ([self.partner chat_userType] == TLChatUserTypeUser) {
        TLChatDetailViewController *chatDetailVC = [[TLChatDetailViewController alloc] init];
        [chatDetailVC setUser:(TLUser *)self.partner];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatDetailVC animated:YES];
    }
    else if ([self.partner chat_userType] == TLChatUserTypeGroup) {
        TLChatGroupDetailViewController *chatGroupDetailVC = [[TLChatGroupDetailViewController alloc] init];
        [chatGroupDetailVC setGroup:(TLGroup *)self.partner];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatGroupDetailVC animated:YES];
    }
}

#pragma mark - # Getter
- (UIBarButtonItem *)rightBarButton
{
    if (_rightBarButton == nil) {
        _rightBarButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    }
    return _rightBarButton;
}
@end
