//
//  AKBasePopupView.h
//  Project
//
//  Created by ankye on 2016/12/22.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPopupBaseAction.h"

@interface AKBasePopupView : UIView<AKPopupViewProtocol>

@property (nonatomic,strong) AKPopupOnClick onClick;
@property (nonatomic,strong) AKPopupOnClose onClose;


@end
