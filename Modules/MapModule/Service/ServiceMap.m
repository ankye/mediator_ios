//
//  ServiceMap.m
//  Project
//
//  Created by ankye on 2016/11/21.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import "ServiceMap.h"
#import "AKMapViewController.h"
#import "UserCardView.h"

@implementation ServiceMap

-(UIViewController*)fetchMapViewController:(NSDictionary *)params
{
    UIViewController* controller = [[AKMapViewController alloc] init];
    return controller;
}


-(UIView<AKPopupViewProtocol>*)popupUserCardView:(NSDictionary*)params
{
    AKUser* user = (AKUser*)params[@"user"];
    AKBasePopupView* view = [[UserCardView alloc] init];
    NSMutableDictionary* popAttrs = [AKPopupManager buildPopupAttributes:NO showNav:NO style:STPopupStyleFormSheet onClick:^(NSInteger channel, NSDictionary *attributes) {
        DDLogInfo(@"Click");
    } onClose:^(NSDictionary *attributes) {
        DDLogInfo(@"complete");
    }];
    
    [AK_POPUP_MANAGER showView:view withAttributes:popAttrs];
    [view loadData:user];
    
    return view;
}
@end
