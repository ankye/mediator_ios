//
//  TLConversationTableView.m
//  Project
//
//  Created by ankye on 2016/11/29.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKConversationView.h"
#import "AKConversationCell.h"
#import "TLChatViewController.h"
#import "AKUser+ChatModel.h"

@implementation AKConversationView

-(id)init
{
    self = [super init];
    if(self){
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self registerCellClass];
    }
    return self;
}


- (void)registerCellClass
{
    [self.tableView registerClass:[AKConversationCell class] forCellReuseIdentifier:@"AKConversationCell"];
}


//MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AKConversation *conversation = [self.data objectAtIndex:indexPath.row];
    AKConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AKConversationCell"];
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
    
    AKConversation *conversation = [self.data objectAtIndex:indexPath.row];
    
    
    TLChatViewController *chatVC = [TLChatViewController sharedInstance];
 
  
    
    [chatVC setPartner:conversation.partner];
    
    [AK_POPUP_MANAGER push:chatVC];
    
 
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

-(void)loadData:(NSObject *)data
{
    self.data = (NSMutableArray*)data;
    [self.tableView reloadData];
}

-(void)dealloc
{
    
}
@end
