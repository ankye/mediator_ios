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

@interface AKTableViewHandler : NSObject <AKDataHandlerProtocol>

@property (nonatomic)        CGFloat        offsetY ;      // cache offsetY .
@property (nonatomic,strong) UITableView    *table ;

- (void)handleDatasourceAndDelegate:(UIView*)view ;

- (void)refreshOffsetY ;
- (void)refresh ;

- (NSString*)getTitle;
@end
