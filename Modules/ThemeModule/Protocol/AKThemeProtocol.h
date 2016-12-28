//
//  AKThemeProtocol.h
//  Project
//
//  Created by ankye on 2016/12/27.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AKThemeProtocol <NSObject>

- (void)configureViews;

- (void)registerThemeObserver;

- (void)unregisterThemeObserver;

@end
