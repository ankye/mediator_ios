//
//  XHSHomeViewController.m
//  小红书
//
//  Created by Aesthetic92 on 16/7/8.
//  Copyright © 2016年 Aesthetic92. All rights reserved.
//

#import "AKWaterFallView.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import "CHTCollectionViewWaterfallLayout.h"


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
        
        [self addObserver:self
               forKeyPath:@"contentOffset"
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:nil] ;
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"contentOffset"
                 context:nil] ;
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] && object == self) {
        //        NSLog(@"change %@",change) ;
        id old = change[NSKeyValueChangeOldKey] ;
        id new = change[NSKeyValueChangeNewKey] ;
        if (![old isKindOfClass:[NSNull class]] && old != new) {
            CGFloat contentOffsetY = self.contentOffset.y ;
            if (self.offsetYHasChangedValue) {
                self.offsetYHasChangedValue(contentOffsetY) ;
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context] ;
    }
}


-(void)changeLayout:(AKCollectionLayout*)layout
{

    self.layout = layout;
    
    [self setCollectionViewLayout:layout animated:YES completion:^(BOOL finished) {
        
    }];
    [self layoutIfNeeded];
    
}



@end
