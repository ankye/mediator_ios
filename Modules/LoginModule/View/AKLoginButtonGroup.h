//
//  AKLoginButtonGroup.h
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AKLoginButtonGroupDelegate <NSObject>

-(void)onButtonClick:(NSUInteger)index;

@end


@interface AKLoginButtonGroup : UIView

@property(nullable, nonatomic, weak)id<AKLoginButtonGroupDelegate>   delegate;

-(void)updateButtonInfos:(nonnull NSArray*)btnInfo;

@end
