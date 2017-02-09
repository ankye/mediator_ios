//
//  AKPopupViewProtocol.h
//  Project
//
//  Created by ankye on 2016/11/15.
//  Copyright © 2016年 ankye. All rights reserved.
//

#ifndef AKPopupViewProtocol_h
#define AKPopupViewProtocol_h

#import "PopupModuleDefine.h"
#import "AKPopupBaseAction.h"

/**
 弹窗视图协议
 */
@protocol AKPopupViewProtocol <NSObject>



//横屏大小
-(CGSize)portraitSize;
//竖屏大小
-(CGSize)landscapeSize;

-(BOOL) isFullScreen;

/**
 加载数据

 @param data 数据
 */
-(void)loadData:(NSObject*)data;

@end







#endif /* AKPopupViewProtocol_h */
