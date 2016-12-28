//
//  XTMultipleTables.h
//  XTMultipleTables
//
//  Created by TuTu on 15/12/4.
//  Copyright © 2015年 teason. All rights reserved.
//


#import <UIKit/UIKit.h>

@class AKNewsChannel;
@class AKMutableView;

@protocol AKMutableViewDelegate <NSObject>

- (void)viewDidMovedAtIndex:(AKMutableView*)mutableView atIndex:(NSInteger)index ;

@end





@interface AKMutableView : UIScrollView

//@property (nonatomic,strong) NSArray     *list_handlers ; // Class `XTTableDataDelegate` objects list.

@property (nonatomic, weak) id <AKMutableViewDelegate>   akDelegate ;

@property (nonatomic,readonly) NSInteger currentIndex ;

- (void)mutableViewDidMoveAtIndex:(NSInteger)index;

- (void)pulldownCenterTableIfNeeded;

- (instancetype)initWithFrame:(CGRect)frame;

-(void)reloadHandlers:(NSMutableArray*)handlerList;

@end
