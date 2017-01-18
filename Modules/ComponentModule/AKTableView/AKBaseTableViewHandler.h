//
//  XTTableViewRootHandler.h
//  XTMultipleTables
//
//  Created by TuTu on 15/12/7.
//  Copyright © 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AKDataHandlerProtocol.h"
#import "AKBaseTableHandlerDelegate.h"
#import "AKBaseTableView.h"

@interface AKBaseTableViewHandler : NSObject <AKDataHandlerProtocol>

@property (nonatomic,weak) id <AKBaseTableHandlerDelegate> handlerDelegate ;

@property (nonatomic,strong) dispatch_queue_t   myQueue ;


@property (nonatomic)        CGFloat        offsetY ;      // cache offsetY .
@property (nonatomic,strong) AKBaseTableView    *table ;

- (void)handleDatasourceAndDelegate:(UIView*)view ;

- (void)refreshOffsetY ;
- (void)refresh ;

- (NSString*)getTitle;

-(UITableViewCell*)getCell:(UITableView*)tableView withName:(NSString*)identifier;


@end
