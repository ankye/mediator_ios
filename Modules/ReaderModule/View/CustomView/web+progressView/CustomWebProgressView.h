//
//  CustomWebProgressView.h
//  电动生活
//
//  Created by 陈行 on 15-12-17.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class CustomWebProgressView;

@protocol CustomWebProgressViewDelegate <NSObject>

- (void)webProgressViewLoadFinish:(CustomWebProgressView *)progressView;

@optional
- (void)webProgressViewLoading:(CustomWebProgressView *)progressView andProgress:(CGFloat)progress;


@end

@interface CustomWebProgressView : UIView

@property(nonatomic,assign)CGFloat estimatedProgress;

@property(nonatomic,assign)BOOL isRemoveObserver;

@property(nonatomic,weak)id<CustomWebProgressViewDelegate> delegate;

/**
 *  使用此方法进行加载
 *
 *  @param frame
 *  @param webView
 *
 */
+ (CustomWebProgressView *)progressViewAndFrame:(CGRect)frame andWebView:(WKWebView *)webView andDelegate:(id<CustomWebProgressViewDelegate>)delegate;

- (void)freeWebProgressView;

@end
