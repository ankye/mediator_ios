//
//  UIImageView+QNExtention.m
//  pro
//
//  Created by TuTu on 16/9/12.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "UIImageView+QNExtention.h"
//#import "UIImageView+WebCache.h"
#import <YYKit/UIImageView+YYWebImage.h>

@implementation UIImageView (QNExtention)

- (void)photoFromQiNiu:(NSString *)imgUrl
{    
 //   [self setImageWithURL:[NSURL URLWithString:imgUrl]] ;
    
        [self setImageWithURL:[NSURL URLWithString:imgUrl]
                        options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation];
}




@end
