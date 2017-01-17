//
//  DetailViewController.h
//  redBook
//
//  Created by oujinlong on 16/6/3.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OUNavAnimation.h"
#import "XHSHomeModel.h"
@interface DetailViewController : UIViewController <OUNavAnimationDelegate>
-(instancetype)initWithModel:(XHSHomeModel*)model desImageViewRect:(CGRect)desRect;;
@end
