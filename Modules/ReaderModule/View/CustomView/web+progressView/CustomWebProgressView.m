//
//  CustomWebProgressView.m
//  电动生活
//
//  Created by 陈行 on 15-12-17.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CustomWebProgressView.h"

@interface CustomWebProgressView()

@property(nonatomic,weak)WKWebView *webView;

@property(nonatomic,assign)double oldEstimatedProgress;

@end

@implementation CustomWebProgressView

+ (CustomWebProgressView *)progressViewAndFrame:(CGRect)frame andWebView:(WKWebView *)webView andDelegate:(id<CustomWebProgressViewDelegate>)delegate{
    return [[self alloc]initWithFrame:frame andWebView:webView andDelegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame andWebView:(WKWebView *)webView andDelegate:(id<CustomWebProgressViewDelegate>)delegate
{
    frame.origin.x=-[UIScreen mainScreen].bounds.size.width;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor greenColor];
        self.hidden=YES;
        self.delegate=delegate;
        self.webView=webView;
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)setEstimatedProgress:(CGFloat)estimatedProgress{
    
//    NSLog(@"---->%.2f",estimatedProgress);
    _estimatedProgress=estimatedProgress;
    self.hidden=NO;
    if(estimatedProgress==1){
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.frame;
            rect.origin.x=0;
            self.frame=rect;
//            CGSize size = self.webView.scrollView.contentSize;
//            NSLog(@"加载完毕-->%@",NSStringFromCGSize(size));
        } completion:^(BOOL finished) {
//            CGSize size = self.webView.scrollView.contentSize;
//            NSLog(@"加载完毕-->%@",NSStringFromCGSize(size));
            
            if([self.delegate respondsToSelector:@selector(webProgressViewLoadFinish:)]){
                [self.delegate webProgressViewLoadFinish:self];
            }
            
            [self freeWebProgressView];
            [self removeFromSuperview];
        }];
    }else{
        if(_estimatedProgress>=_oldEstimatedProgress){
//            CGSize size = self.webView.scrollView.contentSize;
//            NSLog(@"未加载完毕-->%@",NSStringFromCGSize(size));
            if (self.delegate && [self.delegate respondsToSelector:@selector(webProgressViewLoading:andProgress:)]) {
                [self.delegate webProgressViewLoading:self andProgress:estimatedProgress];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                CGRect rect = self.frame;
                rect.origin.x=(estimatedProgress-1)*[UIScreen mainScreen].bounds.size.width;
                self.frame=rect;
            } completion:^(BOOL finished) {
                _oldEstimatedProgress=estimatedProgress;
            }];
        }
    }
}

- (void)freeWebProgressView{
    @synchronized (self) {
        if(self.isRemoveObserver==false){
            self.isRemoveObserver=true;
            [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"estimatedProgress"]){
        double progress = [change[@"new"] doubleValue];
        self.estimatedProgress=progress;
    }
}

- (void)dealloc{
    [self freeWebProgressView];
}

@end
