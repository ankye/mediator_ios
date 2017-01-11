//
//  XHSHomeViewController.m
//  小红书
//
//  Created by Aesthetic92 on 16/7/8.
//  Copyright © 2016年 Aesthetic92. All rights reserved.
//

#import "AKWaterFallView.h"

//#import "XHSHomeCell.h"
//#import "XHSHomeModel.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "CHTCollectionViewWaterfallLayout.h"


@interface AKWaterFallView () < UIScrollViewDelegate>




@end



@implementation AKWaterFallView

-(id)initWithFrame:(CGRect)frame
{
    AKCollectionLayout* layout = [AKCollectionFactory createLayout:CollectionLayoutTypeOneCollum];
    return [self initWithFrame:frame collectionViewLayout:layout];
}

-(id)initWithFrame:(CGRect)frame collectionViewLayout:( AKCollectionLayout *)layout
{
       
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self){
        self.layout = layout;
        [[AKCollectionFactory sharedInstance] registerCellsToView:self];
        self.backgroundColor = [UIColor colorWithHexString:@"#f6f7f9"];
    }
    return self;
}


-(void)changeLayout:(AKCollectionLayout*)layout
{

    self.layout = layout;
    
    [self setCollectionViewLayout:layout animated:YES completion:^(BOOL finished) {
        
    }];
    [self layoutIfNeeded];
    
}



@end
