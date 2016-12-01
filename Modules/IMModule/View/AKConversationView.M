//
//  TLConversationTableView.m
//  Project
//
//  Created by ankye on 2016/11/29.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "TLConversationView.h"
#import "TLConversationCell.h"

@implementation TLConversationView

-(id)init
{
    self = [super init];
    if(self){
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.tableView.dataSource = self;
        [self registerCellClass];
        
//        @weakify(self);
//        [RACObserve(self, data) subscribeNext:^(id  _Nullable x) {
//            @strongify(self);
//            if(self.data){
//                [self.tableView reloadData];
//            }
//        }];
        
        
    }
    return self;
}


- (void)registerCellClass
{
    [self.tableView registerClass:[TLConversationCell class] forCellReuseIdentifier:@"TLConversationCell"];
}


//MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLConversation *conversation = [self.data objectAtIndex:indexPath.row];
    TLConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLConversationCell"];
    [cell setConversation:conversation];
    [cell setBottomLineStyle:indexPath.row == self.data.count - 1 ? TLCellLineStyleFill : TLCellLineStyleDefault];
    
    return cell;
}

//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CONVERSATION_CELL;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    TLChatViewController *chatVC = [TLChatViewController sharedChatVC];
//    
//    TLConversation *conversation = [self.data objectAtIndex:indexPath.row];
//    if (conversation.convType == TLConversationTypePersonal) {
//        TLUser *user = [[TLFriendHelper sharedFriendHelper] getFriendInfoByUserID:conversation.partnerID];
//        if (user == nil) {
//            [UIAlertView bk_alertViewWithTitle:@"错误" message:@"您不存在此好友"];
//            return;
//        }
//        [chatVC setPartner:user];
//    }
//    else if (conversation.convType == TLConversationTypeGroup){
//        TLGroup *group = [[TLFriendHelper sharedFriendHelper] getGroupInfoByGroupID:conversation.partnerID];
//        if (group == nil) {
//            [UIAlertView bk_alertViewWithTitle:@"错误" message:@"您不存在该讨论组"];
//            return;
//        }
//        [chatVC setPartner:group];
//    }
//    [self setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:chatVC animated:YES];
//    [self setHidesBottomBarWhenPushed:NO];
//    
    // 标为已读
    [(TLConversationCell *)[self.tableView cellForRowAtIndexPath:indexPath] markAsRead];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLConversation *conversation = [self.data objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除"
                                                                       handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                       {
                                           [weakSelf.data removeObjectAtIndex:indexPath.row];
//                                           BOOL ok = [[TLMessageManager sharedInstance] deleteConversationByPartnerID:conversation.partnerID];
//                                           if (!ok) {
//                                               [UIAlertView bk_alertViewWithTitle:@"错误" message:@"从数据库中删除会话信息失败"];
//                                           }
                                           [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                           if (self.data.count > 0 && indexPath.row == self.data.count) {
                                               NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
                                               TLConversationCell *cell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
                                               [cell setBottomLineStyle:TLCellLineStyleFill];
                                           }
                                       }];
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                          title:conversation.isRead ? @"标为未读" : @"标为已读"
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {
                                            TLConversationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                            conversation.isRead ? [cell markAsUnread] : [cell markAsRead];
                                            [tableView setEditing:NO animated:YES];
                                        }];
    moreAction.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    return @[delAction, moreAction];
}


//横屏大小
-(CGSize)portraitSize
{
    return CGSizeMake(YYScreenSize().width, YYScreenSize().height/2.0);
}
//竖屏大小
-(CGSize)landscapeSize
{
    return CGSizeMake(YYScreenSize().height, YYScreenSize().width/2.0);
}

-(void)loadData:(NSObject*)data
{
    self.data = (NSMutableArray*)data;
    [self.tableView reloadData];
    
}
-(void)dealloc
{
    
}


@end
