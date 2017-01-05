//
//  ChildViewController.m
//  ZKHorizontalScrollToolBar
//
//  Created by 郑凯 on 2016/11/30.
//  Copyright © 2016年 tzktzk1. All rights reserved.
//

#import "AKHContentView.h"
#import "AKHScrollToolBarHeader.h"


@implementation AKHContentView


-(void)setContentView:(id<AKDataViewProtocol>)view
{
    self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    if(_contentView){
        [((UIView*)_contentView) removeFromSuperview];
        _contentView = nil;
    }
    _contentView = view;
    [(UIView*)view setFrame:self.frame];
    [self addSubview:(UIView*)_contentView];
    
}


-(void)setHandler:(id<AKDataHandlerProtocol>)handler
{
    _handler = handler;
    if(_handler){
         [_handler handleDatasourceAndDelegate:_contentView] ;
    }
 
}

-(void)scrollToolBarDidSelectedAtIndex:(NSInteger)index
{
    if(![self.handler hasDataSource]){
        [self.handler refresh];
    }
}

-(void)scrollToolBarDidRepeatSelectedAtIndex:(NSInteger)index
{
    
}

-(NSString*)getTitle
{
    return [self.handler getTitle];
}


@end
