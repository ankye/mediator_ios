//
//  YXSpritesLoadingView.h
//  Gogobot-iOS
//
//  Created by Yin Xu on 05/14/14.
//  Copyright (c) 2014 Yin Xu. All rights reserved.
//

#import "YXSpritesLoadingView.h"
#import "FBShimmering/FBShimmeringView.h"

@implementation YXSpritesLoadingView

{
    
    UIView *loaderView;
    UIImageView *loadingImageView;
    FBShimmeringView *shimmeringView;
    UILabel *loadingLabel;
    UIWindow *window;
    int adjustHeightForLoader; //when we set shouldBlockCurrentViewUserIntercation to YES
                               //we leave 64 pixel on the top of the screen for the nav bar
                               //so we need adjust the center point of loader
    
//    UIView      *m_blackBackView ;
    
}

#pragma mark - Class Methods
+ (YXSpritesLoadingView *)sharedInstance
{
	static dispatch_once_t once = 0;
	static YXSpritesLoadingView *sharedInstance;
	dispatch_once(&once, ^{
        sharedInstance = [[YXSpritesLoadingView alloc] init];
    });
    

	return sharedInstance;
}

+ (void)show
{
	[[self sharedInstance] loadingViewSetupWithText:nil andShimmering:YES andBlur:YES];
}

+ (void)showWithText:(NSString *)text
{
    [[self sharedInstance] loadingViewSetupWithText:text andShimmering:YES andBlur:YES];
}

+ (void)showWithText:(NSString *)text andShimmering:(BOOL)shimmering andBlurEffect:(BOOL)blur
{
//    [[self sharedInstance] addBack] ;
//
    [[self sharedInstance] loadingViewSetupWithText:text andShimmering:shimmering andBlur:blur];
}

//- (void)addBack
//{
//    if (m_blackBackView == nil)
//    {
//        static float y = 20+44 ;
//        m_blackBackView = [[UIView alloc] initWithFrame:CGRectMake(0, y, APPFRAME.size.width, APPFRAME.size.height - y)] ;
//        m_blackBackView.tag = 4779944 ;
//        m_blackBackView.backgroundColor = nil ;
//    }
//
//    
//    NSArray *windowSubs = [window subviews] ;
//    
//    BOOL bHas = NO ;
//    
//    for (UIView *sub in windowSubs)
//    {
//        if (sub.tag == 4779944)
//        {
//            bHas = YES ;
//        }
//    }
//    
//    if (bHas)
//    {
//        [m_blackBackView removeFromSuperview] ;
//    }
//    else
//    {
//        [window addSubview:m_blackBackView] ;
//    }
//    
//}

+ (void)dismiss
{
//    NSLog(@"[[self sharedInstance]->window subviews] : %@",[[self sharedInstance]->window subviews]) ;
//
//    [[self sharedInstance] removeBack] ;
//
    [[self sharedInstance] loadingViewHide];
}

//- (void)removeBack
//{
//    [m_blackBackView removeFromSuperview] ;
//}


#pragma mark - Initialization Methods
- (id)init
{
    self = [super initWithFrame: [UIScreen mainScreen].bounds];
    self.backgroundColor = [UIColor clearColor];
	id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    window = [delegate respondsToSelector:@selector(window)] ? [delegate performSelector:@selector(window)] : [[UIApplication sharedApplication] keyWindow];
//	self.alpha = 0;
	return self;
}

#pragma mark - Helper Methods
- (void)loadingViewSetupWithText:(NSString *)text andShimmering:(BOOL)shimmering andBlur:(BOOL)blur
{
    if (!loadingImageView)
    {
        loaderView = [[UIView alloc]init];
        int height = 0;
        if (text && ![text isEqualToString:@""]) {
            height = [self getTextHeight:text andFont:[UIFont fontWithName:loadingTextFontName size:loadingTextFontSize] andWidth:loaderBackgroundWidth - (loadingTextLabelSideMargin * 2)] + 1;
            loaderView.frame = CGRectMake((self.frame.size.width - loaderBackgroundWidth) / 2,
                                              (self.frame.size.height - loaderBackgroundHeight - height) / 2 - adjustHeightForLoader,
                                              loaderBackgroundWidth,
                                              loaderBackgroundHeight + height + loadingTextLabelBottomMargin);
            
            
            if (shimmering) {
                shimmeringView = [[FBShimmeringView alloc] init];
                shimmeringView.frame = CGRectMake(loadingTextLabelSideMargin,
                                                  loaderView.frame.size.height - height - loadingTextLabelBottomMargin,
                                                  loaderView.frame.size.width - (loadingTextLabelSideMargin * 2),
                                                  height);
                shimmeringView.shimmeringOpacity        = 0.1;
                shimmeringView.shimmeringSpeed          = 250;              //3500;//250
                shimmeringView.shimmeringHighlightWidth = 3.2;              //1.2;
                loadingLabel = [[UILabel alloc]initWithFrame:shimmeringView.bounds];
                shimmeringView.contentView = loadingLabel;
                [loaderView addSubview:shimmeringView];
                shimmeringView.shimmering = YES;
            }
            else
            {
                loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(loadingTextLabelSideMargin,
                                                                        loaderView.frame.size.height - height - loadingTextLabelBottomMargin,
                                                                        loaderView.frame.size.width - (loadingTextLabelSideMargin * 2),
                                                                        height)];
                [loaderView addSubview:loadingLabel];

            }
            
            loadingLabel.font = [UIFont fontWithName:loadingTextFontName size:loadingTextFontSize];
            loadingLabel.textAlignment = NSTextAlignmentCenter;
            loadingLabel.text = text;
            loadingLabel.textColor = loadingTextColor;
            loadingLabel.numberOfLines = 0;
        }
        else
        {
            loaderView.frame = CGRectMake((self.frame.size.width - loaderBackgroundWidth) / 2, (self.frame.size.height - loaderBackgroundWidth) / 2 - adjustHeightForLoader, loaderBackgroundWidth, loaderBackgroundWidth);
        }
        
        loaderView.layer.cornerRadius = loaderCornerRadius;
        loaderView.backgroundColor = loaderBackgroundColor;
        
        loadingImageView = [[UIImageView alloc] init];
                
        CGRect frame = loadingImageView.frame;
        frame.size.width = animationImageWidth;
        frame.size.height = animationImageHeight;
        frame.origin.x = (loaderView.frame.size.width - animationImageWidth) / 2;
        frame.origin.y = (loaderView.frame.size.height - animationImageHeight - height) / 2;
        
        loadingImageView.frame = frame;
        loadingImageView.contentMode = UIViewContentModeCenter;
        
        loadingImageView.layer.zPosition = MAXFLOAT;
        loadingImageView.animationImages = [self imagesForAnimating];
        loadingImageView.animationDuration = cycleAnimationDuration;
        [loaderView addSubview:loadingImageView];
        
        
        //        半透明
//        if (blur) {
//            UIToolbar *blurView = [[UIToolbar alloc]initWithFrame:loaderView.bounds];
//            [blurView setTintColor:[UIColor clearColor]];
//            [loaderView insertSubview:blurView atIndex:0];
//            blurView.translucent = YES;
//            blurView.layer.cornerRadius = loaderCornerRadius;
//            blurView.layer.masksToBounds = YES;
//        }
        
        [loadingImageView startAnimating];
    }
    
    if ([text isEqualToString:@""]) {
        loaderView.backgroundColor = loaderBackgroundColor ;
    } else {
        loaderView.backgroundColor = loaderBackgroundColor2 ;
    }
    
    
    if (loaderView.superview == nil)
    {
        [window addSubview:loaderView];
    }
    
//    loaderView.alpha = 0.0f;
    float flex = 1.0 ;  //1.5
    loaderView.transform = CGAffineTransformScale(loaderView.transform, flex, flex);
    
    [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
//        loaderView.alpha = 1.0f;
        loaderView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished)
     {
//         self.alpha = 1;
     }];
}

- (void)loadingViewHide
{

    
		[UIView animateWithDuration:0.30 delay:0.2f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            //loaderView.transform = CGAffineTransformScale(loaderView.transform, 1.5, 1.5);
//			loaderView.alpha = 0;
		} completion:^(BOOL finished) {
//             self.alpha = 0;
            [loadingImageView removeFromSuperview];
            [loadingImageView stopAnimating];
            loadingImageView = nil;
            
            [loadingLabel removeFromSuperview];
            loadingLabel = nil;
            
            [shimmeringView removeFromSuperview];
            shimmeringView = nil;
        
            [loaderView removeFromSuperview];
            loaderView = nil;
            
//            self.alpha = 0;
        }];

}

- (NSArray *)imagesForAnimating
{
    NSMutableArray *retVal = [NSMutableArray array];

    for(int i = 1; i < numberOfFramesInAnimation + 1; i++)
    {
        [retVal addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",spriteNameString, i]]];
    }
    return retVal;
}

- (int)getTextHeight:(NSString*)text andFont: (UIFont *)font andWidth:(float)width {
    CGSize constrain = CGSizeMake(width, 1000000);
    return [text boundingRectWithSize:constrain options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:Nil].size.height;
}


@end
