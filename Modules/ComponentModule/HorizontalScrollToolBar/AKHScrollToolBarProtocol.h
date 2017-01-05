//
//  AKHScrollToolBarProtocol.h
//  Project
//
//  Created by ankye on 2017/1/4.
//  Copyright © 2017年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AKHScrollToolBarProtocol <NSObject>

-(NSString*)getTitle;

-(void)scrollToolBarDidSelectedAtIndex:(NSInteger)index;
-(void)scrollToolBarDidRepeatSelectedAtIndex:(NSInteger)index;

@end
