//
//  AKBookDetailHandler.h
//  Project
//
//  Created by ankye on 2017/1/17.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKBaseTableViewHandler.h"
#import "Book.h"

@interface AKBookDetailHandler : AKBaseTableViewHandler

@property(nonatomic,strong)Book * book;
@property (nonatomic,strong)  NSArray       *datalist ;          //dataSource list , string .

@end
