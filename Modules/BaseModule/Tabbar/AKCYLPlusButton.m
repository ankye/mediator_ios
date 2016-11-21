//
//  AKCYLPlusButton.m
//  Project
//
//  Created by ankye on 2016/11/10.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKCYLPlusButton.h"

@interface AKCYLPlusButton()
{
    NSDictionary* _attributes;
}
@end

@implementation AKCYLPlusButton

-(void)setAttributes:(NSDictionary*)attributes
{
    _attributes = attributes;
    
}

-(NSDictionary*)getAttributes
{
    return _attributes;
}
    
+ (instancetype)defaultInstance
{
    static dispatch_once_t pred;
    static AKCYLPlusButton *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[AKCYLPlusButton alloc] init];
    });
    return sharedInstance;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (id)plusButton {
    
    AKCYLPlusButton *button = [AKCYLPlusButton defaultInstance] ;
    NSDictionary* attributes = [button getAttributes];
    UIImage *buttonImage = [UIImage imageNamed:attributes[CYLTabBarItemImage]];
    [button setImage:buttonImage forState:UIControlStateNormal];
  
    UIImage *buttonImageSelected = [UIImage imageNamed:attributes[CYLTabBarItemSelectedImage]];
    [button setImage:buttonImageSelected forState:UIControlStateSelected];
    
    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
   //     button.frame = CGRectMake(0.0, 0.0, 250, 100);
     //   button.backgroundColor = [UIColor redColor];
   [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight
{
    return 0.5f;
}

- (void)clickPublish {
    
}
@end
