//
//  AKMediator+MapModule.m
//  Project
//
//  Created by ankye on 2016/11/18.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "AKMediator+MapModule.h"

NSString * const kAKMMapModuleService = @"Map";
NSString * const kAKMMapModuleFetchVC = @"fetchMapViewController";
NSString * const kAKMMapModulePopupUserCardView = @"popupUserCardView";


@implementation AKMediator (MapModule)



- (UIViewController *)map_viewController
{
    
    UIViewController* viewController = [self performService:kAKMMapModuleService action:kAKMMapModuleFetchVC params:@{@"key":@"value"} shouldCacheService:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

-(UIView<AKPopupViewProtocol>*)map_popUserCardView:(AKUser*)user
{
    UIView<AKPopupViewProtocol>* view = [self performService:kAKMMapModuleService action:kAKMMapModulePopupUserCardView params:@{@"user":user} shouldCacheService:NO];
    return view;
}

@end
