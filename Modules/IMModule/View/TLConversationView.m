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
