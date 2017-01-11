//
//  XHSHomeViewController.h
//  小红书
//
//  Created by Aesthetic92 on 16/7/8.
//  Copyright © 2016年 Aesthetic92. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKBaseCollectionView.h"
#import "AKCollectionFactory.h"

@interface AKWaterFallView : AKBaseCollectionView

@property(nonatomic, strong) AKCollectionLayout *layout;

-(id)initWithFrame:(CGRect)frame collectionViewLayout:( AKCollectionLayout *)layout;

-(void)changeLayout:(AKCollectionLayout*)layout;

@end
