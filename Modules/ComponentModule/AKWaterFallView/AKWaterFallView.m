//
//  XHSHomeViewController.m
//  小红书
//
//  Created by Aesthetic92 on 16/7/8.
//  Copyright © 2016年 Aesthetic92. All rights reserved.
//

#import "AKWaterFallView.h"

#import "XHSHomeCell.h"
#import "XHSHomeModel.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "CHTCollectionViewWaterfallLayout.h"

@interface AKWaterFallView () < UIScrollViewDelegate>




@end



@implementation AKWaterFallView

-(id)initWithFrame:(CGRect)frame
{
    AKCollectionWaterFallLayout *layout = [[AKCollectionWaterFallLayout alloc] init];

  
    layout.headerHeight = 0;            // headerView高度
    layout.footerHeight = 0;             // footerView高度
    layout.columnCount  = 2;             // 几列显示
    layout.minimumColumnSpacing    = 10;  // cell之间的水平间距
    layout.minimumInteritemSpacing = 8; // cell之间的垂直间距
    
//    layout.columns = 2;
//    layout.rowMargin = 10;
//    layout.colMargin = 10;
    layout.sectionInset = UIEdgeInsetsMake(6, 10, 10, 10);
    
 //   [layout autuContentSize];
    

 
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self){
        self.layout = layout;
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([XHSHomeCell class]) bundle:nil] forCellWithReuseIdentifier:identifier_XHSHomeCell];
        self.backgroundColor = [UIColor colorWithHexString:@"#f6f7f9"];
    }
    return self;
}


- (void)titleViewClick {
    
    NSLog(@"titleViewClick click...");
    
}

- (void)cameraClick {
    
    NSLog(@"camera opening...");
    
}


-(void)changeLayout:(AKCollectionWaterFallLayout*)layout
{

    [self setCollectionViewLayout:layout animated:YES completion:^(BOOL finished) {
        
    }];
    [self layoutIfNeeded];
    
}



@end
