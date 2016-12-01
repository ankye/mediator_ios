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
    UserModel* user = (UserModel*)params[@"user"];
    UIView<AKPopupViewProtocol>* view = [[UserCardView alloc] init];
    NSMutableDictionary* popAttrs = [AKPopupManager buildPopupAttributes:NO showNav:NO style:STPopupStyleFormSheet onClick:^(NSInteger channel, NSMutableDictionary *attributes) {
        NSLog(@"Click");
    } onClose:^(NSMutableDictionary *attributes) {
        NSLog(@"complete");
    }];
    
    [[AKPopupManager sharedManager] showView:view withAttributes:popAttrs];
    [view loadData:user];
    
    return view;
}
@end
