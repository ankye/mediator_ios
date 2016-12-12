//
//  AKUserPointAnnotation.h
//  Project
//
//  Created by ankye on 2016/11/24.
//  Copyright © 2016年 ankye. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface AKUserPointAnnotation : MAPointAnnotation

@property (nonatomic,strong) AKUser* user;

-(id)initWithUser:(AKUser*)user;

@end
