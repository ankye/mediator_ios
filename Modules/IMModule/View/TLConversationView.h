//
//  TLConversationTableView.h
//  Project
//
//  Created by ankye on 2016/11/29.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPopupViewProtocol.h"

#define     HEIGHT_CONVERSATION_CELL        64.0f



@interface TLConversationView : UIView<UITableViewDelegate,UITableViewDataSource,AKPopupViewProtocol>


@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic,strong) UITableView* tableView;

@end
