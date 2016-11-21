//
//  AKADView.h
//  Project
//
//  Created by ankye on 2016/11/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKADView : UIView<AKPopupViewProtocol>

-(id)initWithColor:(UIColor*)color;
//横屏大小
-(CGSize)portraitSize;
//竖屏大小
-(CGSize)landscapeSize;


@end
